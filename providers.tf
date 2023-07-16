terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~>1"
    }
  }
}

provider "azurerm" {
  features {
  }
}

provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.this.id
}
