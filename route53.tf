resource "aws_route53_record" "opensearch" {
  zone_id = data.aws_route53_zone.opensearch.id
  name    = var.cluster_name
  type    = "CNAME"
  ttl     = "60"

  records = [aws_elasticsearch_domain.opensearch.endpoint]
}
