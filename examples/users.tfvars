```
variable "users" {}
variable "sso_groups" {}
variable "impersonated_user_email" {}
variable "credentials" {}
variable "password" {}
variable "identity_store_id" {}

module "aws-sso" {
  source = "github.com/opsteamhub/terraform-aws-sso-users-with-gsuite"

  users                   = var.users
  sso_groups              = var.sso_groups
  impersonated_user_email = var.impersonated_user_email
  credentials             = var.credentials
  password                = var.password
  identity_store_id       = var.identity_store_id
}
```