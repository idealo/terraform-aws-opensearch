resource "elasticsearch_opendistro_roles_mapping" "role_mapping" {
  for_each = var.role_mappings

  role_name     = each.key
  description   = try(each.value.description, "")
  backend_roles = try(each.value.backend_roles, [])
  hosts         = try(each.value.hosts, [])
  users         = try(each.value.users, [])

  depends_on = [
    aws_route53_record.opensearch,
    elasticsearch_opendistro_role.role,
  ]
}
