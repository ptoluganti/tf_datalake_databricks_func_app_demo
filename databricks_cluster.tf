# # Create the cluster with the "smallest" amount
# # of resources allowed.
# data "databricks_node_type" "smallest" {
#   depends_on = [azurerm_databricks_workspace.this]
#   local_disk = true
# }

# # Use the latest Databricks Runtime
# # Long Term Support (LTS) version.
# data "databricks_spark_version" "latest_lts" {
#   depends_on        = [azurerm_databricks_workspace.this]
#   long_term_support = true
# }

# resource "databricks_instance_pool" "smallest_nodes" {
#   instance_pool_name                    = "SmallestNodes"
#   min_idle_instances                    = 0
#   max_capacity                          = 10
#   node_type_id                          = data.databricks_node_type.smallest.id
#   idle_instance_autotermination_minutes = 10
# }

# resource "databricks_cluster" "this" {
#   depends_on              = [azurerm_databricks_workspace.this]
#   cluster_name            = local.databricks_cluster_name
#   node_type_id            = data.databricks_node_type.smallest.id
#   spark_version           = data.databricks_spark_version.latest_lts.id
#   instance_pool_id        = databricks_instance_pool.smallest_nodes.id
#   autotermination_minutes = 20
#   autoscale {
#     min_workers = 1
#     max_workers = 50
#   }
#   spark_conf = {
#     "spark.databricks.io.cache.enabled" : true,
#     "spark.databricks.io.cache.maxDiskUsage" : "50g",
#     "spark.databricks.io.cache.maxMetaDataCache" : "1g"
#   }

#   custom_tags = {
#     "ResourceClass" = "SmallestNodes"
#   }
# }

# output "cluster_url" {
#   value = databricks_cluster.this.url
# }
