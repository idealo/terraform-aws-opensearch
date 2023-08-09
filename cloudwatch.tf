locals {
  log_prefix = "/aws/OpenSearchService/domains/${var.cluster_name}"
}

resource "aws_cloudwatch_log_group" "opensearch" {
  for_each = { for k, v in var.log_streams_enabled : k => v if v == "true" }

  name              = "${local.log_prefix}/${each.key}"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_resource_policy" "allow_logging" {
  count           = anytrue(values(var.log_streams_enabled)) ? 1 : 0
  policy_document = data.aws_iam_policy_document.allow_logging.json
  policy_name     = "opensearch-${var.cluster_name}-logs"
}
