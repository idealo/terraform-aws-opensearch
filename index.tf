resource "elasticsearch_index" "index" {
  for_each = local.indices

  name                                   = each.key
  number_of_shards                       = each.value.number_of_shards
  number_of_replicas                     = each.value.number_of_replicas
  refresh_interval                       = each.value.refresh_interval
  mappings                               = each.value.mappings
  aliases                                = each.value.aliases
  analysis_analyzer                      = each.value.analysis_analyzer
  analysis_char_filter                   = each.value.analysis_char_filter
  analysis_filter                        = each.value.analysis_filter
  analysis_normalizer                    = each.value.analysis_normalizer
  analysis_tokenizer                     = each.value.analysis_tokenizer
  analyze_max_token_count                = each.value.analyze_max_token_count
  auto_expand_replicas                   = each.value.auto_expand_replicas
  blocks_metadata                        = each.value.blocks_metadata
  blocks_read                            = each.value.blocks_read
  blocks_read_only                       = each.value.blocks_read_only
  blocks_read_only_allow_delete          = each.value.blocks_read_only_allow_delete
  blocks_write                           = each.value.blocks_write
  codec                                  = each.value.codec
  default_pipeline                       = each.value.default_pipeline
  gc_deletes                             = each.value.gc_deletes
  highlight_max_analyzed_offset          = each.value.highlight_max_analyzed_offset
  include_type_name                      = each.value.include_type_name
  index_similarity_default               = each.value.index_similarity_default
  indexing_slowlog_level                 = each.value.indexing_slowlog_level
  indexing_slowlog_source                = each.value.indexing_slowlog_source
  indexing_slowlog_threshold_index_debug = each.value.indexing_slowlog_threshold_index_debug
  indexing_slowlog_threshold_index_info  = each.value.indexing_slowlog_threshold_index_info
  indexing_slowlog_threshold_index_trace = each.value.indexing_slowlog_threshold_index_trace
  indexing_slowlog_threshold_index_warn  = each.value.indexing_slowlog_threshold_index_warn
  load_fixed_bitset_filters_eagerly      = each.value.load_fixed_bitset_filters_eagerly
  max_docvalue_fields_search             = each.value.max_docvalue_fields_search
  max_inner_result_window                = each.value.max_inner_result_window
  max_ngram_diff                         = each.value.max_ngram_diff
  max_refresh_listeners                  = each.value.max_refresh_listeners
  max_regex_length                       = each.value.max_regex_length
  max_rescore_window                     = each.value.max_rescore_window
  max_result_window                      = each.value.max_result_window
  max_script_fields                      = each.value.max_script_fields
  max_shingle_diff                       = each.value.max_shingle_diff
  max_terms_count                        = each.value.max_terms_count
  number_of_routing_shards               = each.value.number_of_routing_shards
  rollover_alias                         = each.value.rollover_alias
  routing_allocation_enable              = each.value.routing_allocation_enable
  routing_partition_size                 = each.value.routing_partition_size
  routing_rebalance_enable               = each.value.routing_rebalance_enable
  search_idle_after                      = each.value.search_idle_after
  search_slowlog_level                   = each.value.search_slowlog_level
  search_slowlog_threshold_fetch_debug   = each.value.search_slowlog_threshold_fetch_debug
  search_slowlog_threshold_fetch_info    = each.value.search_slowlog_threshold_fetch_info
  search_slowlog_threshold_fetch_trace   = each.value.search_slowlog_threshold_fetch_trace
  search_slowlog_threshold_fetch_warn    = each.value.search_slowlog_threshold_fetch_warn
  search_slowlog_threshold_query_debug   = each.value.search_slowlog_threshold_query_debug
  search_slowlog_threshold_query_info    = each.value.search_slowlog_threshold_query_info
  search_slowlog_threshold_query_trace   = each.value.search_slowlog_threshold_query_trace
  search_slowlog_threshold_query_warn    = each.value.search_slowlog_threshold_query_warn
  shard_check_on_startup                 = each.value.shard_check_on_startup
  sort_field                             = each.value.sort_field
  sort_order                             = each.value.sort_order
  force_destroy                          = true

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
