provider "aws" {
  profile = "default"
  version = "~> 2.44"
}

terraform {
  required_version = "~> 0.12.0"
  # ~>: pessimistic constraint operator.
  # Example: for ~> 0.9, this means >= 0.9, < 1.0.
  # Example: for ~> 0.8.4, this means >= 0.8.4, < 0.9

  backend "s3" {
    bucket = "shimpeiws-terraform-s3-host"
    key    = "dev/terraform.tfstate"
  }
}

module "basic-auth-lambda" {
  source   = "../modules/basic-auth-lambda"
  env_name = "dev"
}

module "web-hosting" {
  source        = "../modules/web-hosting"
  env_name      = "dev"
  cf_ssl_cert   = "arn-to-certificate"
  cost_center   = "terraform-s3-host-dev"
  domain_name   = "your-own-domain"
  hostedzone_id = "your-own-hosted-zone-id"
  domain_cnames = ["your-own-domain"]
  basic_auth_required             = true
  basic_auth_lambda_qualified_arn = module.basic-auth-lambda.basic_auth_lambda_qualified_arn
}
