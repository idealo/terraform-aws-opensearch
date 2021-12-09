module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.2.0"

  domain_name = "${var.cluster_name}.${data.aws_route53_zone.opensearch.name}"
  zone_id     = data.aws_route53_zone.opensearch.id

  wait_for_validation = true

  tags = var.tags
}
