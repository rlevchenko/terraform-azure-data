#--------------------------------------------------------------
# Deployment variables ::: Author: https://rlevchenko.com :::
#--------------------------------------------------------------

#Naming (prefix)
variable "prefix" {
  type        = "string"
  description = "The prefix that should be used for resources"
}

#Naming (suffix)
variable "suffix" {
  type        = "string"
  description = "The suffix that should be for resources"
}

#Location
variable "az_region" {
  type        = "string"
  description = "The default location for resources"
}

#Tags
variable "az_tags" {
  type        = "map"
  description = "The default tags for resources and resources groups"
}

#Service Bus SKU
variable "az_sb_sku" {
  type        = "string"
  description = "The default Service Bus SKU"
}

#Service Bus Capacity
variable "az_sb_capacity" {
  type        = "string"
  description = "The default Service Bus number of message units (only allowed for Premium)"
}

#Service Bus Namespace Authorization Rule (permissions)

variable "az_sb_rule_listen" {
  type        = "string"
  description = "Listen permissions false or true"
}

variable "az_sb_rule_send" {
  type        = "string"
  description = "Read permissions false or true"
}

variable "az_sb_rule_manage" {
  type        = "string"
  description = "Manage permissions false or true"
}

#Service Bus Topic Settings

variable "az_sb_topic_partitioning" {
  type        = "string"
  description = "Should we enable partitioning?"
}

variable "az_sb_topic_duplicatedetection" {
  type        = "string"
  description = "Should we enable duplicate detection?"
}

#Service Bus Topic Authorization Rule
variable "az_sb_topic_rule_listen" {
  type        = "string"
  description = "Listen permissions false or true"
}

variable "az_sb_topic_rule_send" {
  type        = "string"
  description = "Read permissions false or true"
}

variable "az_sb_topic_rule_manage" {
  type        = "string"
  description = "Manage permissions false or true"
}

#Service Bus Topic Subscription settings
variable "az_sb_sub_delcount" {
  type        = "string"
  description = "How many maximum delivery count are you going to use?"
}

variable "az_sb_sub_deadlettering" {
  type        = "string"
  description = "Whether the Subscription has dead letter support when a message expires?"
}

variable "az_sb_sub_sessions" {
  type        = "string"
  description = "Do you want to enable sessions on the subscription?"
}

#Azure Storage
variable "az_stor_acc_tier" {
  type        = "string"
  description = "Azure Storage Account Tier (Std/Premium)"
}

variable "az_stor_repl_type" {
  type        = "string"
  description = "Azure Storage Replication Type (GRS/LRS/RA-GRS)"
}

variable "az_stor_kind" {
  type        = "string"
  description = "Azure Storage Account Kind (V1/V2/Blob)"
}

variable "az_stor_tier" {
  type        = "string"
  description = "Azure Storage Access Tier (Hot/Cool)"
}

variable "az_stor_secure" {
  type        = "string"
  description = "Is Azure Secure Transfer Required?"
}

#Azure Data Factory
variable "git_account" {
  type        = "string"
  description = "GitHub Account Name"
}

variable "git_branch" {
  type        = "string"
  description = "The Branch of the Repository to get code from"
}

variable "git_hostname" {
  type        = "string"
  description = "The GitHub Ent hostname or github.com if open source repo"
}

variable "git_repo" {
  type        = "string"
  description = "The name of the Git repo"
}

variable "git_folder" {
  type        = "string"
  description = "The root folder within the repo"
}

variable "az_datafactory_git" {
  type        = "string"
  description = "The variable to control deployment of Azure Data Factory w/ or without GIT"
}

#Azure DataBricks
variable "az_spark_sku" {
  type        = "string"
  description = "The Azure DataBricks (Apache Spark) SKU - Standard, Premium or Trial"
}

#Azure Event Hubs Namespace
variable "az_hubns_sku" {
  type        = "string"
  description = "The Azure Event Hubs Sku (Basic/Standard)"
}

variable "az_hubns_maxunits" {
  type        = "string"
  description = "If  auto_inflate_enabled is set to True, defines maximum throughput units"
}

variable "az_hub_inflate" {
  type        = "string"
  description = "Should we enable auto_inflate on Event Hubs namespace? (true/false)"
}

variable "az_hubns_capacity" {
  type        = "string"
  description = "The Azure Event Hubs capacity (throughput units). Only applicable if SKU is Standard"
}

variable "az_hub_kafka" {
  type        = "string"
  description = "(only for Standard) Should we enable Kafka on namespace?"
}

variable "az_hub_partcount" {
  type        = "string"
  description = "Azure Event Partition Count (1-32)"
}

variable "az_hub_retention" {
  type        = "string"
  description = "Azure Event Hub Message Retention (days)"
}

variable "az_hub_capture" {
  type        = "string"
  description = "Should we enable capturing to Azure Storage?"
}

#Azure Funtion App

variable "az_appsvc_sku" {
  type        = "string"
  description = "Azure App Service Plan SKU"
}
variable "az_appsvc_size" {
  type        = "string"
  description = "Azure App Service Plan Size"
}
variable "az_funcapp_runtime" {
  type        = "string"
  description = "Azure Function App Runtime"
}
variable "az_appins_type" {
  type        = "string"
  description = "Azure Application Insights Type (iOS/Java/Web and etc)"
}
variable "az_appins_enable" {
  type        = "string"
  description = "Should we enable AppIns for Azure Function App?)"
}
variable "az_stor_funcapp_tier" {
  type        = "string"
  description = "Azure Storage Tier)"
}
variable "az_stor_funcapp_repl" {
  type        = "string"
  description = "Azure Storage Replication Type)"
}

#Azure Data Explorer (kusto)
variable "az_kusto_sku" {
  type        = "string"
  description = "Azure Kusto Cluster SKU"
}
variable "az_kusto_nodes" {
  type        = "string"
  description = "Azure Kusto Cluster Nodes Count"
}

#Azure Analysis Server
variable "az_stor_ansrv_tier" {
  type        = "string"
  description = "Storage Account Tier"
}
variable "az_ansrv_sku" {
  type        = "string"
  description = "The Analysis Server SKU"
}
variable "az_stor_ansrv_repl" {
  type        = "string"
  description = "Storage Account Replication Type"
}
variable "az_ansrv_users" {
  type        = list(string)
  description = "List of email admin users to be added durint the creation"
}
variable "az_ansrv_powerbi" {
  type        = "string"
  description = "Should we allow PowerBi to access the server?"
}
variable "az_stor_ssa_start" {
  type        = "string"
  description = "The start date of the SSA token (used for BackUp storage)"
}
variable "az_stor_ssa_end" {
  type        = "string"
  description = "The expiration date of the SSA token (used for BackStorage)"
}

#Event Grid
variable "az_eventgrid_schema" {
  type        = "string"
  description = "Azure Event Grid Schema"
}

#--------------------------------------------------------
# ::: Author: https://rlevchenko.com :::
#--------------------------------------------------------

