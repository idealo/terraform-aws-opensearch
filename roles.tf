resource "elasticsearch_opensearch_role" "role" {
  for_each = local.roles

  role_name           = each.key
  description         = try(each.value.description, "")
  cluster_permissions = try(each.value.cluster_permissions, [])

  dynamic "index_permissions" {
    for_each = try([each.value.index_permissions], [])
    content {
      index_patterns          = try(index_permissions.value.index_patterns, [])
      allowed_actions         = try(index_permissions.value.allowed_actions, [])
      document_level_security = try(index_permissions.value.document_level_security, "")
    }
  }

  dynamic "tenant_permissions" {
    for_each = try([each.value.tenant_permissions], [])
    content {
      tenant_patterns = try(tenant_permissions.value.tenant_patterns, [])
      allowed_actions = try(tenant_permissions.value.allowed_actions, [])
    }
  }

  depends_on = [elasticsearch_opensearch_roles_mapping.master_user_arn]
}

