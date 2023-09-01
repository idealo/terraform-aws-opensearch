# AWS OpenSearch Terraform Module

Terraform module to provision an OpenSearch cluster with SAML authentication.

## Prerequisites

- A [hosted zone](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html) to route traffic to your OpenSearch domain
- An [entityID and metadata XML](https://aws.amazon.com/de/blogs/security/configure-saml-single-sign-on-for-kibana-with-ad-fs-on-amazon-elasticsearch-service/) from your SAML identity provider (in case `saml_enabled = true`)

## Features

- Create an AWS OpenSearch cluster with SAML authentication
- All node types with local NVMe for high IO performance are supported
- Create or manage various OpenSearch resources:
  - [Index templates](https://opensearch.org/docs/latest/opensearch/index-templates/)
  - [Indices](https://opensearch.org/docs/latest/opensearch/rest-api/index-apis/create-index/)
  - [ISM policies](https://opensearch.org/docs/latest/im-plugin/ism/policies/)
  - [Roles](https://opensearch.org/docs/latest/security-plugin/access-control/users-roles/#create-roles)
  - [Role mappings](https://opensearch.org/docs/latest/security-plugin/access-control/users-roles/#map-users-to-roles)

## Usage

This example is using Azure AD as SAML identity provider.

```terraform
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
  url                   = module.opensearch.cluster_endpoint
  aws_region            = data.aws_region.current.name
  healthcheck           = false
}

module "opensearch" {
  source  = "idealo/opensearch/aws"
  version = "~> 1.0"

  cluster_name    = local.cluster_name
  cluster_domain  = local.cluster_domain
  cluster_version = "1.2"

  saml_entity_id        = local.saml_entity_id
  saml_metadata_content = data.http.saml_metadata.body

  indices = {
    example-index = {
      number_of_shards   = 2
      number_of_replicas = 1
    }
  }
}
```

## Examples

Here is a working example of using this Terraform module:

- [Complete](https://github.com/idealo/terraform-aws-opensearch/tree/main/examples/complete) - Create an AWS OpenSearch cluster with all necessary resources.
- [Minimal](https://github.com/idealo/terraform-aws-opensearch/tree/main/examples/minimal) - Create an empty AWS OpenSearch cluster without saml.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.12.0 |
| <a name="requirement_elasticsearch"></a> [elasticsearch](#requirement\_elasticsearch) | >= 2.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | ~> 4.3.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_resource_policy.allow_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_elasticsearch_domain.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain) | resource |
| [aws_elasticsearch_domain_saml_options.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticsearch_domain_saml_options) | resource |
| [aws_iam_service_linked_role.es](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_service_linked_role) | resource |
| [aws_route53_record.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [elasticsearch_index.index](https://registry.terraform.io/providers/phillbaker/elasticsearch/latest/docs/resources/index) | resource |
| [elasticsearch_index_template.index_template](https://registry.terraform.io/providers/phillbaker/elasticsearch/latest/docs/resources/index_template) | resource |
| [elasticsearch_opensearch_ism_policy.ism_policy](https://registry.terraform.io/providers/phillbaker/elasticsearch/latest/docs/resources/opensearch_ism_policy) | resource |
| [elasticsearch_opensearch_role.role](https://registry.terraform.io/providers/phillbaker/elasticsearch/latest/docs/resources/opensearch_role) | resource |
| [elasticsearch_opensearch_roles_mapping.master_user_arn](https://registry.terraform.io/providers/phillbaker/elasticsearch/latest/docs/resources/opensearch_roles_mapping) | resource |
| [elasticsearch_opensearch_roles_mapping.master_user_name](https://registry.terraform.io/providers/phillbaker/elasticsearch/latest/docs/resources/opensearch_roles_mapping) | resource |
| [elasticsearch_opensearch_roles_mapping.role_mapping](https://registry.terraform.io/providers/phillbaker/elasticsearch/latest/docs/resources/opensearch_roles_mapping) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.allow_logging](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.opensearch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_policies"></a> [access\_policies](#input\_access\_policies) | IAM policy document specifying the access policies for the domain. | `string` | `null` | no |
| <a name="input_advanced_options"></a> [advanced\_options](#input\_advanced\_options) | Key-value string pairs to specify advanced configuration options. | `map(string)` | `null` | no |
| <a name="input_advanced_security_options_enabled"></a> [advanced\_security\_options\_enabled](#input\_advanced\_security\_options\_enabled) | Whether advanced security is enabled. | `bool` | `true` | no |
| <a name="input_advanced_security_options_internal_user_database_enabled"></a> [advanced\_security\_options\_internal\_user\_database\_enabled](#input\_advanced\_security\_options\_internal\_user\_database\_enabled) | Whether to enable or not internal Kibana user database for ELK OpenDistro security plugin | `bool` | `false` | no |
| <a name="input_advanced_security_options_master_user_name"></a> [advanced\_security\_options\_master\_user\_name](#input\_advanced\_security\_options\_master\_user\_name) | Master user username (applicable if advanced\_security\_options\_internal\_user\_database\_enabled set to true) | `string` | `null` | no |
| <a name="input_advanced_security_options_master_user_password"></a> [advanced\_security\_options\_master\_user\_password](#input\_advanced\_security\_options\_master\_user\_password) | Master user password (applicable if advanced\_security\_options\_internal\_user\_database\_enabled set to true) | `string` | `null` | no |
| <a name="input_auto_tune_enabled"></a> [auto\_tune\_enabled](#input\_auto\_tune\_enabled) | Whether to enable/disable auto-tune | `bool` | `true` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | The number of availability zones for the OpenSearch cluster. Valid values: 1, 2 or 3. | `number` | `3` | no |
| <a name="input_cluster_domain"></a> [cluster\_domain](#input\_cluster\_domain) | The hosted zone name of the OpenSearch cluster. | `string` | n/a | yes |
| <a name="input_cluster_domain_private"></a> [cluster\_domain\_private](#input\_cluster\_domain\_private) | Indicates whether to create records in a private (true) or public (false) zone | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the OpenSearch cluster. | `string` | `"opensearch"` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | The version of OpenSearch to deploy. | `string` | `"1.0"` | no |
| <a name="input_cognito_options"></a> [cognito\_options](#input\_cognito\_options) | Configuration block for authenticating Kibana with Cognito. | `map(string)` | `{}` | no |
| <a name="input_cognito_options_enabled"></a> [cognito\_options\_enabled](#input\_cognito\_options\_enabled) | Whether Amazon Cognito authentication with Kibana is enabled or not. | `bool` | `false` | no |
| <a name="input_create_service_role"></a> [create\_service\_role](#input\_create\_service\_role) | Indicates whether to create the service-linked role. See https://docs.aws.amazon.com/opensearch-service/latest/developerguide/slr.html | `bool` | `true` | no |
| <a name="input_custom_endpoint"></a> [custom\_endpoint](#input\_custom\_endpoint) | Fully qualified domain for your custom endpoint. If not specified, then it defaults to <cluster\_name>.<cluster\_domain> | `string` | `null` | no |
| <a name="input_custom_endpoint_certificate_arn"></a> [custom\_endpoint\_certificate\_arn](#input\_custom\_endpoint\_certificate\_arn) | The ARN of the custom ACM certificate. | `string` | `""` | no |
| <a name="input_ebs_enabled"></a> [ebs\_enabled](#input\_ebs\_enabled) | Indicates whether attach EBS volumes to the data nodes. | `bool` | `false` | no |
| <a name="input_ebs_iops"></a> [ebs\_iops](#input\_ebs\_iops) | The baseline input/output (I/O) performance of EBS volumes attached to data nodes. | `number` | `3000` | no |
| <a name="input_ebs_throughput"></a> [ebs\_throughput](#input\_ebs\_throughput) | The throughput (in MiB/s) of the EBS volumes attached to data nodes. Valid values are between 125 and 1000. | `number` | `125` | no |
| <a name="input_ebs_volume_size"></a> [ebs\_volume\_size](#input\_ebs\_volume\_size) | The size of EBS volumes attached to data nodes (in GiB). | `number` | `10` | no |
| <a name="input_ebs_volume_type"></a> [ebs\_volume\_type](#input\_ebs\_volume\_type) | The type of EBS volumes attached to data nodes. | `string` | `"gp3"` | no |
| <a name="input_encrypt_at_rest_enabled"></a> [encrypt\_at\_rest\_enabled](#input\_encrypt\_at\_rest\_enabled) | Configuration block for encrypt at rest options | `bool` | `true` | no |
| <a name="input_encrypt_kms_key_id"></a> [encrypt\_kms\_key\_id](#input\_encrypt\_kms\_key\_id) | The KMS key ID to encrypt the OpenSearch cluster with. If not specified, then it defaults to using the AWS OpenSearch Service KMS key. | `string` | `""` | no |
| <a name="input_hot_instance_count"></a> [hot\_instance\_count](#input\_hot\_instance\_count) | The number of dedicated hot nodes in the cluster. | `number` | `3` | no |
| <a name="input_hot_instance_type"></a> [hot\_instance\_type](#input\_hot\_instance\_type) | The type of EC2 instances to run for each hot node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing | `string` | `"r6gd.4xlarge.elasticsearch"` | no |
| <a name="input_index_files"></a> [index\_files](#input\_index\_files) | A set of all index files to create. | `set(string)` | `[]` | no |
| <a name="input_index_template_files"></a> [index\_template\_files](#input\_index\_template\_files) | A set of all index template files to create. | `set(string)` | `[]` | no |
| <a name="input_index_templates"></a> [index\_templates](#input\_index\_templates) | A map of all index templates to create. | `map(any)` | `{}` | no |
| <a name="input_indices"></a> [indices](#input\_indices) | A map of all indices to create. | `map(any)` | `{}` | no |
| <a name="input_ism_policies"></a> [ism\_policies](#input\_ism\_policies) | A map of all ISM policies to create. | `map(any)` | `{}` | no |
| <a name="input_ism_policy_files"></a> [ism\_policy\_files](#input\_ism\_policy\_files) | A set of all ISM policy files to create. | `set(string)` | `[]` | no |
| <a name="input_log_streams_enabled"></a> [log\_streams\_enabled](#input\_log\_streams\_enabled) | Configuration for which log streams to enable sending logs to CloudWatch. | `map(string)` | <pre>{<br>  "AUDIT_LOGS": "false",<br>  "ES_APPLICATION_LOGS": "false",<br>  "INDEX_SLOW_LOGS": "false",<br>  "SEARCH_SLOW_LOGS": "false"<br>}</pre> | no |
| <a name="input_master_instance_count"></a> [master\_instance\_count](#input\_master\_instance\_count) | The number of dedicated master nodes in the cluster. | `number` | `3` | no |
| <a name="input_master_instance_enabled"></a> [master\_instance\_enabled](#input\_master\_instance\_enabled) | Indicates whether dedicated master nodes are enabled for the cluster. | `bool` | `true` | no |
| <a name="input_master_instance_type"></a> [master\_instance\_type](#input\_master\_instance\_type) | The type of EC2 instances to run for each master node. A list of available instance types can you find at https://aws.amazon.com/en/opensearch-service/pricing/#On-Demand_instance_pricing | `string` | `"r6gd.large.elasticsearch"` | no |
| <a name="input_master_user_arn"></a> [master\_user\_arn](#input\_master\_user\_arn) | The ARN for the master user of the cluster. If not specified, then it defaults to using the IAM user that is making the request. | `string` | `""` | no |
| <a name="input_node_to_node_encryption_enabled"></a> [node\_to\_node\_encryption\_enabled](#input\_node\_to\_node\_encryption\_enabled) | Configuration block for node-to-node encryption options | `bool` | `true` | no |
| <a name="input_role_files"></a> [role\_files](#input\_role\_files) | A set of all role files to create. | `set(string)` | `[]` | no |
| <a name="input_role_mapping_files"></a> [role\_mapping\_files](#input\_role\_mapping\_files) | A set of all role mapping files to create. | `set(string)` | `[]` | no |
| <a name="input_role_mappings"></a> [role\_mappings](#input\_role\_mappings) | A map of all role mappings to create. | `map(any)` | `{}` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | A map of all roles to create. | `map(any)` | `{}` | no |
| <a name="input_saml_enabled"></a> [saml\_enabled](#input\_saml\_enabled) | Indicates whether to configure SAML for the OpenSearch dashboard. | `bool` | `true` | no |
| <a name="input_saml_entity_id"></a> [saml\_entity\_id](#input\_saml\_entity\_id) | The unique Entity ID of the application in SAML Identity Provider. | `string` | `""` | no |
| <a name="input_saml_master_backend_role"></a> [saml\_master\_backend\_role](#input\_saml\_master\_backend\_role) | This backend role receives full permissions to the cluster, equivalent to a new master role, but can only use those permissions within Dashboards. | `string` | `null` | no |
| <a name="input_saml_master_user_name"></a> [saml\_master\_user\_name](#input\_saml\_master\_user\_name) | This username receives full permissions to the cluster, equivalent to a new master user, but can only use those permissions within Dashboards. | `string` | `null` | no |
| <a name="input_saml_metadata_content"></a> [saml\_metadata\_content](#input\_saml\_metadata\_content) | The metadata of the SAML application in xml format. | `string` | `""` | no |
| <a name="input_saml_roles_key"></a> [saml\_roles\_key](#input\_saml\_roles\_key) | Element of the SAML assertion to use for backend roles. | `string` | `"http://schemas.microsoft.com/ws/2008/06/identity/claims/role"` | no |
| <a name="input_saml_session_timeout"></a> [saml\_session\_timeout](#input\_saml\_session\_timeout) | Duration of a session in minutes after a user logs in. Default is 60. Maximum value is 1,440. | `number` | `60` | no |
| <a name="input_saml_subject_key"></a> [saml\_subject\_key](#input\_saml\_subject\_key) | Element of the SAML assertion to use for username. | `string` | `"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | The list of VPC security groups IDs to attach. | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The list of VPC subnet IDs to use. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_enabled"></a> [vpc\_enabled](#input\_vpc\_enabled) | Indicates whether the cluster is running inside a VPC. | `bool` | `false` | no |
| <a name="input_warm_instance_count"></a> [warm\_instance\_count](#input\_warm\_instance\_count) | The number of dedicated warm nodes in the cluster. | `number` | `3` | no |
| <a name="input_warm_instance_enabled"></a> [warm\_instance\_enabled](#input\_warm\_instance\_enabled) | Indicates whether ultrawarm nodes are enabled for the cluster. | `bool` | `true` | no |
| <a name="input_warm_instance_type"></a> [warm\_instance\_type](#input\_warm\_instance\_type) | The type of EC2 instances to run for each warm node. A list of available instance types can you find at https://aws.amazon.com/en/elasticsearch-service/pricing/#UltraWarm_pricing | `string` | `"ultrawarm1.large.elasticsearch"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint URL of the OpenSearch cluster. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the OpenSearch cluster. |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | The version of the OpenSearch cluster. |
| <a name="output_kibana_endpoint"></a> [kibana\_endpoint](#output\_kibana\_endpoint) | The endpoint URL of the OpenSearch dashboards. |
<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/idealo/terraform-aws-opensearch/blob/main/LICENSE) for full details.
