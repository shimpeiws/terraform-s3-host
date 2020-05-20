## Before run terraform

- Create a S3 bucket for terraform(In this example "shimpeiws-terraform-s3-host" is setted)

- AWS Certificate Manager で SSL 証明書を発行する
- Terraform の実行に必要な権限の揃った AWS キーをセットしておく
  - AWS_ACCESS_KEY_ID、AWS_SECRET_ACCESS_KEY、AWS_REGION の環境変数が設定済みであることを前提にします (.envrc.example 参照)

## module "web-hosting" の設定値

dev/main.tf などの module "web-hosting" の設定値を環境に合わせてセットします

- source = "../modules/web-hosting"
  - 変更の必要なし
- env_name = "dev"
  - 環境毎にセット
- cf_ssl_cert
  - 事前に AWS Certificate Manager で作成した SSL 証明書の ARN
- cost_center
  - 各リソースに設定される tag に使われるので任意の名称をつけて OK です
- domain_name
  - サイトをホストするドメイン名をセットします
- hostedzone_id
  - ドメインを管理している Route53 の hosted zone id をセットします
- domain_cnames
  - サイトをホストするドメインをセットします、domain_name と同じになります
  - example.com と www.example.com など CNAME を設定しておきたいドメインがある場合には複数セットします
- basic_auth_required
  - dev や staging など basic 認証が必要な環境で true にします
  - true の場合、CloudFormation に Basic 認証用の Lambda エッジがセットされます
- basic_auth_lambda_qualified_arn
  - basic_auth_required = true の場合必要です
  - 設定値は module.basic-auth-lambda.basic_auth_lambda_qualified_arn のままで良い

## commands

`docker-compose run --rm terraform init`

`docker-compose run --rm terraform plan`

`docker-compose run --rm terraform apply`

`docker-compose run --rm terraform destroy`
