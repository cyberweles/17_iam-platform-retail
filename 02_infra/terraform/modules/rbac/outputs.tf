output "reader_assignment_id" {
  value = azurerm_role_assignment.reader.id
}

output "contributor_assignment_id" {
  value = azurerm_role_assignment.contributor.id
}
