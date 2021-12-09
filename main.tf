resource "aws_elasticsearch_domain" "opensearch" {
  domain_name           = var.cluster_name
  elasticsearch_version = "OpenSearch_${var.cluster_version}"
  access_policies       = data.aws_iam_policy_document.access_policy.json

  cluster_config {
    dedicated_master_enabled = true
    dedicated_master_count   = var.master_instance_count
    dedicated_master_type    = var.master_instance_type

    instance_count = var.hot_instance_count
    instance_type  = var.hot_instance_type

    warm_enabled = true
    warm_count   = var.warm_instance_count
    warm_type    = var.warm_instance_type

    zone_awareness_enabled = (var.availability_zones > 1) ? true : false
    zone_awareness_config {
      availability_zone_count = (var.availability_zones > 1) ? var.availability_zones : 2
    }
  }

  advanced_security_options {
    enabled                        = true
    internal_user_database_enabled = false

    master_user_options {
      master_user_arn = (var.master_user_arn != null) ? var.master_user_arn : data.aws_caller_identity.current.arn
    }
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled    = true
    kms_key_id = var.encrypt_kms_key_id
  }
}
