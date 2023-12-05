resource "opensearch_ism_policy" "ism_policy" {
  for_each = local.ism_policies

  policy_id = each.key
  body      = jsonencode({ "policy" = each.value })

  depends_on = [
    opensearch_roles_mapping.master_user_arn,
    opensearch_roles_mapping.master_user_name,
    aws_route53_record.opensearch
  ]
}
