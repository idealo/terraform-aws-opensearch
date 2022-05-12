resource "elasticsearch_index" "index" {
  for_each = local.indices

  name               = each.key
  number_of_shards   = try(each.value.number_of_shards, "")
  number_of_replicas = try(each.value.number_of_replicas, "")
  refresh_interval   = try(each.value.refresh_interval, "")
  mappings           = jsonencode(try(each.value.mappings, {}))
  aliases            = jsonencode(try(each.value.aliases, {}))
  force_destroy      = true

  depends_on = [
    elasticsearch_index_template.index_template,
    elasticsearch_opensearch_ism_policy.ism_policy,
  ]

  lifecycle {
    ignore_changes = [
      number_of_shards,
      number_of_replicas,
      refresh_interval,
    ]
  }
}
