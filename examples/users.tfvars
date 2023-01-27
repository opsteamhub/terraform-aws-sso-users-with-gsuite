sso_groups = {
  group1 = {
    description = "Example create group1"
  },
  group2 = {
    description = "Example create group2"
  }
}

users = {
  "user1@ops.team" = {
    sso_groups          = ["group1"]
    family_name         = "Example User"
    create_gsuite_email = true
    sso_access          = true

  },
  "example.user2@ops.team" = {
    sso_groups          = ["group1", "group2"]
    create_gsuite_email = false
    is_suspended        = false
    sso_access          = true
  }  
}
