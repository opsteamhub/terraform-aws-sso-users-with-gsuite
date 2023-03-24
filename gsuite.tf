resource "gsuite_group" "group" {
  for_each = var.sso_groups

  email       = join("@", [each.key, "ops.team"])
  name        = each.key
  description = lookup(each.value, "description", null)
}

resource "gsuite_user" "users" {
  for_each = { for k, v in var.users :
    k => v if try(v["create_gsuite_email"], false) == true
  }
  name = {
    family_name = each.value["family_name"] == "" ? title(replace(try(regex("\\..*@", each.key), ""), "/[\\.|@]/", "")) : each.value["family_name"]
    given_name  = each.value["given_name"] == "" ? title(regex("^[a-z]*", each.key)) : each.value["given_name"]
  }
  password = var.password

  primary_email = each.key

  # If omitted or `true` existing GSuite users defined as Terraform resources will be imported by `terraform apply`.
  update_existing = each.value["update_existing"]
  is_suspended    = each.value["is_suspended"]
}


resource "gsuite_group_members" "members" {
  for_each = { for pair in local.group_membership : "${pair.user_name}.gsuite.${pair.group_name}" => pair }

  group_email = gsuite_group.group[each.value.group_name].email
 
  depends_on = [
    gsuite_user.users,
    gsuite_group.group
  ]

  member {
    email = each.value.user_name
    role  = "MEMBER"
  }
}

