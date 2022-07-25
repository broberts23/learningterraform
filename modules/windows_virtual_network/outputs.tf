output "resource_group_id" {
  value = azurerm_resource_group.rg1.id
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.linuxvm1.public_ip_addresses
}

output "vmname" {
  value = azurerm_linux_virtual_machine.linuxvm1.name
}

output "tls_private_key" {
  value     = tls_private_key.sshkey.private_key_pem
  sensitive = true
}