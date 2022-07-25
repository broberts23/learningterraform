variable "resource_group_name_id" {
  type    = string
  default = ""
}

variable "azurerm_virtual_network1" {
  default = "Vnet1"
}

variable "location" {
  default = "australiaeast"
}


variable "vmsize" {
  default = "Standard_DS1_v2"
}

locals {
  common_tags = {
    Name        = "TerraformTesting"
    Environment = "DevOps"
  }
}