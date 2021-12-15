resource "elasticsearch_opendistro_ism_policy" "ism_policy" {
  for_each = local.ism_policies

  policy_id = each.key
  body      = jsonencode({ "policy" = each.value })

  depends_on = [elasticsearch_opendistro_roles_mapping.master_user_arn]
}
