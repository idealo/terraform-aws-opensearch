output "cluster_name" {
  description = "The name of the OpenSearch cluster."
  value       = module.opensearch.cluster_name
}

output "cluster_version" {
  description = "The version of the OpenSearch cluster."
  value       = module.opensearch.cluster_version
}

output "cluster_endpoint" {
  description = "The endpoint URL of the OpenSearch cluster."
  value       = module.opensearch.cluster_endpoint
}
