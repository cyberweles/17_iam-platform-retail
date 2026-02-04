output "iam_group_ids" {
  value       = module.iam_groups.group_ids
  description = "Entra ID group IDs created by the iam-groups module."
}

output "baseline" {
  value = {
    resource_group_name = module.baseline_rg.resource_group_name
    resource_group_id   = module.baseline_rg.resource_group_id
    law_id              = module.baseline_rg.law_id
  }
}

output "rbac" {
  value = {
    reader_assignment_id      = module.rbac.reader_assignment_id
    contributor_assignment_id = module.rbac.contributor_assignment_id
  }
}