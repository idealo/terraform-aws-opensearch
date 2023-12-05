resource "elasticsearch_composable_index_template" "composable_index_template" {
  for_each = local.composable_index_templates

  name = each.key
  body = jsonencode(each.value)

  depends_on = [
    elasticsearch_opensearch_roles_mapping.master_user_arn,
    elasticsearch_opensearch_roles_mapping.master_user_name,
    aws_route53_record.opensearch
  ]
}
