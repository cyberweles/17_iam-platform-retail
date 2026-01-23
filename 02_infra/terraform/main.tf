terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.48"
    }
  }
}

provider "azuread" {
  # Option 1: use current Azure CLI context (default)
  # Option 2: set tenant explicitly:
  # tenant_id = var.tenant_id
}

locals {
  project_prefix = var.project_prefix
  environment    = var.environment

  # helper to prefix group names, e.g. "IAM-DEV-GRP_BR_STORE_EMPLOYEE"
  group_prefix = "${local.project_prefix}-${upper(local.environment)}"
}

# -----------------------------
# Business role groups
# -----------------------------

resource "azuread_group" "br_store_employee" {
  display_name     = "${local.group_prefix}-GRP_BR_STORE_EMPLOYEE"
  security_enabled = true
  mail_enabled     = false
}

resource "azuread_group" "br_store_manager" {
  display_name     = "${local.group_prefix}-GRP_BR_STORE_MANAGER"
  security_enabled = true
  mail_enabled     = false
}

resource "azuread_group" "br_vendor_user" {
  display_name     = "${local.group_prefix}-GRP_BR_VENDOR_USER"
  security_enabled = true
  mail_enabled     = false
}

# -----------------------------
# Application groups (simplified)
# -----------------------------

resource "azuread_group" "app_pos_user" {
  display_name     = "${local.group_prefix}-GRP_APP_POS_USER"
  security_enabled = true
  mail_enabled     = false

  # Members: all business roles that should use the POS system
  members = [
    azuread_group.br_store_employee.id,
    azuread_group.br_store_manager.id,
  ]
}

resource "azuread_group" "app_m365_store_team" {
  display_name     = "${local.group_prefix}-GRP_APP_M365_STORE_TEAM"
  security_enabled = true
  mail_enabled     = false

  # Members: all store-related business roles
  members = [
    azuread_group.br_store_employee.id,
    azuread_group.br_store_manager.id,
  ]
}

# -----------------------------
# Example: Vendor has only POS admin role (not store role)
# -----------------------------

resource "azuread_group" "app_pos_admin" {
  display_name     = "${local.group_prefix}-GRP_APP_POS_ADMIN"
  security_enabled = true
  mail_enabled     = false

  # Vendor role mapped to POS admin
  members = [
    azuread_group.br_vendor_user.id,
  ]
}