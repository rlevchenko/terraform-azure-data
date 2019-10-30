#--------------------------------------------------------------
# Deployment settings
#--------------------------------------------------------------

#Azure principal
client_id = "36070b66-0a7b-4bd6-adc8-e9af4a42e451" #Application ID
subscr_id = "997f9727-b7fc-40b8-9509-cf9e6a95bee1" #Subscription ID
tenant_id = "d373cb19-d4db-4f95-aedf-363199c531aa" #Tenant ID

#Azure region

az_region = "West Europe"

#Azure tags

az_tags = {
  environment = "PoC"
}

#Naming conventions

prefix = "da"
suffix = "data"

#--------------------------------------------------------------
# Service Bus
#--------------------------------------------------------------


#Service Bus namespace

az_sb_sku      = "Standard" # Can be Standard, Basic or Premium
az_sb_capacity = "1"        # NOTE: Change only if Premium SKU is selected. Possible values - 1,2 or 4

#Service Bus Authorization rule (namespace level)

az_sb_rule_listen = true
az_sb_rule_send   = false
az_sb_rule_manage = false

#Service Bus Topic 

az_sb_topic_partitioning       = false # https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-partitioning
az_sb_topic_duplicatedetection = false # https://docs.microsoft.com/en-us/azure/service-bus-messaging/duplicate-detection

#Service Bus Topic Authorization rule

az_sb_topic_rule_listen = true
az_sb_topic_rule_send   = false
az_sb_topic_rule_manage = false

#Service Bus Topic Subscription

az_sb_sub_delcount      = 1
az_sb_sub_deadlettering = false
az_sb_sub_sessions      = false #Enable Sessions?

#--------------------------------------------------------------
# Data Lake Storage
#--------------------------------------------------------------

az_stor_acc_tier  = "Standard"  #Standard or Premium
az_stor_repl_type = "ZRS"       #Storage Replication Type
az_stor_kind      = "StorageV2" #Storage Kind
az_stor_tier      = "Hot"       #Tier (Cold/Hot/Archive)
az_stor_secure    = true        #Secured Storage or not? (HTTPS only)

#--------------------------------------------------------------
# Data Factory
#--------------------------------------------------------------

git_account        = "value here" #optional (if "Enable Git" required)
git_branch         = "value here" #optional (if "Enable Git" required)
git_hostname       = "value here" #optional (if "Enable Git" required)
git_repo           = "value here" #optional (if "Enable Git" required)
git_folder         = "value here" #optional (if "Enable Git" required)
az_datafactory_git = false        # Is GIT should be enabled?

#Azure DataBricks
az_spark_sku = "standard" # "standard/premium"

#--------------------------------------------------------------
# Event Hubs
#--------------------------------------------------------------

az_hubns_sku      = "Standard" #Event Hubs SKU (Basic/Standard)
az_hubns_capacity = "1"        # Capacity (Throughput Units)
az_hub_inflate    = "false"    # Auto-inflate (applicable to Standard SKU)
az_hubns_maxunits = "7"        # Max number of units if inflate enabled
az_hub_kafka      = "false"    # Kafka enabled? (actually azure automatically enables it if standard SKU used)
az_hub_partcount  = "1"        # Event Hub Partition Count
az_hub_retention  = "1"        #Event Hub Message Retention
az_hub_capture    = "false"    #Enable capture to Azure storage?

#--------------------------------------------------------------
# Function App
#--------------------------------------------------------------

az_appsvc_sku        = "Dynamic"  #AppService Plan SKU
az_appsvc_size       = "Y1"       #AppService Plan SKU size
az_funcapp_runtime   = "Python"   #Define runtime stack (python, node, java ..)
az_appins_type       = "web"      # AppInsights type (web, iOS and etc..)
az_appins_enable     = "true"     #If application insights should be enabled?
az_stor_funcapp_tier = "Standard" #Storage account settings
az_stor_funcapp_repl = "LRS"      # Storage replication type

#--------------------------------------------------------------
# Data Explorer (kusto)
#--------------------------------------------------------------
az_kusto_sku   = "Standard_D11_v2" #Compute SKUs
az_kusto_nodes = "2"               #Capacity (node counts)

#--------------------------------------------------------------
# Analysis Server
#--------------------------------------------------------------
az_stor_ansrv_tier = "Standard"                                                      #Storage Account settings
az_stor_ansrv_repl = "LRS"                                                           #Replication Type
az_ansrv_sku       = "S0"                                                            #Analysis Server SKU
az_ansrv_users     = ["c0urte0us_hotmail.com#EXT#@c0urte0ushotmail.onmicrosoft.com"] #List of emails of admin users
az_ansrv_powerbi   = "true"                                                          #Whether PowerBi be allowed to access or not
az_stor_ssa_start  = "2019-10-28"                                                    #Start date of the SSA token (used for BackUp storage)
az_stor_ssa_end    = "2020-10-28"                                                    #Expiration date of the SSA token (used for BackStorage)

#--------------------------------------------------------------
# Event Grid
#--------------------------------------------------------------

az_eventgrid_schema = "EventGridSchema" # EventGridSchema or CloudEventV01Schema or CustomEventSchema

#--------------------------------------------------------
# ::: Author: https://rlevchenko.com :::
#--------------------------------------------------------
