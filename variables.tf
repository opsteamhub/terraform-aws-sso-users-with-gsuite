variable "region" {
  default = "us-east-1"
}

variable "impersonated_user_email" {}

variable "credentials" {}

variable "identity_store_id" {}

variable "password" {}

variable "sso_groups" {
  description = "A map of AWS SSO groups"
  type = map(object({
    description = optional(string)
  }))
}

variable "users" {
  type = map(object({
    user_name           = optional(string)
    given_name          = optional(string, "")
    family_name         = optional(string, "")
    display_name        = optional(string, "")
    sso_groups          = list(string)
    create_gsuite_email = optional(bool, false)
    is_suspended        = optional(bool, false)
    update_existing     = optional(bool, true)
    sso_access          = optional(bool, false)
  }))
  default = {}
}



