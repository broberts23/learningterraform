variable "azurerm_virtual_network3" {
  default = "InternalHubvNet"
}

variable "location" {
  default = "australiaeast"
}

locals {
  common_tags = {
    Name        = "TerraformTesting"
    Environment = "DevOps"
  }
}