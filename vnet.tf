# resource "azurerm_virtual_network" "this" {
#   name                = "${local.prefix}-vnet"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   address_space       = [var.cidr]
#   tags                = local.tags
# }

# resource "azurerm_network_security_group" "this" {
#   name                = "${local.prefix}-nsg"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   tags                = local.tags
# }

# resource "azurerm_network_security_rule" "aad" {
#   name                        = "AllowAAD"
#   priority                    = 200
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "443"
#   source_address_prefix       = "VirtualNetwork"
#   destination_address_prefix  = "AzureActiveDirectory"
#   resource_group_name         = azurerm_resource_group.main.name
#   network_security_group_name = azurerm_network_security_group.this.name
# }

# resource "azurerm_network_security_rule" "azfrontdoor" {
#   name                        = "AllowAzureFrontDoor"
#   priority                    = 201
#   direction                   = "Outbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "443"
#   source_address_prefix       = "VirtualNetwork"
#   destination_address_prefix  = "AzureFrontDoor.Frontend"
#   resource_group_name         = azurerm_resource_group.main.name
#   network_security_group_name = azurerm_network_security_group.this.name
# }

# resource "azurerm_subnet" "public" {
#   name                 = "${local.prefix}-public"
#   resource_group_name  = azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.this.name
#   address_prefixes     = [cidrsubnet(var.cidr, 3, 0)]

#   delegation {
#     name = "databricks"
#     service_delegation {
#       name = "Microsoft.Databricks/workspaces"
#       actions = [
#         "Microsoft.Network/virtualNetworks/subnets/join/action",
#         "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
#         "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
#       ]
#     }
#   }
# }

# resource "azurerm_subnet_network_security_group_association" "public" {
#   subnet_id                 = azurerm_subnet.public.id
#   network_security_group_id = azurerm_network_security_group.this.id
# }

# variable "private_subnet_endpoints" {
#   default = []
# }

# resource "azurerm_subnet" "private" {
#   name                 = "${local.prefix}-private"
#   resource_group_name  = azurerm_resource_group.main.name
#   virtual_network_name = azurerm_virtual_network.this.name
#   address_prefixes     = [cidrsubnet(var.cidr, 3, 1)]

#   enforce_private_link_endpoint_network_policies = true
#   enforce_private_link_service_network_policies  = true

#   delegation {
#     name = "databricks"
#     service_delegation {
#       name = "Microsoft.Databricks/workspaces"
#       actions = [
#         "Microsoft.Network/virtualNetworks/subnets/join/action",
#         "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
#       "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"]
#     }
#   }

#   service_endpoints = var.private_subnet_endpoints
# }

# resource "azurerm_subnet_network_security_group_association" "private" {
#   subnet_id                 = azurerm_subnet.private.id
#   network_security_group_id = azurerm_network_security_group.this.id
# }


# resource "azurerm_subnet" "plsubnet" {
#   name                                           = "${local.prefix}-privatelink"
#   resource_group_name                            = azurerm_resource_group.main.name
#   virtual_network_name                           = azurerm_virtual_network.this.name
#   address_prefixes                               = [cidrsubnet(var.cidr, 3, 2)]
#   enforce_private_link_endpoint_network_policies = true
# }
