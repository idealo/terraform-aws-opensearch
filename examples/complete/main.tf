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

  index_templates = {
    for filename in fileset(path.module, "index-templates/*.{yml,yaml}") :
    replace(basename(filename), "/.ya?ml$/", "") => yamldecode(file(filename))
  }

  ism_policies = {
    for filename in fileset(path.module, "ism-policies/*.{yml,yaml}") :
    replace(basename(filename), "/.ya?ml$/", "") => yamldecode(file(filename))
  }

  indices = {
    for filename in fileset(path.module, "indices/*.{yml,yaml}") :
    replace(basename(filename), "/.ya?ml$/", "") => yamldecode(file(filename))
  }

  roles = {
    for filename in fileset(path.module, "roles/*.{yml,yaml}") :
    replace(basename(filename), "/.ya?ml$/", "") => yamldecode(file(filename))
  }

  role_mappings = {
    for filename in fileset(path.module, "role-mappings/*.{yml,yaml}") :
    replace(basename(filename), "/.ya?ml$/", "") => yamldecode(file(filename))
  }
}
