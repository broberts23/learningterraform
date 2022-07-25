# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  byte_length = 8
}


#Create a resource group
resource "azurerm_resource_group" "rg1" {
  name     = "${random_id.randomId.hex}-rg"
  location = var.location
  tags     = merge(local.common_tags)
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet1" {
  name                = var.azurerm_virtual_network1
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg1.name
  tags                = merge(local.common_tags)
}

# Create a subnet
resource "azurerm_subnet" "subnet1" {
  name                 = "vm_subnet"
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a NIC
resource "azurerm_network_interface" "nic1" {
  name                = "nic1"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip1.id
  }
}

# Create public IPs
resource "azurerm_public_ip" "publicip1" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  allocation_method   = "Dynamic"
  tags                = merge(local.common_tags)
}

# Create (and display) an SSH key
resource "tls_private_key" "sshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "sg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  tags                = merge(local.common_tags)
  depends_on = [
    azurerm_linux_virtual_machine.linuxvm1
  ]

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = azurerm_network_security_group.sg.id
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  location                 = azurerm_resource_group.rg1.location
  resource_group_name      = azurerm_resource_group.rg1.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = merge(local.common_tags)
}

# Create a linux VM
resource "azurerm_linux_virtual_machine" "linuxvm1" {
  name                            = "vm${random_id.randomId.hex}"
  resource_group_name             = azurerm_resource_group.rg1.name
  location                        = var.location
  size                            = var.vmsize
  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.nic1.id]
  tags                            = merge(local.common_tags)

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.sshkey.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }
}