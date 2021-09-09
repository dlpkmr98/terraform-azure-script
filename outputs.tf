#get function app name and host name
output "function_app_name" {
  value = azurerm_function_app.afa.name
  description = "Deployed function app name"
}

output "function_app_default_hostname" {
  value = azurerm_function_app.afa.default_hostname
  description = "Deployed function app hostname"
}

#output "instrumentation_key" {
 #value = azurerm_application_insights.aai.instrumentation_key
#}

output "app_id" {
  value = azurerm_application_insights.aai.app_id
}