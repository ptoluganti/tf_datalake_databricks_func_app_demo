data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "current" {
}

data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}
