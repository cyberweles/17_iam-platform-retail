locals {
  prefix   = var.prefix
  location = "westeurope"

  tags = {
    system      = local.prefix
    owner       = "platform"
    environment = "shared"
  }
}
