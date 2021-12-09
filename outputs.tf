output "cluster_name" {
  description = "The name of the OpenSearch cluster."
  value       = aws_elasticsearch_domain.opensearch.domain_name
}

output "cluster_version" {
  description = "The version of the OpenSearch cluster."
  value       = replace(aws_elasticsearch_domain.opensearch.elasticsearch_version, "OpenSearch_", "")
}
