locals {
  advanced_options_defaults = {
    "override_main_response_version"         = "true",
    "rest.action.multi.allow_explicit_index" = "true",
  }

  indices = merge({
    for filename in var.index_files :
    replace(basename(filename), "/\\.(ya?ml|json)$/", "") =>
    length(regexall("\\.ya?ml$", filename)) > 0 ? yamldecode(file(filename)) : jsondecode(file(filename))
  }, var.indices)

  index_templates = merge({
    for filename in var.index_template_files :
    replace(basename(filename), "/\\.(ya?ml|json)$/", "") =>
    length(regexall("\\.ya?ml$", filename)) > 0 ? yamldecode(file(filename)) : jsondecode(file(filename))
  }, var.index_templates)

  ism_policies = merge({
    for filename in var.ism_policy_files :
    replace(basename(filename), "/\\.(ya?ml|json)$/", "") =>
    length(regexall("\\.ya?ml$", filename)) > 0 ? yamldecode(file(filename)) : jsondecode(file(filename))
  }, var.ism_policies)

  roles = merge({
    for filename in var.role_files :
    replace(basename(filename), "/\\.(ya?ml|json)$/", "") =>
    length(regexall("\\.ya?ml$", filename)) > 0 ? yamldecode(file(filename)) : jsondecode(file(filename))
  }, var.roles)

  role_mappings = merge({
    for filename in var.role_mapping_files :
    replace(basename(filename), "/\\.(ya?ml|json)$/", "") =>
    length(regexall("\\.ya?ml$", filename)) > 0 ? yamldecode(file(filename)) : jsondecode(file(filename))
  }, var.role_mappings)
}
