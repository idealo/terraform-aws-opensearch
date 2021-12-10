resource "elasticsearch_opendistro_ism_policy" "ism_policy" {
  for_each = var.ism_policies

  policy_id = each.key
  body      = jsonencode({ "policy" = each.value })

  depends_on = [aws_route53_record.opensearch]
}
