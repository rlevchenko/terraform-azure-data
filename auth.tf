#-----------------------------------------------------------
# Provider Authentication | rlevchenko.com
#----------------------------------------------------------

variable "client_secret" {} # Variable to store SP's password
variable "client_id" {}     # Application ID
variable "subscr_id" {}     # Subscription ID
variable "tenant_id" {}     # Tenant ID

provider "azurerm" {
  version         = ">= 1.35.0" # (optional) provider's version
  subscription_id = var.subscr_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}
#-----------------------------------------------------------
# Roman Levchenko | rlevchenko.com
