provider "azurerm" {
  features {}
  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""
}

resource "azurerm_resource_group" "vmexample" {
  name     = "resorcegroupterraform"
  location = "EAST US"
}

resource "azurerm_virtual_network" "vmexample" {
  name                = "vmnetwork"
address_space = ["10.0.0.0/16"]
  location            = azurerm_resource_group.vmexample.location
resource_group_name = azurerm_resource_group.vmexample.name
}

resource "azurerm_subnet" "vmsube" {
  name                 = "vmexample-subnet"
resource_group_name = azurerm_resource_group.vmexample.name
virtual_network_name = azurerm_virtual_network.vmexample.name
address_prefixes = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "vmnic" {
  name                = "vm-nic"
  location            = azurerm_resource_group.vmexample.location
resource_group_name = azurerm_resource_group.vmexample.name

  ip_configuration {
    name                          = "internal"
subnet_id = azurerm_subnet.vmsube.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "machine1"
resource_group_name = azurerm_resource_group.vmexample.name
  location            = azurerm_resource_group.vmexample.location
  size                = "Standard_B1s"

  admin_username      = "admin123"
  admin_password      = "Gesf12rd!Hgj"  # This should be securely managed!
disable_password_authentication = false
network_interface_ids = [
azurerm_network_interface.vmnic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

}
