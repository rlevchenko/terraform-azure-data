#-----------------------------------------------------------
# Provider Authentication : Author: https://rlevchenko.com :
#----------------------------------------------------------

variable "client_secret" {} #Variable to store SP's password
variable "client_id" {}
variable "subscr_id" {}
variable "tenant_id" {}

provider "azurerm" {
  version         = ">= 1.35.0" # (optional) provider's version
  subscription_id = var.subscr_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

#--------------------------------------------------------
# ::: Author: https://rlevchenko.com :::
#--------------------------------------------------------
