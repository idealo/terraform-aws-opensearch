data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_route53_zone" "opensearch" {
  name = var.cluster_domain
}

data "aws_iam_policy_document" "access_policy" {
  statement {
    actions   = ["es:*"]
    resources = ["arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.cluster_name}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
