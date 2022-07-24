variable "resource_group_name" {
  default = "rg"
}

variable "azurerm_virtual_network" {
  default = "Vnet"
}

variable "location" {
  default = "australiaeast"
}

variable "ARM_SUBSCRIPTION_ID" {
  type    = string
  default = ""
}

variable "ARM_CLIENT_SECRET" {
  type    = string
  default = ""
}

variable "ARM_CLIENT_ID" {
  type    = string
  default = ""
}
