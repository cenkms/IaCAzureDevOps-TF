provider "azurerm" {
  version = "=2.0.0"
  features {}
}

variable "prefix" { 
  default = "app1"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-resources"
  location = "East US 2"
}

data "azurerm_virtual_network" "vnet" {
  name                = "shared-res-network"
  resource_group_name  = "shared-res-resources"
}

data "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = "shared-res-resources"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "testconfiguration2"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id          = azurerm_public_ip.pip.id
  }
}