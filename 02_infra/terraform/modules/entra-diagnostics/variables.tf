variable "name" {
  type        = string
  description = "Diagnostic setting name."
  default     = "entra-to-law"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Target Log Analytics Workspace ID."
}

variable "categories" {
  type        = list(string)
  description = "Entra ID log categories to send to LAW."
  default     = ["AuditLogs", "SignInLogs"]
}