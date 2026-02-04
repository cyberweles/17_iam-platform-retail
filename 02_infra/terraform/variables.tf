variable "prefix" {
  type        = string
  description = "Global naming prefix, e.g. retail-iam"
  default     = "retail-iam"
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
