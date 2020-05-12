variable "env_name" {
  description = "Environment name"
  type        = string
}
variable "cost_center" {
  description = "Cost Center"
  type        = string
}
variable "cf_ssl_cert" {
  description = "Cloudfront SSL certificate ARN. has to be in N.Virginia Region"
  type        = string
}
variable "domain_name" {
  description = "Domain Name"
  type        = string
}
variable "hostedzone_id" {
  description = "Hosted Zone ID of the domain"
  type        = string
}
variable "domain_cnames" {
  description = "the cnames for the domain. If set certificate must exist"
  type        = list(string)
}

