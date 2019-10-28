#--------------------------------------------------------------
# Deployment output  ::: Author: https://rlevchenko.com :::
#--------------------------------------------------------------

#Service Bus

output "servicebus_namespace_id" {
  value = "${azurerm_servicebus_namespace.da-svc-svb.default_primary_connection_string}"
}

#Kusto Cluster
output "kusto_cluster-uri" {
  value = "${azurerm_kusto_cluster.da-svc-kusto.data_ingestion_uri}"
}

#Analysis Server
output "analysis_server_fqdn" {
  value = "${azurerm_analysis_services_server.da-svc-ansrv.server_full_name}"
}

#Event Grid
output "event_grid_endpoint" {
  value = "${azurerm_eventgrid_domain.da-svc-eventgrid.endpoint}"
}

#--------------------------------------------------------
# ::: Author: https://rlevchenko.com :::
#--------------------------------------------------------
