# Define provider
provider "azurerm" {
    version = "~>2.0"
    features {}
}

#Create Virtual Machine
resource "azurerm_virtual_machine" "CloudVM" {
  name                  = "CloudVM"  
  location              = "West Europe"
  resource_group_name   = "specialisatieproject"
  network_interface_ids = [azurerm_network_interface.NIC1.id]
  vm_size               = "Standard_B1s"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk1"
    disk_size_gb      = "128"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "SriiVM"
    admin_username = "vmadmin"
    admin_password = "Password12345!"
  }


  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/vmadmin/.ssh/authorized_keys"
      key_data = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDi2yCOtc89IHcqVQ9kMkqLXUE2lnR3pTBb60jzAqB3WNzK1sREb1oeFTp81Kf2CrBU7OCJ7gl6wxRlMsBh+UlQly1LtOuYiGnO6fkZa0ytVRVogPeb1DOCIPc9Nu9xe2TvNN2SnaTDxOqnndjUVlsq9edFdXdpsSKN66saCjUAxgj+tSaRjWvUlZaClaRmRu7uoOAoMyZD158pIXZ87anH2Dh7Va4TmRkd24VMCkKpxmCVghHmjA0r+qL4KJbJe3LitxxRIXcMiy3avKMlsKecKm33WytIvBfcITLgnclrxzwBhrJS8E1qwWz95RqqN06zqjbYPCWdtOs3OMUqE/5GtPhJlguFxAK0D/ej6U79E9U+vD+6/JKgiSmQ1O6EEOxaVZPQjL4CTYLQCJ2WMFzORsG6Xrn3Q/P94jwKw+V6tVu8Lj9P0EXq1+fJAI2kiqsUkyAjQel4Tt5yhSD7M8fVlBOfbN5PuI1ek9Q+WzrLbhkxM8A81pn6S4eG2welBwP/uWQax93+AGmOgrKA8kSUuKsJlk1nfo4N0NKOVHF1AqbtShPMrx+0J3GL2IR0hcOXQ1WXohRzMfi27g+2hsZ9e4qoeH1hlHXM7StazaqGJ47xrz/Qc5qrrNRqrPM7t0uq86Qq2JRkVkblUxU3bkGPd8p1B/OJKUqS1xlV11s6/Q== srii@cc-31bbff04-65b89cbcb4-gqr6l"
    }
  
  }

boot_diagnostics {
        enabled     = "true"
        storage_uri = azurerm_storage_account.sa.primary_blob_endpoint
    }
