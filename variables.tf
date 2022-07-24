variable "resource_group_name" {
  default = null
}

variable "azurerm_virtual_network" {
  default = null
}

variable "location" {
  default = null
}

variable "vmsize" {
  default = null
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

variable "resource_group_name_id" {
  type    = string
  default = ""
}
