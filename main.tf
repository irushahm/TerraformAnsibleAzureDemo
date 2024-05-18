# Configure Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}


# Resource Group
resource "azurerm_resource_group" "webserver_rg" {
  name     = "irmalk-tf-webserver-rg"
  location = "southeastasia"
}

# Virtual Network
resource "azurerm_virtual_network" "webserver_vnet" {
  name                = "webserver-vnet"
  location            = azurerm_resource_group.webserver_rg.location
  resource_group_name = azurerm_resource_group.webserver_rg.name
  address_space       = ["10.0.0.0/16"]
}

#Subnet
resource "azurerm_subnet" "webserver-nic-subnet" {
  name                 = "webserver-nic-subnet"
  resource_group_name  = azurerm_resource_group.webserver_rg.name
  virtual_network_name = azurerm_virtual_network.webserver_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

#Public IP
resource "azurerm_public_ip" "webserver-nic-pip" {
  name                = "webserver-nic-pip"
  resource_group_name = azurerm_resource_group.webserver_rg.name
  location            = azurerm_resource_group.webserver_rg.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

# Network Interface
resource "azurerm_network_interface" "webserver_nic" {
  name                = "webserver-nic"
  location            = azurerm_resource_group.webserver_rg.location
  resource_group_name = azurerm_resource_group.webserver_rg.name

  ip_configuration {
    name                          = "webserver-ip-config"
    subnet_id                    = azurerm_subnet.webserver-nic-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.webserver-nic-pip.id
  }
}

# Linux VM
resource "azurerm_linux_virtual_machine" "webserver_vm" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.webserver_rg.name
  location            = azurerm_resource_group.webserver_rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password = "qwerty@admin789"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.webserver_nic.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

output "webserver_vm_public_ip" {
  value = azurerm_public_ip.webserver-nic-pip.ip_address
}
