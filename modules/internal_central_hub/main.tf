# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  byte_length = 8
}

resource "azurerm_resource_group" "rg3" {
  name     = "${random_id.randomId.hex}-rg"
  location = var.location
  tags     = merge(local.common_tags)
}

# Create a virtual hub network
resource "azurerm_virtual_network" "vnet3" {
  name                = var.azurerm_virtual_network3
  address_space       = ["10.2.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg3.name
  tags                = merge(local.common_tags)
}

# Create a firewall subnet
resource "azurerm_subnet" "subnet3" {
  name                 = "hub_subnet"
  resource_group_name  = azurerm_resource_group.rg3.name
  virtual_network_name = azurerm_virtual_network.vnet3.name
  address_prefixes     = ["10.2.1.0/24"]
}
