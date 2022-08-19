resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

data "azurerm_subnet" "main" {
  name                 = var.network.subnet_name
  virtual_network_name = var.network.virtual_network_name
  resource_group_name  = var.network.resource_group_name
}

resource "azurerm_network_interface" "main" {
  name                = "nic-${local.suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.main.subnet_id
    private_ip_address_allocation = "Dynamic"
  }  
}

resource "azurerm_windows_virtual_machine" "main" {

  name                = "vm${local.suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = random_password.password.result

  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}