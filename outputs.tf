#--------------------------------------------------------------
# Deployment output  
#--------------------------------------------------------------

#Service Bus
output "servicebus_namespace_id" {
  value     = azurerm_servicebus_namespace.rlmvp-svc-svb.*.default_primary_connection_string
  sensitive = true
}

#Kusto Cluster
output "kusto_cluster-uri" {
  value = azurerm_kusto_cluster.rlmvp-svc-kusto.*.data_ingestion_uri
}

#Analysis Server
output "analysis_server_fqdn" {
  value = azurerm_analysis_services_server.rlmvp-svc-ansrv.*.server_full_name
}

#Event Grid
output "event_grid_endpoint" {
  value = azurerm_eventgrid_domain.rlmvp-svc-eventgrid.*.endpoint
}

#-----------------------------------------------------------
# Roman Levchenko | rlevchenko.com
