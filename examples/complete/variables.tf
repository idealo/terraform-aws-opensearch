variable "cluster_name" {
  description = "The name of the OpenSearch cluster."
  type        = string
  default     = "opensearch"
}

variable "cluster_domain" {
  description = "The hosted zone name of the OpenSearch cluster."
  type        = string
}

variable "saml_entity_id" {
  description = "The unique Entity ID of the application in SAML Identity Provider."
  type        = string
}

variable "saml_metadata_url" {
  description = "The URL of the SAML Identity Provider's metadata xml."
  type        = string
}
