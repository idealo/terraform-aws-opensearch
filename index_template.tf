resource "opensearch_index_template" "index_template" {
  for_each = local.index_templates

  name = each.key
  body = jsonencode(each.value)

  depends_on = [
    opensearch_roles_mapping.master_user_arn,
    opensearch_roles_mapping.master_user_name,
    aws_route53_record.opensearch
  ]
}
