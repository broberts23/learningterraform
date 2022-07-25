# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  byte_length = 8
}

resource "azurerm_resource_group" "rg2" {
  name     = "${random_id.randomId.hex}-rg"
  location = var.location
  tags     = merge(local.common_tags)
}

# Create a firewall subnet
resource "azurerm_subnet" "subnet2" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg2.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.1.1.0/24"]
}

# Create a virtual hub network
resource "azurerm_virtual_network" "vnet2" {
  name                = var.azurerm_virtual_network2
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg2.name
  tags                = merge(local.common_tags)
}

resource "azurerm_public_ip" "pupic_ip_firewall2" {
  name                = "pupic_ip_firewall2"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "azurefirewall1" {
  name                = "azurefirewall1"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet2.id
    public_ip_address_id = azurerm_public_ip.pupic_ip_firewall2.id
  }
}