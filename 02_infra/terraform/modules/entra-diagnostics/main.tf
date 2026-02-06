resource "azurerm_monitor_aad_diagnostic_setting" "this" {
  name                       = var.name
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = toset(var.categories)
    content {
      category = enabled_log.value

      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }
}