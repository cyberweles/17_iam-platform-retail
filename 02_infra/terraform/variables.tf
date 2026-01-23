variable "project_prefix" {
  type        = string
  description = "Prefix for all IAM groups, e.g. IAM-RET"
  default     = "IAM-RET"
}

variable "environment" {
  type        = string
  description = "Environment, e.g. dev / prod"
  default     = "dev"
}

variable "tenant_id" {
  type        = string
  description = "Optional: Azure AD tenant ID (if not taken from CLI context)"
  default     = ""
}
