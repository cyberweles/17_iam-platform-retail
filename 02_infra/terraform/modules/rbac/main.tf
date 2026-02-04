resource "azurerm_role_assignment" "reader" {
  scope                = var.scope_id
  role_definition_name = "Reader"
  principal_id         = var.principal_id_reader
}

resource "azurerm_role_assignment" "contributor" {
  scope                = var.scope_id
  role_definition_name = "Contributor"
  principal_id         = var.principal_id_contributor
}
