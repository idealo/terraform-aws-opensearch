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

variable "master_user_arn" {
  description = "The ARN for the master user of the cluster. If not specified, then it defaults to using the IAM user that is making the request."
  type        = string
  default     = null
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
  description = "The KMS key ID to encrypt the OpenSearch domain with. If not specified, then it defaults to using the AWS OpenSearch Service KMS key."
  type        = string
  default     = ""
}
