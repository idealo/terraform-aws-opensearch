provider "aws" {
  default_tags {
    tags = {
      ManagedBy = "Terraform"
    }
  }
}

locals {
  cluster_name      = "opensearch"
  cluster_domain    = "example.com"
  saml_entity_id    = "https://sts.windows.net/XXX-XXX-XXX-XXX-XXX/"
  saml_metadata_url = "https://login.microsoftonline.com/XXX-XXX-XXX-XXX-XXX/federationmetadata/2007-06/federationmetadata.xml?appid=YYY-YYY-YYY-YYY-YYY"
}

data "aws_region" "current" {}

data "http" "saml_metadata" {
  url = local.saml_metadata_url
}

provider "elasticsearch" {
  url                   = "https://${local.cluster_name}.${local.cluster_domain}"
  aws_region            = data.aws_region.current.name
  elasticsearch_version = "7.10.2"
  healthcheck           = false
}

module "opensearch" {
  source = "../../"

  cluster_name    = local.cluster_name
  cluster_domain  = local.cluster_domain
  cluster_version = "1.0"

  saml_entity_id        = local.saml_entity_id
  saml_metadata_content = data.http.saml_metadata.body
  saml_session_timeout  = 120

  index_files          = fileset(path.module, "indices/*.{yml,yaml}")
  index_template_files = fileset(path.module, "index-templates/*.{yml,yaml}")
  ism_policy_files     = fileset(path.module, "ism-policies/*.{yml,yaml}")
  role_files           = fileset(path.module, "roles/*.{yml,yaml}")
  role_mapping_files   = fileset(path.module, "role-mappings/*.{yml,yaml}")
}
