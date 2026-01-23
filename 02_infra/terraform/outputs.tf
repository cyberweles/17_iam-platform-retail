output "business_role_groups" {
  description = "Business role groups (display name → object ID)"
  value = {
    store_employee = azuread_group.br_store_employee.id
    store_manager  = azuread_group.br_store_manager.id
    vendor_user    = azuread_group.br_vendor_user.id
  }
}

output "app_groups" {
  description = "Application groups (display name → object ID)"
  value = {
    pos_user       = azuread_group.app_pos_user.id
    pos_admin      = azuread_group.app_pos_admin.id
    m365_store_team = azuread_group.app_m365_store_team.id
  }
}
