#--------------------------------------------------------------
# Deployment settings
#--------------------------------------------------------------

# Azure principal
client_id = "36070b6xxxx" # Application ID
subscr_id = "997f972xxxx" # Subscription ID
tenant_id = "d373cb1xxxx" # Tenant ID

# Azure region

az_region = "West Europe"

# Azure tags

az_tags = {
  environment = "rlevchenko"
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
sqlserver        = true  # Azure SQL Server 
sqlep            = true  # Azure SQL Elastic Pool
sqldb            = true  # Azure SQL Database


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
az_ansrv_users     = ["inbox@rlevchenko.com"] # List of emails/UPNs of admin users
az_ansrv_powerbi   = "true"              # Whether PowerBi be allowed to access or not
az_stor_ssa_start  = "2021-06-07"        # Start date of the SSA token (used for BackUp storage)
az_stor_ssa_end    = "2021-09-10"        # Expiration date of the SSA token (used for BackStorage)

#--------------------------------------------------------------
# Event Grid settings | rlevchenko.com
#--------------------------------------------------------------

az_eventgrid_schema = "EventGridSchema" # EventGridSchema or CloudEventV01Schema or CustomEventSchema

#--------------------------------------------------------------
# SQL Server settings | rlevchenko.com
#--------------------------------------------------------------

az_sqlserver_name = "rlsqlsrv01" # SQL Server Name (optional: random used)
az_sqlserver_version = "12.0" # SQL Server Version (2.0 or 12.0 basically)
az_sqlserver_username = "rladmin" # SQL Admin's username
az_sqlserver_password = "Pass!13!#" # SQL Admin's password 

#Elastic Pool
az_sql_ep_name = "rlsqlep01" # SQL Elastic Pool Name (optional: random used)
az_sql_ep_license_type = "LicenseIncluded" # SQL Elastic Pool License Type (BasePrice/LicenseIncluded)
az_sql_ep_maxsize = "50" # Max Data Size in Gb of the Elastic Pool
az_sql_ep_sku_name = "StandardPool" # SKU Name (only accepts DTU-based)
az_sql_ep_tier = "Standard" # SKU Tier (only accepts DTU-based)
az_sql_ep_capacity = "50" # SQL EP Pool eDTU capacity
az_sql_ep_db_min_capacity = "0" # Min Per-DB Capacity
az_sql_ep_db_max_capacity = "10" # Max Per-DB Capacity

#SQL DB
az_sql_db_name = "rlsqldb01" # SQL DB Name (optional: random used)
az_sql_db_sku_name = "ElasticPool" # SQL DB SKU Name
az_sql_db_maxsize = "5" # SQL DB Max Size in GB

#-----------------------------------------------------------
# Roman Levchenko | rlevchenko.com
