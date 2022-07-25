variable "azurerm_virtual_network2" {
  default = "firewallvNet"
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