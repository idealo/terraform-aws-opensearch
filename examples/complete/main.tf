provider "aws" {
  default_tags {
    tags = {
      ManagedBy = "Terraform"
    }
  }
}

data "aws_region" "current" {}

data "http" "saml_metadata" {
  url = var.saml_metadata_url
}

provider "elasticsearch" {
  url         = module.opensearch.cluster_endpoint
  aws_region  = data.aws_region.current.name
  healthcheck = false
}

module "opensearch" {
  source = "../../"

  cluster_name    = var.cluster_name
  cluster_domain  = var.cluster_domain
  cluster_version = "1.2"

  saml_entity_id        = var.saml_entity_id
  saml_metadata_content = data.http.saml_metadata.body
  saml_session_timeout  = 120

  index_files          = fileset(path.module, "indices/*.{yml,yaml}")
  index_template_files = fileset(path.module, "index-templates/*.{yml,yaml}")
  ism_policy_files     = fileset(path.module, "ism-policies/*.{yml,yaml}")
  role_files           = fileset(path.module, "roles/*.{yml,yaml}")
  role_mapping_files   = fileset(path.module, "role-mappings/*.{yml,yaml}")
}
