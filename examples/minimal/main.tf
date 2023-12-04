provider "aws" {
  default_tags {
    tags = {
      ManagedBy = "Terraform"
    }
  }
}

data "aws_region" "current" {}

provider "opensearch" {
  url         = module.opensearch.cluster_endpoint
  aws_region  = data.aws_region.current.name
  healthcheck = false
}

module "opensearch" {
  source = "../../"

  cluster_name    = var.cluster_name
  cluster_domain  = var.cluster_domain
  cluster_version = "2.11"

  saml_enabled = false
}
