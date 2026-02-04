locals {
  group_prefix = var.prefix

  # -----------------------------
  # Catalog: group display names
  # -----------------------------
  br_groups = [
    "GRP_BR_STORE_EMPLOYEE",
    "GRP_BR_STORE_MANAGER",
    "GRP_BR_HQ_OPERATIONS",
    "GRP_BR_HQ_FINANCE",
    "GRP_BR_HQ_IT_SUPPORT",
    "GRP_BR_IAM_PLATFORM_ENGINEER",
    "GRP_BR_GLOBAL_ADMIN_EMERGENCY",
    "GRP_BR_VENDOR_USER",
    "GRP_BR_GUEST_USER",
  ]

  app_groups = [
    "GRP_APP_POS_USER",
    "GRP_APP_POS_ADMIN",
    "GRP_APP_M365_STORE_TEAM",
    "GRP_APP_M365_HQ_TEAM",
    "GRP_APP_FINANCE_READ",
    "GRP_APP_FINANCE_ADMIN",
    "GRP_APP_ITSM_USER",       # TBD app, kept as group
    "GRP_APP_STORE_REPORTING", # TBD app, kept as group
    "GRP_APP_AZ_BASELINE_READ",
    "GRP_APP_AZ_BASELINE_CONTRIBUTOR",
  ]

  pol_groups = [
    "GRP_POL_INTERNAL_USERS",
    "GRP_POL_GUEST_VENDOR_USERS",
    "GRP_POL_ADMIN_ELEVATED",
    "GRP_POL_FINANCE_USERS",
  ]

  all_groups = toset(concat(local.br_groups, local.app_groups, local.pol_groups))

  # -----------------------------
  # Membership mapping
  # Each entry: parent -> list(children)
  # We implement nested groups by making BR groups members of APP/POL groups.
  # -----------------------------
  membership = {
    # BR -> APP
    "GRP_APP_POS_USER" = [
      "GRP_BR_STORE_EMPLOYEE",
      "GRP_BR_STORE_MANAGER",
    ]

    "GRP_APP_M365_STORE_TEAM" = [
      "GRP_BR_STORE_EMPLOYEE",
      "GRP_BR_STORE_MANAGER",
    ]

    "GRP_APP_STORE_REPORTING" = [
      "GRP_BR_STORE_MANAGER",
    ]

    "GRP_APP_M365_HQ_TEAM" = [
      "GRP_BR_HQ_OPERATIONS",
      "GRP_BR_HQ_FINANCE",
    ]

    "GRP_APP_FINANCE_READ" = [
      "GRP_BR_HQ_FINANCE",
    ]

    "GRP_APP_ITSM_USER" = [
      "GRP_BR_HQ_IT_SUPPORT",
    ]

    "GRP_APP_POS_ADMIN" = [
      "GRP_BR_VENDOR_USER",
    ]

    # Azure RBAC app groups
    "GRP_APP_AZ_BASELINE_READ" = [
      "GRP_BR_HQ_IT_SUPPORT",
    ]

    "GRP_APP_AZ_BASELINE_CONTRIBUTOR" = [
      "GRP_BR_IAM_PLATFORM_ENGINEER",
    ]

    # BR -> POL (CA targeting)
    "GRP_POL_INTERNAL_USERS" = [
      "GRP_BR_STORE_EMPLOYEE",
      "GRP_BR_STORE_MANAGER",
      "GRP_BR_HQ_OPERATIONS",
      "GRP_BR_HQ_FINANCE",
      "GRP_BR_HQ_IT_SUPPORT",
      "GRP_BR_IAM_PLATFORM_ENGINEER",
    ]

    "GRP_POL_GUEST_VENDOR_USERS" = [
      "GRP_BR_VENDOR_USER",
      "GRP_BR_GUEST_USER",
    ]

    "GRP_POL_FINANCE_USERS" = [
      "GRP_BR_HQ_FINANCE",
    ]

    "GRP_POL_ADMIN_ELEVATED" = [
      "GRP_BR_IAM_PLATFORM_ENGINEER",
    ]
  }

  # Flatten membership into pairs: (parent, child)
  membership_pairs = flatten([
    for parent, children in local.membership : [
      for child in children : {
        parent = parent
        child  = child
      }
    ]
  ])

  membership_pairs_map = {
    for p in local.membership_pairs :
    "${p.parent}<- ${p.child}" => p
  }
}

# -----------------------------
# Groups
# -----------------------------
resource "azuread_group" "groups" {
  for_each = local.all_groups

  display_name     = "${local.group_prefix}-${each.value}"
  security_enabled = true
  mail_enabled     = false
}

# -----------------------------
# Nested membership (group-in-group)
# parent group gets child group as member
# -----------------------------
resource "azuread_group_member" "nested" {
  for_each = local.membership_pairs_map

  group_object_id  = azuread_group.groups[each.value.parent].id
  member_object_id = azuread_group.groups[each.value.child].id
}
