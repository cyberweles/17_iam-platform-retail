provider "azurerm" {
  features {}
}

provider "azuread" {}

module "iam_groups" {
  source = "./modules/iam-groups"
  prefix = local.prefix
}

module "baseline_rg" {
  source = "./modules/baseline-rg"

  name_prefix = local.prefix
  location    = local.location
  tags        = local.tags
}

module "rbac" {
  source = "./modules/rbac"

  scope_id = module.baseline_rg.resource_group_id

  principal_id_reader      = module.iam_groups.group_ids["GRP_APP_AZ_BASELINE_READ"]
  principal_id_contributor = module.iam_groups.group_ids["GRP_APP_AZ_BASELINE_CONTRIBUTOR"]
}