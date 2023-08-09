moved {
  from = module.acm
  to   = module.acm[0]
}

module "acm" {
  count   = (var.custom_endpoint_certificate_arn != "") ? 0 : 1
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.3.1"

  domain_name = local.custom_endpoint
  zone_id     = data.aws_route53_zone.opensearch.id

  wait_for_validation = true

  tags = var.tags
}

resource "aws_iam_service_linked_role" "es" {
  count            = var.create_service_role ? 1 : 0
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "opensearch" {
  domain_name           = var.cluster_name
  elasticsearch_version = "OpenSearch_${var.cluster_version}"
  access_policies       = var.access_policies != null ? var.access_policies : data.aws_iam_policy_document.access_policy.json
  advanced_options      = var.advanced_options

  cluster_config {
    dedicated_master_enabled = var.master_instance_enabled
    dedicated_master_count   = var.master_instance_enabled ? var.master_instance_count : null
    dedicated_master_type    = var.master_instance_enabled ? var.master_instance_type : null

    instance_count = var.hot_instance_count
    instance_type  = var.hot_instance_type

    warm_enabled = var.warm_instance_enabled
    warm_count   = var.warm_instance_enabled ? var.warm_instance_count : null
    warm_type    = var.warm_instance_enabled ? var.warm_instance_type : null

    zone_awareness_enabled = (var.availability_zones > 1) ? true : false

    dynamic "zone_awareness_config" {
      for_each = (var.availability_zones > 1) ? [var.availability_zones] : []
      content {
        availability_zone_count = zone_awareness_config.value
      }
    }
  }

  dynamic "advanced_security_options" {
    for_each = var.advanced_security_options_enabled ? [true] : []
    content {
      enabled                        = var.advanced_security_options_enabled
      internal_user_database_enabled = var.advanced_security_options_internal_user_database_enabled

      master_user_options {
        master_user_arn      = var.advanced_security_options_internal_user_database_enabled ? null : (var.master_user_arn != "" ? var.master_user_arn : data.aws_caller_identity.current.arn)
        master_user_name     = var.advanced_security_options_internal_user_database_enabled ? var.advanced_security_options_master_user_name : null
        master_user_password = var.advanced_security_options_internal_user_database_enabled ? var.advanced_security_options_master_user_password : null
      }
    }
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"

    custom_endpoint_enabled         = true
    custom_endpoint                 = local.custom_endpoint
    custom_endpoint_certificate_arn = (var.custom_endpoint_certificate_arn != "") ? var.custom_endpoint_certificate_arn : module.acm[0].acm_certificate_arn
  }

  node_to_node_encryption {
    enabled = var.node_to_node_encryption_enabled
  }

  encrypt_at_rest {
    enabled    = var.encrypt_at_rest_enabled
    kms_key_id = var.encrypt_kms_key_id
  }

  auto_tune_options {
    desired_state = var.auto_tune_enabled ? "ENABLED" : "DISABLED"
  }

  dynamic "vpc_options" {
    for_each = var.vpc_enabled ? [true] : []
    content {
      security_group_ids = var.security_group_ids
      subnet_ids         = var.subnet_ids
    }
  }

  dynamic "ebs_options" {
    for_each = var.ebs_enabled ? [true] : []
    content {
      ebs_enabled = true
      volume_size = var.ebs_volume_size
      volume_type = var.ebs_volume_type
      throughput  = var.ebs_throughput
      iops        = var.ebs_iops
    }
  }

  dynamic "cognito_options" {
    for_each = var.cognito_options_enabled ? [true] : []
    content {
      enabled          = true
      identity_pool_id = var.cognito_options.identity_pool_id
      role_arn         = var.cognito_options.role_arn
      user_pool_id     = var.cognito_options.user_pool_id
    }
  }

  dynamic "log_publishing_options" {
    for_each = { for k, v in var.log_streams_enabled : k => v if v == "true" }
    content {
      log_type                 = log_publishing_options.key
      enabled                  = tobool(log_publishing_options.value)
      cloudwatch_log_group_arn = try(aws_cloudwatch_log_group.opensearch[log_publishing_options.key].arn, "")
    }
  }

  tags = var.tags

  depends_on = [
    aws_iam_service_linked_role.es,
    aws_cloudwatch_log_group.opensearch
  ]
}

resource "aws_elasticsearch_domain_saml_options" "opensearch" {
  count       = var.saml_enabled ? 1 : 0
  domain_name = aws_elasticsearch_domain.opensearch.domain_name

  saml_options {
    enabled                 = true
    subject_key             = var.saml_subject_key
    roles_key               = var.saml_roles_key
    session_timeout_minutes = var.saml_session_timeout
    master_user_name        = var.saml_master_user_name
    master_backend_role     = var.saml_master_backend_role

    idp {
      entity_id        = var.saml_entity_id
      metadata_content = sensitive(replace(var.saml_metadata_content, "\ufeff", ""))
    }
  }
}

resource "aws_route53_record" "opensearch" {
  zone_id = data.aws_route53_zone.opensearch.id
  name    = trimsuffix(local.custom_endpoint, var.cluster_domain)
  type    = "CNAME"
  ttl     = "60"

  records = [aws_elasticsearch_domain.opensearch.endpoint]
}
