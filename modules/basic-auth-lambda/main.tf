provider "aws" {
  region = "us-east-1"
  alias  = "region-us-east-1"
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_edge_role" {
  name = "terraform-s3-hosting-${var.env_name}-lambda-edge-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy" "lambda_access_policy" {
  name   = "terraform_s3_hosting_${var.env_name}_lambda_access_policy"
  role   = aws_iam_role.lambda_edge_role.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:CreateLogGroup",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    }
  ]
}
POLICY
}

data "archive_file" "basic_auth" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/basicAuth"
  output_path = "${path.module}/lambda/dst/basicAuth.zip"
}

resource "aws_lambda_function" "basic_auth" {
  provider         = aws.region-us-east-1
  filename         = data.archive_file.basic_auth.output_path
  function_name    = "terraform-s3-host-${var.env_name}-basic-auth"
  role             = aws_iam_role.lambda_edge_role.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.basic_auth.output_base64sha256
  runtime          = "nodejs12.x"

  publish = true

  memory_size = 128
  timeout     = 3
}

resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/terraform-s3-host-${var.env_name}-basic-auth"
  retention_in_days = 180
}
