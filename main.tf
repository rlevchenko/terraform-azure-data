#-----------------------------------------------------------
# Main configuration file : Author: https://rlevchenko.com :
#-----------------------------------------------------------

#Random string for resources naming
resource "random_string" "rndstr" {
  length  = 4
  lower   = true
  number  = true
  upper   = false
  special = false
}

#Password generator (can be used with any VMs if needed)
resource "random_string" "pwd" {
  length           = 12
  lower            = true
  number           = true
  upper            = true
  special          = true
  override_special = "!#"
  min_numeric      = 3
  min_lower        = 3
  min_upper        = 3
  min_special      = 2
}

#Resource group
resource "azurerm_resource_group" "az_rg" {
  name     = "${var.prefix}-${var.suffix}"
  location = var.az_region
  tags     = var.az_tags
}

#Service Bus namespace
resource "azurerm_servicebus_namespace" "da-svc-svb" {
  name                = "${var.prefix}-sbns"
  resource_group_name = azurerm_resource_group.az_rg.name
  location            = var.az_region
  sku                 = var.az_sb_sku
  zone_redundant      = (var.az_sb_sku != "Premium" ? "false" : "true")
  capacity            = (var.az_sb_sku != "Premium" ? 0 : var.az_sb_capacity)
  tags                = var.az_tags
}

#Service Bus namespaces authorization rule (in addition to the default one)
resource "azurerm_servicebus_namespace_authorization_rule" "da-svc-svb-rule" {
  name                = "${var.prefix}-nsrule-${var.suffix}"
  namespace_name      = "${azurerm_servicebus_namespace.da-svc-svb.name}"
  resource_group_name = "${azurerm_resource_group.az_rg.name}"
  #Permissions
  listen = var.az_sb_rule_listen
  send   = var.az_sb_rule_send
  manage = var.az_sb_rule_manage
}

#Service bus topic
resource "azurerm_servicebus_topic" "da-svc-svb-topic" {
  name                         = "${var.prefix}-topic-${var.suffix}"
  resource_group_name          = "${azurerm_resource_group.az_rg.name}"
  namespace_name               = "${azurerm_servicebus_namespace.da-svc-svb.name}"
  enable_partitioning          = var.az_sb_topic_partitioning
  requires_duplicate_detection = var.az_sb_topic_duplicatedetection
}

#Service Bus Topic Authorization Rule

resource "azurerm_servicebus_topic_authorization_rule" "da-svc-svb-topicrule" {
  name                = "${var.prefix}-rule-${var.suffix}"
  namespace_name      = "${azurerm_servicebus_namespace.da-svc-svb.name}"
  topic_name          = "${azurerm_servicebus_topic.da-svc-svb-topic.name}"
  resource_group_name = "${azurerm_resource_group.az_rg.name}"
  #Permissions
  listen = var.az_sb_topic_rule_listen
  send   = var.az_sb_topic_rule_send
  manage = var.az_sb_topic_rule_manage
}

#Service Bus Topic Subscription 
resource "azurerm_servicebus_subscription" "da-svc-svb-sub" {
  name                                 = "${var.prefix}-sbsub-${var.suffix}"
  resource_group_name                  = "${azurerm_resource_group.az_rg.name}"
  namespace_name                       = "${azurerm_servicebus_namespace.da-svc-svb.name}"
  topic_name                           = "${azurerm_servicebus_topic.da-svc-svb-topic.name}"
  max_delivery_count                   = var.az_sb_sub_delcount
  dead_lettering_on_message_expiration = var.az_sb_sub_deadlettering
  requires_session                     = var.az_sb_sub_sessions
}

#Azure Data Lake storage
resource "azurerm_storage_account" "da-svc-lake" {
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
resource "azurerm_data_factory" "da-svc-factory-git" {
  count               = "${var.az_datafactory_git != "false" ? 1 : 0}"
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
resource "azurerm_data_factory" "da-svc-factory" {
  count               = "${var.az_datafactory_git != "true" ? 1 : 0}"
  name                = "${var.prefix}-factory-${var.suffix}"
  resource_group_name = azurerm_resource_group.az_rg.name
  location            = var.az_region
  tags                = var.az_tags
}

#Azure Data Factory Linking with Data Lake Storage

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "da-svc-factory-linking" {
  name                  = "${var.prefix}-storlink-${var.suffix}"
  resource_group_name   = azurerm_resource_group.az_rg.name
  data_factory_name     = (var.az_datafactory_git != "true" ? azurerm_data_factory.da-svc-factory[0].name : azurerm_data_factory.da-svc-factory-git[0].name)
  service_principal_id  = var.client_id
  service_principal_key = var.client_secret
  tenant                = var.tenant_id
  url                   = azurerm_storage_account.da-svc-lake.primary_dfs_endpoint
}

# Azure Data Factory Pipeline
resource "azurerm_data_factory_pipeline" "da-svc-pipeline" {
  name                = "${var.prefix}-dfpipe-${var.suffix}"
  resource_group_name = azurerm_resource_group.az_rg.name
  data_factory_name   = (var.az_datafactory_git != "true" ? azurerm_data_factory.da-svc-factory[0].name : azurerm_data_factory.da-svc-factory-git[0].name)
}

#Azure DataBricks Workspace
resource "azurerm_databricks_workspace" "da-svc-databricks" {
  name                = "${var.prefix}-spark-${var.suffix}"
  resource_group_name = azurerm_resource_group.az_rg.name
  location            = var.az_region
  sku                 = var.az_spark_sku
  tags                = var.az_tags
}

#Azure Event Hub Namespace
resource "azurerm_eventhub_namespace" "da-svc-hubns" {
  name                     = "${var.prefix}-ehubns-${var.suffix}"
  location                 = var.az_region
  resource_group_name      = azurerm_resource_group.az_rg.name
  sku                      = var.az_hubns_sku
  capacity                 = var.az_hubns_capacity
  auto_inflate_enabled     = (var.az_hubns_sku != "Basic" ? var.az_hub_inflate : "false")
  maximum_throughput_units = (var.az_hub_inflate != "false" ? var.az_hubns_maxunits : "0")
  kafka_enabled            = (var.az_hubns_sku != "Basic" ? var.az_hub_kafka : "false")
  tags                     = var.az_tags
}

#Azure Event Hub
resource "azurerm_eventhub" "da-svc-hub" {
  name                = "${var.prefix}-hub-${var.suffix}"
  namespace_name      = azurerm_eventhub_namespace.da-svc-hubns.name
  resource_group_name = azurerm_resource_group.az_rg.name
  partition_count     = var.az_hub_partcount
  message_retention   = var.az_hub_retention
  #capture_description block here (only Azure Storage atm, Lake is not supported)
}

#Azure Functions
resource "azurerm_storage_account" "da-svc-storacc" {
  name                     = "${var.prefix}stor${random_string.rndstr.result}"
  resource_group_name      = azurerm_resource_group.az_rg.name
  location                 = var.az_region
  account_tier             = var.az_stor_funcapp_tier
  account_replication_type = var.az_stor_funcapp_repl
  account_kind             = var.az_stor_kind
  tags                     = var.az_tags
}

resource "azurerm_app_service_plan" "da-svc-appplan" {
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

resource "azurerm_application_insights" "da-svc-appins" {
  count               = "${var.az_appins_enable == "true" ? 1 : 0}"
  name                = "${var.prefix}appins${random_string.rndstr.result}"
  location            = var.az_region
  resource_group_name = azurerm_resource_group.az_rg.name
  application_type    = var.az_appins_type
  tags                = var.az_tags
}

resource "azurerm_function_app" "da-svc-function-appins" {
  count                     = "${var.az_appins_enable == "true" ? 1 : 0}"
  name                      = "${var.prefix}function${random_string.rndstr.result}"
  location                  = var.az_region
  resource_group_name       = azurerm_resource_group.az_rg.name
  app_service_plan_id       = azurerm_app_service_plan.da-svc-appplan.id
  storage_connection_string = azurerm_storage_account.da-svc-storacc.primary_connection_string
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"       = var.az_funcapp_runtime
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.da-svc-appins[0].instrumentation_key
  }
  tags = var.az_tags
}
resource "azurerm_function_app" "da-svc-function" {
  count                     = "${var.az_appins_enable == "false" ? 1 : 0}"
  name                      = "${var.prefix}function${random_string.rndstr.result}"
  location                  = var.az_region
  resource_group_name       = azurerm_resource_group.az_rg.name
  app_service_plan_id       = azurerm_app_service_plan.da-svc-appplan.id
  storage_connection_string = azurerm_storage_account.da-svc-storacc.primary_connection_string
  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = var.az_funcapp_runtime
  }
  tags = var.az_tags
}

#Azure Data Explorer (Kusto cluster)

resource "azurerm_kusto_cluster" "da-svc-kusto" {
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

resource "azurerm_storage_account" "da-svc-stor-ansrv" {
  name                     = "${var.prefix}ansrvstor${random_string.rndstr.result}"
  resource_group_name      = azurerm_resource_group.az_rg.name
  location                 = var.az_region
  account_tier             = var.az_stor_ansrv_tier
  account_replication_type = var.az_stor_ansrv_repl
  account_kind             = var.az_stor_kind
  tags                     = var.az_tags
}

#Storage Container
resource "azurerm_storage_container" "da-svc-stor-ansrv-cont" {
  name                  = "${var.prefix}ansrv${random_string.rndstr.result}"
  resource_group_name   = azurerm_resource_group.az_rg.name
  storage_account_name  = azurerm_storage_account.da-svc-stor-ansrv.name
  container_access_type = "private"
}

#Storage Account SSA Token generation
data "azurerm_storage_account_blob_container_sas" "cont-sas" {

  connection_string = "${azurerm_storage_account.da-svc-stor-ansrv.primary_connection_string}"
  container_name    = "${azurerm_storage_container.da-svc-stor-ansrv-cont.name}"
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
resource "azurerm_analysis_services_server" "da-svc-ansrv" {
  name                      = "${var.prefix}ansrv${random_string.rndstr.result}"
  location                  = var.az_region
  resource_group_name       = azurerm_resource_group.az_rg.name
  sku                       = var.az_ansrv_sku
  admin_users               = var.az_ansrv_users
  enable_power_bi_service   = var.az_ansrv_powerbi
  backup_blob_container_uri = "${azurerm_storage_container.da-svc-stor-ansrv-cont.id}${data.azurerm_storage_account_blob_container_sas.cont-sas.sas}"
  tags                      = var.az_tags
}

#Azure Event Grid
resource "azurerm_eventgrid_domain" "da-svc-eventgrid" {
  name                = "${var.prefix}eventgrid${random_string.rndstr.result}"
  location            = var.az_region
  resource_group_name = azurerm_resource_group.az_rg.name
  input_schema        = var.az_eventgrid_schema
  tags                = var.az_tags
}

#--------------------------------------------------------
# ::: Author: https://rlevchenko.com :::
#--------------------------------------------------------



