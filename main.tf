#-----------------------------------------------------------
# Main configuration file | rlevchenko.com
#-----------------------------------------------------------

#Random string for resources naming
resource "random_string" "rndstr" {
  length  = 4
  lower   = true
  number  = true
  upper   = false
  special = false
}

#Resource group
resource "azurerm_resource_group" "az_rg" {
  name     = "${var.prefix}-${var.suffix}"
  location = var.az_region
  tags     = var.az_tags
}

#Service Bus namespace
resource "azurerm_servicebus_namespace" "rlmvp-svc-svb" {
  count               = var.servicebus != "false" ? 1 : 0
  name                = "${var.prefix}-sbns"
  resource_group_name = azurerm_resource_group.az_rg.name
  location            = var.az_region
  sku                 = var.az_sb_sku
  zone_redundant      = (var.az_sb_sku != "Premium" ? "false" : "true")
  capacity            = (var.az_sb_sku != "Premium" ? 0 : var.az_sb_capacity)
  tags                = var.az_tags
}

#Service Bus namespaces authorization rule (in addition to the default one)
resource "azurerm_servicebus_namespace_authorization_rule" "rlmvp-svc-svb-rule" {
  count               = var.servicebus != "false" ? 1 : 0
  name                = "${var.prefix}-nsrule-${var.suffix}"
  namespace_name      = azurerm_servicebus_namespace.rlmvp-svc-svb[count.index].name
  resource_group_name = azurerm_resource_group.az_rg.name
  #Permissions
  listen = var.az_sb_rule_listen
  send   = var.az_sb_rule_send
  manage = var.az_sb_rule_manage
}

#Service bus topic
resource "azurerm_servicebus_topic" "rlmvp-svc-svb-topic" {
  count                        = var.servicebus != "false" ? 1 : 0
  name                         = "${var.prefix}-topic-${var.suffix}"
  resource_group_name          = azurerm_resource_group.az_rg.name
  namespace_name               = azurerm_servicebus_namespace.rlmvp-svc-svb[count.index].name
  enable_partitioning          = var.az_sb_topic_partitioning
  requires_duplicate_detection = var.az_sb_topic_duplicatedetection
}

#Service Bus Topic Authorization Rule

resource "azurerm_servicebus_topic_authorization_rule" "rlmvp-svc-svb-topicrule" {
  count               = var.servicebus != "false" ? 1 : 0
  name                = "${var.prefix}-rule-${var.suffix}"
  namespace_name      = azurerm_servicebus_namespace.rlmvp-svc-svb[count.index].name
  topic_name          = azurerm_servicebus_topic.rlmvp-svc-svb-topic[count.index].name
  resource_group_name = azurerm_resource_group.az_rg.name
  #Permissions
  listen = var.az_sb_topic_rule_listen
  send   = var.az_sb_topic_rule_send
  manage = var.az_sb_topic_rule_manage
}

#Service Bus Topic Subscription 
resource "azurerm_servicebus_subscription" "rlmvp-svc-svb-sub" {
  count                                = var.servicebus != "false" ? 1 : 0
  name                                 = "${var.prefix}-sbsub-${var.suffix}"
  resource_group_name                  = azurerm_resource_group.az_rg.name
  namespace_name                       = azurerm_servicebus_namespace.rlmvp-svc-svb[count.index].name
  topic_name                           = azurerm_servicebus_topic.rlmvp-svc-svb-topic[count.index].name
  max_delivery_count                   = var.az_sb_sub_delcount
  dead_lettering_on_message_expiration = var.az_sb_sub_deadlettering
  requires_session                     = var.az_sb_sub_sessions
}

#Azure Data Lake storage
resource "azurerm_storage_account" "rlmvp-svc-lake" {
  count                     = var.datafactory == "true" || var.datafactory_git == "true" ? 1 : 0
  name                      = "${var.prefix}lake${random_string.rndstr.result}"
  resource_group_name       = azurerm_resource_group.az_rg.name
  location                  = var.az_region
  account_tier              = var.az_stor_acc_tier
  account_replication_type  = var.az_stor_repl_type
  account_kind              = var.az_stor_kind
  enable_https_traffic_only = var.az_stor_secure
  is_hns_enabled            = true
  tags                      = var.az_tags
}

#Azure Data Factory (w/GIT)
resource "azurerm_data_factory" "rlmvp-svc-factory-git" {
  count               = var.datafactory == "true" && var.datafactory_git == "true" ? 1 : 0
  name                = "${var.prefix}-factorygit-${var.suffix}"
  resource_group_name = azurerm_resource_group.az_rg.name
  location            = var.az_region
  tags                = var.az_tags
  github_configuration {
    account_name    = var.git_account
    branch_name     = var.git_branch
    git_url         = var.git_hostname
    repository_name = var.git_repo
    root_folder     = var.git_folder
  }
}

#Azure Data Factory
resource "azurerm_data_factory" "rlmvp-svc-factory" {
  count               = var.datafactory == "true" && var.datafactory_git == "false" ? 1 : 0
  name                = "${var.prefix}-factory-${var.suffix}"
  resource_group_name = azurerm_resource_group.az_rg.name
  location            = var.az_region
  tags                = var.az_tags
}

#Azure Data Factory Linking with Data Lake Storage

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "rlmvp-svc-factory-linking" {
  count                 = var.datafactory == "true" || var.datafactory_git == "true" ? 1 : 0
  name                  = "${var.prefix}-storlink-${var.suffix}"
  resource_group_name   = azurerm_resource_group.az_rg.name
  data_factory_name     = (var.datafactory_git != "true" ? azurerm_data_factory.rlmvp-svc-factory[count.index].name : azurerm_data_factory.rlmvp-svc-factory-git[count.index].name)
  service_principal_id  = var.client_id
  service_principal_key = var.client_secret
  tenant                = var.tenant_id
  url                   = azurerm_storage_account.rlmvp-svc-lake[count.index].primary_dfs_endpoint
}

# Azure Data Factory Pipeline
resource "azurerm_data_factory_pipeline" "rlmvp-svc-pipeline" {
  count               = var.datafactory == "true" ? 1 : 0
  name                = "${var.prefix}-dfpipe-${var.suffix}"
  resource_group_name = azurerm_resource_group.az_rg.name
  data_factory_name   = (var.datafactory_git != "true" ? azurerm_data_factory.rlmvp-svc-factory[count.index].name : azurerm_data_factory.rlmvp-svc-factory-git[count.index].name)
}

#Azure DataBricks Workspace
resource "azurerm_databricks_workspace" "rlmvp-svc-databricks" {
  count               = var.databricks != "false" ? 1 : 0
  name                = "${var.prefix}-spark-${var.suffix}"
  resource_group_name = azurerm_resource_group.az_rg.name
  location            = var.az_region
  sku                 = var.az_spark_sku
  tags                = var.az_tags
}

#Azure Event Hub Namespace
resource "azurerm_eventhub_namespace" "rlmvp-svc-hubns" {
  count                    = var.eventhub != "false" ? 1 : 0
  name                     = "${var.prefix}-ehubns-${var.suffix}"
  location                 = var.az_region
  resource_group_name      = azurerm_resource_group.az_rg.name
  sku                      = var.az_hubns_sku
  capacity                 = var.az_hubns_capacity
  auto_inflate_enabled     = (var.az_hubns_sku != "Basic" ? var.az_hub_inflate : "false")
  maximum_throughput_units = (var.az_hub_inflate != "false" ? var.az_hubns_maxunits : "0")
  tags                     = var.az_tags
}

#Azure Event Hub
resource "azurerm_eventhub" "rlmvp-svc-hub" {
  count               = var.eventhub != "false" ? 1 : 0
  name                = "${var.prefix}-hub-${var.suffix}"
  namespace_name      = azurerm_eventhub_namespace.rlmvp-svc-hubns[count.index].name
  resource_group_name = azurerm_resource_group.az_rg.name
  partition_count     = var.az_hub_partcount
  message_retention   = var.az_hub_retention
  #capture_description block here (only Azure Storage atm, Lake is not supported)
}

#Azure Functions
resource "azurerm_storage_account" "rlmvp-svc-storacc" {
  count                    = var.functions != "false" ? 1 : 0
  name                     = "${var.prefix}stor${random_string.rndstr.result}"
  resource_group_name      = azurerm_resource_group.az_rg.name
  location                 = var.az_region
  account_tier             = var.az_stor_funcapp_tier
  account_replication_type = var.az_stor_funcapp_repl
  account_kind             = var.az_stor_kind
  tags                     = var.az_tags
}

resource "azurerm_app_service_plan" "rlmvp-svc-appplan" {
  count               = var.functions != "false" ? 1 : 0
  name                = "${var.prefix}appplan${random_string.rndstr.result}"
  location            = var.az_region
  resource_group_name = azurerm_resource_group.az_rg.name
  kind                = "FunctionApp"

  sku {
    tier = var.az_appsvc_sku
    size = var.az_appsvc_size
  }
  tags = var.az_tags
}

resource "azurerm_application_insights" "rlmvp-svc-appins" {
  count               = var.functions == "true" && var.functions_appins == "true" ? 1 : 0
  name                = "${var.prefix}appins${random_string.rndstr.result}"
  location            = var.az_region
  resource_group_name = azurerm_resource_group.az_rg.name
  application_type    = var.az_appins_type
  tags                = var.az_tags
}

resource "azurerm_function_app" "rlmvp-svc-function-appins" {
  count                      = var.functions == "true" && var.functions_appins == "true" ? 1 : 0
  name                       = "${var.prefix}function${random_string.rndstr.result}"
  location                   = var.az_region
  resource_group_name        = azurerm_resource_group.az_rg.name
  app_service_plan_id        = azurerm_app_service_plan.rlmvp-svc-appplan[count.index].id
  storage_account_name       = azurerm_storage_account.rlmvp-svc-storacc[count.index].name
  storage_account_access_key = azurerm_storage_account.rlmvp-svc-storacc[count.index].primary_access_key
  # storage_connection_string = azurerm_storage_account.rlmvp-svc-storacc[count.index].primary_connection_string (deprecated; works though)
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"       = var.az_funcapp_runtime
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.rlmvp-svc-appins[count.index].instrumentation_key
  }
  tags = var.az_tags
}
resource "azurerm_function_app" "rlmvp-svc-function" {
  count                      = var.functions == "true" && var.functions_appins == "false" ? 1 : 0
  name                       = "${var.prefix}function${random_string.rndstr.result}"
  location                   = var.az_region
  resource_group_name        = azurerm_resource_group.az_rg.name
  app_service_plan_id        = azurerm_app_service_plan.rlmvp-svc-appplan[count.index].id
  storage_account_name       = azurerm_storage_account.rlmvp-svc-storacc[count.index].name
  storage_account_access_key = azurerm_storage_account.rlmvp-svc-storacc[count.index].primary_access_key
  # storage_connection_string = azurerm_storage_account.rlmvp-svc-storacc[count.index].primary_connection_string (deprecated; works though)
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = var.az_funcapp_runtime
  }
  tags = var.az_tags
}

#Azure SQL Server
resource "azurerm_sql_server" "rlmvp-svc-sql-server" {
  count                        = var.sqlserver == "true" ? 1 : 0
  name                         = "${var.prefix}sqlsrv${random_string.rndstr.result}"
  resource_group_name          = azurerm_resource_group.az_rg.name
  location                     = var.az_region
  version                      = var.az_sqlserver_version
  administrator_login          = var.az_sqlserver_username
  administrator_login_password = var.az_sqlserver_password
  tags                         = var.az_tags
}

#Azure SQL Elastic Pool
resource "azurerm_mssql_elasticpool" "rlmvp-svc-sql-elastic-pool" {
  count               = var.sqlep == "true" && var.sqlserver == "true" ? 1 : 0
  name                = "${var.prefix}sqlep${random_string.rndstr.result}"
  resource_group_name = azurerm_resource_group.az_rg.name
  location            = var.az_region
  server_name         = azurerm_sql_server.rlmvp-svc-sql-server[count.index].name
  license_type        = var.az_sql_ep_license_type
  max_size_gb         = var.az_sql_ep_maxsize
  sku {
    name     = var.az_sql_ep_sku_name
    tier     = var.az_sql_ep_tier
    capacity = var.az_sql_ep_capacity
  }
  per_database_settings {
    min_capacity = var.az_sql_ep_db_min_capacity
    max_capacity = var.az_sql_ep_db_max_capacity
  }
  tags = var.az_tags

}

#Azure SQL Database
resource "azurerm_mssql_database" "rlmvp-svc-sql-db" {
  count           = var.sqlserver == "true" && var.sqldb == "true" ? 1 : 0
  name            = "${var.prefix}sqldb${random_string.rndstr.result}"
  elastic_pool_id = var.sqlep == "true" ? azurerm_mssql_elasticpool.rlmvp-svc-sql-elastic-pool[count.index].id : null
  server_id       = azurerm_sql_server.rlmvp-svc-sql-server[count.index].id
  max_size_gb     = var.az_sql_db_maxsize
  sku_name        = var.az_sql_db_sku_name
  tags            = var.az_tags
}

#Azure Data Explorer (Kusto cluster)

resource "azurerm_kusto_cluster" "rlmvp-svc-kusto" {
  count               = var.kusto == "true" ? 1 : 0
  name                = "${var.prefix}kusto${random_string.rndstr.result}"
  location            = var.az_region
  resource_group_name = azurerm_resource_group.az_rg.name
  sku {
    name     = var.az_kusto_sku
    capacity = var.az_kusto_nodes
  }
  tags = var.az_tags
}

#Azure Analysis Server with BackUp Enabled

resource "azurerm_storage_account" "rlmvp-svc-stor-ansrv" {
  count                    = var.analysis == "true" ? 1 : 0
  name                     = "${var.prefix}ansrvstor${random_string.rndstr.result}"
  resource_group_name      = azurerm_resource_group.az_rg.name
  location                 = var.az_region
  account_tier             = var.az_stor_ansrv_tier
  account_replication_type = var.az_stor_ansrv_repl
  account_kind             = var.az_stor_kind
  tags                     = var.az_tags
}

#Storage Container
resource "azurerm_storage_container" "rlmvp-svc-stor-ansrv-cont" {
  count                 = var.analysis == "true" ? 1 : 0
  name                  = "${var.prefix}ansrv${random_string.rndstr.result}"
  storage_account_name  = azurerm_storage_account.rlmvp-svc-stor-ansrv[count.index].name
  container_access_type = "private"
}

#Storage Account SSA Token generation
data "azurerm_storage_account_blob_container_sas" "cont-sas" {
  count             = var.analysis == "true" ? 1 : 0
  connection_string = azurerm_storage_account.rlmvp-svc-stor-ansrv[count.index].primary_connection_string
  container_name    = azurerm_storage_container.rlmvp-svc-stor-ansrv-cont[count.index].name
  https_only        = true
  start             = var.az_stor_ssa_start
  expiry            = var.az_stor_ssa_end
  permissions {
    read   = true
    add    = true
    create = true
    write  = true
    delete = false
    list   = true
  }
}

#Analysis Server
resource "azurerm_analysis_services_server" "rlmvp-svc-ansrv" {
  count                     = var.analysis == "true" ? 1 : 0
  name                      = "${var.prefix}ansrv${random_string.rndstr.result}"
  location                  = var.az_region
  resource_group_name       = azurerm_resource_group.az_rg.name
  sku                       = var.az_ansrv_sku
  admin_users               = var.az_ansrv_users
  enable_power_bi_service   = var.az_ansrv_powerbi
  backup_blob_container_uri = "${azurerm_storage_container.rlmvp-svc-stor-ansrv-cont[count.index].id}${data.azurerm_storage_account_blob_container_sas.cont-sas[count.index].sas}"
  tags                      = var.az_tags
}

#Azure Event Grid
resource "azurerm_eventgrid_domain" "rlmvp-svc-eventgrid" {
  count               = var.eventgrid == "true" ? 1 : 0
  name                = "${var.prefix}eventgrid${random_string.rndstr.result}"
  location            = var.az_region
  resource_group_name = azurerm_resource_group.az_rg.name
  input_schema        = var.az_eventgrid_schema
  tags                = var.az_tags
}

#-----------------------------------------------------------
# Roman Levchenko | rlevchenko.com
