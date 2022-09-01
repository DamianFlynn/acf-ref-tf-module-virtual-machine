# Solution Template.
#
provider "azurerm" {
  features {}
}

locals {
  module_tag = {
    "module_name"    = basename(abspath(path.module))
    "module_version" = "0.0.1"
  }
  tags = merge(var.tags, local.module_tag)
}



// Example Virtual Machine Delpoyment

// Virtual Machine require a resource group, and subnet to connect to.
resource "azurerm_resource_group" "example" {
  name     = var.resourceGroupName
  location = var.location
}
resource "azurerm_virtual_network" "example" {
  name                = var.name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}


// With the pre-requisites in place, we can now deploy a virtual machine.

module "virtual_machine_ubuntu1804" {
  source = "./modules/virtual_machine"

  location = var.location
  resource_group_name = azurerm_resource_group.example.name
  tags = var.tags

  subnet_id = azurerm_subnet.example.id
  domain_name_label = "damianflynn.info"
}

