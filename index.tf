resource "opensearch_index" "index" {
  for_each = local.indices

  name                                   = each.key
  number_of_shards                       = try(each.value.number_of_shards, "")
  number_of_replicas                     = try(each.value.number_of_replicas, "")
  refresh_interval                       = try(each.value.refresh_interval, "")
  mappings                               = jsonencode(try(each.value.mappings, {}))
  aliases                                = jsonencode(try(each.value.aliases, {}))
  analysis_analyzer                      = try(each.value.analysis_analyzer, null)
  analysis_char_filter                   = try(each.value.analysis_char_filter, null)
  analysis_filter                        = try(each.value.analysis_filter, null)
  analysis_normalizer                    = try(each.value.analysis_normalizer, null)
  analysis_tokenizer                     = try(each.value.analysis_tokenizer, null)
  analyze_max_token_count                = try(each.value.analyze_max_token_count, null)
  auto_expand_replicas                   = try(each.value.auto_expand_replicas, null)
  blocks_metadata                        = try(each.value.blocks_metadata, null)
  blocks_read                            = try(each.value.blocks_read, null)
  blocks_read_only                       = try(each.value.blocks_read_only, null)
  blocks_read_only_allow_delete          = try(each.value.blocks_read_only_allow_delete, null)
  blocks_write                           = try(each.value.blocks_write, null)
  codec                                  = try(each.value.codec, null)
  default_pipeline                       = try(each.value.default_pipeline, null)
  gc_deletes                             = try(each.value.gc_deletes, null)
  highlight_max_analyzed_offset          = try(each.value.highlight_max_analyzed_offset, null)
  include_type_name                      = try(each.value.include_type_name, null)
  index_similarity_default               = try(each.value.index_similarity_default, null)
  indexing_slowlog_level                 = try(each.value.indexing_slowlog_level, null)
  indexing_slowlog_source                = try(each.value.indexing_slowlog_source, null)
  indexing_slowlog_threshold_index_debug = try(each.value.indexing_slowlog_threshold_index_debug, null)
  indexing_slowlog_threshold_index_info  = try(each.value.indexing_slowlog_threshold_index_info, null)
  indexing_slowlog_threshold_index_trace = try(each.value.indexing_slowlog_threshold_index_trace, null)
  indexing_slowlog_threshold_index_warn  = try(each.value.indexing_slowlog_threshold_index_warn, null)
  load_fixed_bitset_filters_eagerly      = try(each.value.load_fixed_bitset_filters_eagerly, null)
  max_docvalue_fields_search             = try(each.value.max_docvalue_fields_search, null)
  max_inner_result_window                = try(each.value.max_inner_result_window, null)
  max_ngram_diff                         = try(each.value.max_ngram_diff, null)
  max_refresh_listeners                  = try(each.value.max_refresh_listeners, null)
  max_regex_length                       = try(each.value.max_regex_length, null)
  max_rescore_window                     = try(each.value.max_rescore_window, null)
  max_result_window                      = try(each.value.max_result_window, null)
  max_script_fields                      = try(each.value.max_script_fields, null)
  max_shingle_diff                       = try(each.value.max_shingle_diff, null)
  max_terms_count                        = try(each.value.max_terms_count, null)
  number_of_routing_shards               = try(each.value.number_of_routing_shards, null)
  rollover_alias                         = try(each.value.rollover_alias, null)
  routing_allocation_enable              = try(each.value.routing_allocation_enable, null)
  routing_partition_size                 = try(each.value.routing_partition_size, null)
  routing_rebalance_enable               = try(each.value.routing_rebalance_enable, null)
  search_idle_after                      = try(each.value.search_idle_after, null)
  search_slowlog_level                   = try(each.value.search_slowlog_level, null)
  search_slowlog_threshold_fetch_debug   = try(each.value.search_slowlog_threshold_fetch_debug, null)
  search_slowlog_threshold_fetch_info    = try(each.value.search_slowlog_threshold_fetch_info, null)
  search_slowlog_threshold_fetch_trace   = try(each.value.search_slowlog_threshold_fetch_trace, null)
  search_slowlog_threshold_fetch_warn    = try(each.value.search_slowlog_threshold_fetch_warn, null)
  search_slowlog_threshold_query_debug   = try(each.value.search_slowlog_threshold_query_debug, null)
  search_slowlog_threshold_query_info    = try(each.value.search_slowlog_threshold_query_info, null)
  search_slowlog_threshold_query_trace   = try(each.value.search_slowlog_threshold_query_trace, null)
  search_slowlog_threshold_query_warn    = try(each.value.search_slowlog_threshold_query_warn, null)
  shard_check_on_startup                 = try(each.value.shard_check_on_startup, null)
  sort_field                             = try(each.value.sort_field, null)
  sort_order                             = try(each.value.sort_order, null)
  force_destroy                          = true

  depends_on = [
    opensearch_index_template.index_template,
    opensearch_composable_index_template.composable_index_template,
    opensearch_ism_policy.ism_policy,
    aws_route53_record.opensearch
  ]

  lifecycle {
    ignore_changes = [
      number_of_shards,
      number_of_replicas,
      refresh_interval,
    ]
  }
}
