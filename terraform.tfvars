#--------------------------------------------------------------
# Deployment settings
#--------------------------------------------------------------

# Azure principal
client_id = "36070b66-0a7b-4bd6-adc8-e9af4a42e451" # Application ID
subscr_id = "12862a05-c847-4c49-a159-ff074bcefaf4" # Subscription ID
tenant_id = "d373cb19-d4db-4f95-aedf-363199c531aa" # Tenant ID

# Azure region

az_region = "West Europe"

# Azure tags

az_tags = {
  environment = "rllabs"
}

# Naming convention

prefix = "rl"
suffix = "mvp"


#--------------------------------------------------------------
# What should be deployed?
#--------------------------------------------------------------
servicebus       = true  # Azure Service Bus
datafactory      = true  # Azure Data Factory
datafactory_git  = false # Enable GIT for Data Factory? (don't forget to set Git settings in the Data Factory section)
databricks       = true  # Azure DataBricks
eventhub         = true  # Azure EventHub
functions        = true  # Azure Functions 
functions_appins = true  # Integrate App.Insights with Azure Functions?
eventgrid        = true  # Azure EventGrid
kusto            = true  # Azure Data Explorer (kusto)
analysis         = true  # Azure Analysis Server


#--------------------------------------------------------------
# Service Bus settings | rlevchenko.com
#--------------------------------------------------------------


# Service Bus namespace

az_sb_sku      = "Standard" # Can be Standard, Basic or Premium
az_sb_capacity = "1"        # NOTE: Change only if Premium SKU is selected. Possible values - 1,2 or 4

# Service Bus Authorization rule (namespace level)

az_sb_rule_listen = true
az_sb_rule_send   = false
az_sb_rule_manage = false

# Service Bus Topic 

az_sb_topic_partitioning       = false # https://docs.microsoft.com/en-us/azure/service-bus-messaging/service-bus-partitioning
az_sb_topic_duplicatedetection = false # https://docs.microsoft.com/en-us/azure/service-bus-messaging/duplicate-detection

# Service Bus Topic Authorization rule

az_sb_topic_rule_listen = true
az_sb_topic_rule_send   = false
az_sb_topic_rule_manage = false

# Service Bus Topic Subscription

az_sb_sub_delcount      = 1
az_sb_sub_deadlettering = false
az_sb_sub_sessions      = false # Enable Sessions?

#--------------------------------------------------------------
# Data Lake Storage settings | rlevchenko.com
#--------------------------------------------------------------

az_stor_acc_tier  = "Standard"  # Standard or Premium
az_stor_repl_type = "ZRS"       # Storage Replication Type
az_stor_kind      = "StorageV2" # Storage Kind
az_stor_tier      = "Hot"       # Tier (Cold/Hot/Archive)
az_stor_secure    = true        # Secured Storage or not? (HTTPS only)

#--------------------------------------------------------------
# Data Factory settings | rlevchenko.com
#--------------------------------------------------------------

git_account  = "value here" # optional (if "Enable Git" required)
git_branch   = "value here" # optional (if "Enable Git" required)
git_hostname = "value here" # optional (if "Enable Git" required)
git_repo     = "value here" # optional (if "Enable Git" required)
git_folder   = "value here" # optional (if "Enable Git" required)

# Azure DataBricks
az_spark_sku = "standard" # "standard/premium"

#--------------------------------------------------------------
# Event Hubs settings | rlevchenko.com
#--------------------------------------------------------------

az_hubns_sku      = "Standard" # Event Hubs SKU (Basic/Standard)
az_hubns_capacity = "1"        # Capacity (Throughput Units)
az_hub_inflate    = "false"    # Auto-inflate (applicable to Standard SKU)
az_hubns_maxunits = "7"        # Max number of units if inflate enabled
az_hub_partcount  = "1"        # Event Hub Partition Count
az_hub_retention  = "1"        # Event Hub Message Retention
az_hub_capture    = "false"    # Enable capture to Azure storage?

#--------------------------------------------------------------
# Function App settings | rlevchenko.com
#--------------------------------------------------------------

az_appsvc_sku        = "Dynamic"  # AppService Plan SKU
az_appsvc_size       = "Y1"       # AppService Plan SKU size
az_funcapp_runtime   = "Python"   # Define runtime stack (python, node, java ..)
az_appins_type       = "web"      # AppInsights type (web, iOS and etc..)
az_appins_enable     = "true"     # If application insights should be enabled?
az_stor_funcapp_tier = "Standard" # Storage account settings
az_stor_funcapp_repl = "LRS"      # Storage replication type

#--------------------------------------------------------------
# Data Explorer (kusto) settings | rlevchenko.com
#--------------------------------------------------------------
az_kusto_sku   = "Standard_D11_v2" # Compute SKUs
az_kusto_nodes = "2"               # Capacity (node counts)

#--------------------------------------------------------------
# Analysis Server settings | rlevchenko.com
#--------------------------------------------------------------
az_stor_ansrv_tier = "Standard"          # Storage Account settings
az_stor_ansrv_repl = "LRS"               # Replication Type
az_ansrv_sku       = "S0"                # Analysis Server SKU
az_ansrv_users     = ["c0urte0us_hotmail.com#EXT#@c0urte0ushotmail.onmicrosoft.com"] # List of emails of admin users
az_ansrv_powerbi   = "true"              # Whether PowerBi be allowed to access or not
az_stor_ssa_start  = "2020-09-10"        # Start date of the SSA token (used for BackUp storage)
az_stor_ssa_end    = "2021-09-10"        # Expiration date of the SSA token (used for BackStorage)

#--------------------------------------------------------------
# Event Grid settings | rlevchenko.com
#--------------------------------------------------------------

az_eventgrid_schema = "EventGridSchema" # EventGridSchema or CloudEventV01Schema or CustomEventSchema

#-----------------------------------------------------------
# Roman Levchenko | rlevchenko.com