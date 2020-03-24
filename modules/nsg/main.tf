provider "azurerm" {
  version = "=2.0.0"
  features {}
}

variable "rg-name" {
  default = "app1"
  type    = string

}

variable "nsg-name" {
  type = string
}

variable "location" {
  type = string
  default = "East US"
}


data "azurerm_resource_group" "rg" {
  name     = var.rg-name
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg-name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

output "nsg-id" {
  value = azurerm_network_security_group.nsg.id
}
