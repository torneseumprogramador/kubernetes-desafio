resource "azurerm_linux_virtual_machine" "myterraformvm" {
  name                  = "myVM"
  location              = "eastus"
  resource_group_name   = "vm-k8s"
  size                  = "Standard_B1ls"

  network_interface_ids = [azurerm_network_interface.main.id]

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
      offer = "0001-com-ubuntu-server-focal"
      publisher = "Canonical"
      sku = "20_04-lts-gen2"
      version = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "ubuntu"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "ubuntu"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6n+egdpEqWRcnPIc0D/c7IVgErojxHldA8C1iFKIKX98GlSXMmzVdVedxMjcs6AMU0puGGBQruQEy9HqqwsbFcEyjPofIJa4oztyXn0VqSPjdWsD3dr/5IkUu38Q0CooLgOXfabSIytwj+810cWX7Kno2GVAfOLKRI0/+JE9Q4poX47DpyF8yN3dRN6aitQmnPioq3NwViHbdHpe7mGhUju6nItDNuN39KeCgA4s2yuDz42sFXsBxjdt3F7j6iaq3iPpOC8+5sYpER1KpxQ4JO1g3dsIOoNzlyLvkUMY46JKCoRh/0crTRKhNXhARiFUpNWOQDfyLFepSD9+hq9Xfa6es4rXKGi0eSv9v5Fc119hSVObjoF7760FDSp/1IMccQw06JS2V/HRHIY9+s5Pm9ChoO/tpdglxPszD2vWjE7JrvHXVZlxyTEi5SQOTBGM/s3dONaW0/tU9ZMgNOgMZ1AOkspyDltXsP2hDK6fOLj5rt8P1vqq//D2wY1Pc04M= danilo@Macbooks-MacBook-Pro.local"
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.az_group.location
  resource_group_name = azurerm_resource_group.az_group.name
}

variable "prefix" {
  default = "tfvmex"
}

resource "azurerm_resource_group" "az_group" {
  name     = "${var.prefix}-resources"
  location = "Central US"
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.az_group.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.az_group.location
  resource_group_name = azurerm_resource_group.az_group.name

  ip_configuration {
    name                          = "k8s-network-desafio"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}