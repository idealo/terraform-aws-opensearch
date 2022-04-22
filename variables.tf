variable "cluster_name" {
  description = "The name of the OpenSearch cluster."
  type        = string
  default     = "opensearch"
}

variable "cluster_version" {
  description = "The version of OpenSearch to deploy."
  type        = string
  default     = "1.0"
}

variable "cluster_domain" {
  description = "The hosted zone name of the OpenSearch cluster."
  type        = string
}

variable "create_service_role" {
  description = "Indicates whether to create the service-linked role. See https://docs.aws.amazon.com/opensearch-service/latest/developerguide/slr.html"
  type        = bool
  default     = true
}

variable "master_user_arn" {
  description = "The ARN for the master user of the cluster. If not specified, then it defaults to using the IAM user that is making the request."
  type        = string
  default     = ""
}

variable "master_instance_enabled" {
  description = "Indicates whether dedicated master nodes are enabled for the cluster."
  type        = bool
  default     = true
}

variable "master_instance_type" {
  description = "The type of EC2 instances to run for each master node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing"
  type        = string
  default     = "r6gd.large.elasticsearch"

  validation {
    condition     = can(regex("^[m3|r3|i3|i2|r6gd]", var.master_instance_type))
    error_message = "The EC2 master_instance_type must provide a SSD or NVMe-based local storage."
  }
}

variable "master_instance_count" {
  description = "The number of dedicated master nodes in the cluster."
  type        = number
  default     = 3
}

variable "hot_instance_type" {
  description = "The type of EC2 instances to run for each hot node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing"
  type        = string
  default     = "r6gd.4xlarge.elasticsearch"

  validation {
    condition     = can(regex("^[m3|r3|i3|i2|r6gd]", var.hot_instance_type))
    error_message = "The EC2 hot_instance_type must provide a SSD or NVMe-based local storage."
  }
}

variable "hot_instance_count" {
  description = "The number of dedicated hot nodes in the cluster."
  type        = number
  default     = 3
}

variable "warm_instance_enabled" {
  description = "Indicates whether ultrawarm nodes are enabled for the cluster."
  type        = bool
  default     = true
}

variable "warm_instance_type" {
  description = "The type of EC2 instances to run for each warm node. A list of available instance types can you find at https://aws.amazon.com/en/elasticsearch-service/pricing/#UltraWarm_pricing"
  type        = string
  default     = "ultrawarm1.large.elasticsearch"
}

variable "warm_instance_count" {
  description = "The number of dedicated warm nodes in the cluster."
  type        = number
  default     = 3
}

variable "availability_zones" {
  description = "The number of availability zones for the OpenSearch cluster. Valid values: 1, 2 or 3."
  type        = number
  default     = 3
}

variable "encrypt_kms_key_id" {
  description = "The KMS key ID to encrypt the OpenSearch cluster with. If not specified, then it defaults to using the AWS OpenSearch Service KMS key."
  type        = string
  default     = ""
}

variable "saml_subject_key" {
  description = "Element of the SAML assertion to use for username."
  type        = string
  default     = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
}

variable "saml_roles_key" {
  description = "Element of the SAML assertion to use for backend roles."
  type        = string
  default     = "http://schemas.microsoft.com/ws/2008/06/identity/claims/role"
}

variable "saml_entity_id" {
  description = "The unique Entity ID of the application in SAML Identity Provider."
  type        = string
}

variable "saml_metadata_content" {
  description = "The metadata of the SAML application in xml format."
  type        = string
}

variable "saml_session_timeout" {
  description = "Duration of a session in minutes after a user logs in. Default is 60. Maximum value is 1,440."
  type        = number
  default     = 60
}

variable "saml_master_backend_role" {
  description = "This backend role receives full permissions to the cluster, equivalent to a new master role, but can only use those permissions within Dashboards."
  type        = string
  default     = null
}

variable "saml_master_user_name" {
  description = "This username receives full permissions to the cluster, equivalent to a new master user, but can only use those permissions within Dashboards."
  type        = string
  default     = null
}

variable "index_templates" {
  description = "A map of all index templates to create."
  type        = map(any)
  default     = {}
}

variable "index_template_files" {
  description = "A set of all index template files to create."
  type        = set(string)
  default     = []
}

variable "ism_policies" {
  description = "A map of all ISM policies to create."
  type        = map(any)
  default     = {}
}

variable "ism_policy_files" {
  description = "A set of all ISM policy files to create."
  type        = set(string)
  default     = []
}

variable "indices" {
  description = "A map of all indices to create."
  type        = map(any)
  default     = {}
}

variable "index_files" {
  description = "A set of all index files to create."
  type        = set(string)
  default     = []
}

variable "roles" {
  description = "A map of all roles to create."
  type        = map(any)
  default     = {}
}

variable "role_files" {
  description = "A set of all role files to create."
  type        = set(string)
  default     = []
}

variable "role_mappings" {
  description = "A map of all role mappings to create."
  type        = map(any)
  default     = {}
}

variable "role_mapping_files" {
  description = "A set of all role mapping files to create."
  type        = set(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}
