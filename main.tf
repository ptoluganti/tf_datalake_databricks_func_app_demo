resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = local.location
}


resource "azurerm_storage_account" "main" {
  name                     = local.data_lake_storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true
}

# resource "azurerm_storage_account_network_rules" "example" {
#   storage_account_id = azurerm_storage_account.main.id

#   default_action             = "Allow"
#   ip_rules                   = ["127.0.0.1"]
#   virtual_network_subnet_ids = []
#   bypass                     = ["Metrics"]
# }

resource "azurerm_role_assignment" "st_role_admin_c" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "st_role_admin_sbdc" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "st_role_admin_sqdc" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_storage_data_lake_gen2_filesystem" "default" {
  name               = "default"
  storage_account_id = azurerm_storage_account.main.id

  depends_on = [
    azurerm_role_assignment.st_role_admin_c,
    azurerm_role_assignment.st_role_admin_sbdc,
    azurerm_role_assignment.st_role_admin_sqdc
  ]
}


# resource "azurerm_storage_account" "app_main" {
#   name                     = local.storage_account_name
#   resource_group_name      = azurerm_resource_group.main.name
#   location                 = azurerm_resource_group.main.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   account_kind             = "StorageV2"
# }

# resource "azurerm_service_plan" "app_main" {
#   name                = local.app_service_plan_name
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   os_type             = "Linux"
#   sku_name            = "Y1"
# }

# resource "azurerm_linux_function_app" "app_main" {
#   name                       = local.function_app_name
#   resource_group_name        = azurerm_resource_group.main.name
#   location                   = azurerm_resource_group.main.location
#   storage_account_name       = azurerm_storage_account.app_main.name
#   storage_account_access_key = azurerm_storage_account.app_main.primary_access_key
#   service_plan_id            = azurerm_service_plan.app_main.id
#   site_config {}
# }
