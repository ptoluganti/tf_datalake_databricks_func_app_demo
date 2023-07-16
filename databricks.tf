resource "azurerm_databricks_workspace" "this" {
  name                = local.databricks_workspace_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "standard"
  #   public_network_access_enabled         = false
  #   network_security_group_rules_required = "AllRules"
}

output "databricks_host" {
  value = "https://${azurerm_databricks_workspace.this.workspace_url}/"
}
