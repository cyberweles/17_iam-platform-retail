variable "scope_id" {
  type        = string
  description = "RBAC scope (e.g., resource group ID)."
}

variable "principal_id_reader" {
  type        = string
  description = "Object ID of the Entra ID group that gets Reader."
}

variable "principal_id_contributor" {
  type        = string
  description = "Object ID of the Entra ID group that gets Contributor."
}