# Define provider
provider "azurerm" {
    version = "~>2.0"
    features {}
}

# Create virtual network
resource "azurerm_virtual_network" "CloudVnet" {
    name                = "CloudVnet"
    address_space       = ["10.0.0.0/16"]
    location            = "West Europe"
    resource_group_name = "specialisatieproject"

    tags = {
        environment = "Terraform"
    }
}

# Create subnet
resource "azurerm_subnet" "CloudPubSub" {
    name                 = "CloudPubSub"
    resource_group_name = "specialisatieproject"
    virtual_network_name = azurerm_virtual_network.CloudVnet.name
    address_prefix       = "10.0.1.0/24"
}
resource "azurerm_subnet" "CloudPrivSub" {
    name                 = "CloudPrivSub"
    resource_group_name = "specialisatieproject"
    virtual_network_name = azurerm_virtual_network.CloudVnet.name
    address_prefix       = "10.0.2.0/24"
}

#Create Network Security Group

resource "azurerm_network_security_group" "CloudNSG" {
  name                = "CloudNSG"
  location            = "West Europe"
  resource_group_name = "specialisatieproject"
}

#  Allow port 80
resource "azurerm_network_security_rule" "Web80" {
  name                        = "Web80"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "specialisatieproject"
  network_security_group_name = azurerm_network_security_group.CloudNSG.name
}

#  Allow ICMP 
resource "azurerm_network_security_rule" "Ping" {
  name                        = "Ping"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "ICMP"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "specialisatieproject"
  network_security_group_name = azurerm_network_security_group.CloudNSG.name
}

#  Allow port SSH
  resource "azurerm_network_security_rule" "SSH" {
  name                        = "SSH"
  priority                    = 1100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "specialisatieproject"
  network_security_group_name = azurerm_network_security_group.CloudNSG.name
}

#Deploy Public IP
resource "azurerm_public_ip" "pubip" {
  name                = "pubip"
  location            = "West Europe"
  resource_group_name = "specialisatieproject"
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

#Create NIC
resource "azurerm_network_interface" "NIC1" {
  name                = "NIC1"  
  location            = "West Europe"
  resource_group_name = "specialisatieproject"

    ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.CloudPubSub.id 
    private_ip_address_allocation  = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pubip.id
  }
}

#Create Boot Diagnostic Account
resource "azurerm_storage_account" "sa" {
  name                     = "diagacsrii5725270" 
  resource_group_name      = "specialisatieproject"
  location                 = "West Europe"
   account_tier            = "Standard"
   account_replication_type = "LRS"

   tags = {
    environment = "Boot Diagnostic Storage"
    CreatedBy = "Admin"
   }
  }
