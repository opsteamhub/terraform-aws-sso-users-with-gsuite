locals {
  group_membership = flatten([
    for user_name, user_attr in var.users : [
      for group_name in user_attr.sso_groups : {
        user_name  = user_name
        group_name = group_name
      } if user_attr.sso_access == true
    ]
  ])
}

resource "aws_identitystore_user" "users" {
  for_each = { for k, v in var.users :
    k => v if try(v["sso_access"], false) == true
  }

  identity_store_id = var.identity_store_id

  display_name = each.value["family_name"] == "" ? join(" ", [title(regex("^[a-z]*", each.key)), title(replace(try(regex("\\..*@", each.key), ""), "/[\\.|@]/", ""))]) : join(" ", [title(regex("^[a-z]*", each.key)), each.value["family_name"]])
  user_name    = each.key

  name {
    given_name  = each.value["given_name"] == "" ? title(regex("^[a-z]*", each.key)) : each.value["given_name"]
    family_name = each.value["family_name"] == "" ? title(replace(try(regex("\\..*@", each.key), ""), "/[\\.|@]/", "")) : each.value["family_name"]
  }

  emails {
    value = each.key
  }
}



resource "aws_identitystore_group" "group" {
  for_each          = { for name, group_config in var.sso_groups : name => group_config if group_config.create_aws_group }

  display_name      = each.key
  description       = lookup(each.value, "description", null)
  identity_store_id = var.identity_store_id
}

resource "aws_identitystore_group_membership" "member" {
  for_each = {
    for pair in local.group_membership : 
    "${pair.user_name}.${pair.group_name}" => pair 
    if var.sso_groups[pair.group_name].create_aws_group
  }

  identity_store_id = var.identity_store_id
  group_id          = aws_identitystore_group.group[each.value.group_name].group_id
  member_id         = aws_identitystore_user.users[each.value.user_name].user_id
}

