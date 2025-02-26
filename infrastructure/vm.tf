resource "azurerm_resource_group" "sandbox_rg" {
  name     = "rg-ansible-dv"
  location = "East US"
}

resource "azurerm_virtual_network" "sandbox_vnet" {
  name                = "sandbox-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.sandbox_rg.location
  resource_group_name = azurerm_resource_group.sandbox_rg.name
}

resource "azurerm_subnet" "sandbox_subnet" {
  name                 = "sandbox-subnet"
  resource_group_name  = azurerm_resource_group.sandbox_rg.name
  virtual_network_name = azurerm_virtual_network.sandbox_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "sandbox_nic" {
  name                = "sandbox-nic"
  location            = azurerm_resource_group.sandbox_rg.location
  resource_group_name = azurerm_resource_group.sandbox_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sandbox_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "sandbox_vm" {
  name                  = "sandbox-machine"
  location              = azurerm_resource_group.sandbox_rg.location
  resource_group_name   = azurerm_resource_group.sandbox_rg.name
  network_interface_ids = [azurerm_network_interface.sandbox_nic.id]
  size                  = "Standard_B1s"

  os_disk {
    name                 = "sandbox-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  computer_name  = "sandbox-machine"
  admin_username = "adminuser"
  admin_password = "Password1234!"
  
  disable_password_authentication = false

  # Reference the cloud-init file from an external file
  custom_data = base64encode(file("${path.module}/cloud-init.yml"))
}