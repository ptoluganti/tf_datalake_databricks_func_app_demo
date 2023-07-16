locals {
  prefix = "abd-pl"
  tags = {
    Environment = "Demo"
    Owner       = lookup(data.external.me.result, "name")
  }

  resource_group_name            = "rg-jd-core-01"
  location                       = "West Europe"
  data_lake_storage_account_name = "stjddtlakestore01"
  storage_account_name           = "stjdcorestore01"
  app_service_plan_name          = "asp-jd-app-01"
  function_app_name              = "lfuncapp-jd-app-01"
  databricks_workspace_name      = "databricks-jd-app-01"
  databricks_cluster_name        = "databricks-jd-cluster-01"
  data_lake_store_name           = "dls-jd-app-01"
}
