resource "elasticsearch_opensearch_roles_mapping" "role_mapping" {
  for_each = {
    for key, value in local.role_mappings :
    key => value if !contains(["all_access", "security_manager"], key)
  }

  role_name     = each.key
  description   = try(each.value.description, "")
  backend_roles = try(each.value.backend_roles, [])
  hosts         = try(each.value.hosts, [])
  users         = try(each.value.users, [])

  depends_on = [
    elasticsearch_opensearch_role.role,
    aws_route53_record.opensearch
  ]
}

resource "elasticsearch_opensearch_roles_mapping" "master_user_arn" {
  for_each = var.advanced_security_options_internal_user_database_enabled ? {} : {
    for key in ["all_access", "security_manager"] :
    key => try(local.role_mappings[key], {})
  }

  role_name     = each.key
  description   = try(each.value.description, "")
  backend_roles = concat(try(each.value.backend_roles, []), [var.master_user_arn])
  hosts         = try(each.value.hosts, [])
  users         = try(each.value.users, [])

  depends_on = [aws_route53_record.opensearch]
}

resource "elasticsearch_opensearch_roles_mapping" "master_user_name" {
  for_each = var.advanced_security_options_internal_user_database_enabled ? {
    for key in ["all_access", "security_manager"] :
    key => try(local.role_mappings[key], {})
  } : {}

  role_name     = each.key
  description   = try(each.value.description, "")
  backend_roles = try(each.value.backend_roles, [])
  hosts         = try(each.value.hosts, [])
  users         = concat(try(each.value.users, []), [var.advanced_security_options_master_user_name])

  depends_on = [aws_route53_record.opensearch]
}
