variable "azurerm_virtual_network2" {
  default = "Internal Hub vNet"
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