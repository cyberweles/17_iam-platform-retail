variable "name_prefix" {
  type        = string
  description = "Prefix used for naming Azure resources."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to all resources."
}