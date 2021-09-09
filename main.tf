/*
@author - Dilip
This script used to create following services in azure...
-- Create resource group
-- Create Storage Account - Type blob
-- Create Container
-- Create Queue
-- Create Application insights
-- Create App Service Plan
-- Create Function App
*/

#local variable declaration
locals {
  region = "Central India" 
  tag_value = var.environment   
}


provider "azurerm" {
  features {}
}

#create resource group
resource "azurerm_resource_group" "arg" {
  name     = var.rg_name
  location = local.region
  tags = {
      environment = local.tag_value
  }
}

#create storage account
resource "azurerm_storage_account" "asa" {
  name                     = var.blob_storage_account_name
  resource_group_name      = azurerm_resource_group.arg.name
  location                 = azurerm_resource_group.arg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = local.tag_value
  }
}

#create container - 
resource "azurerm_storage_container" "asc" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.asa.name
  container_access_type = "private"
}

#create queue
resource "azurerm_storage_queue" "aqueue" {
  name                 = var.storage_queue_name
  storage_account_name = azurerm_storage_account.asa.name
}


#create applicatiton insights
resource "azurerm_application_insights" "aai" {
  name                = var.application_insights_name
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name
  application_type    = "web"
}

#create app service plan
resource "azurerm_app_service_plan" "aasp" {
  name                = var.app_plan_name
  location            = azurerm_resource_group.arg.location
  resource_group_name = azurerm_resource_group.arg.name
  kind = "FunctionApp"
  reserved = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

#create function app with applicaion insights
resource "azurerm_function_app" "afa" {
  name                       = var.function_app_name
  location                   = azurerm_resource_group.arg.location
  resource_group_name        = azurerm_resource_group.arg.name
  app_service_plan_id        = azurerm_app_service_plan.aasp.id
  storage_account_name       = azurerm_storage_account.asa.name
  storage_account_access_key = azurerm_storage_account.asa.primary_access_key
  os_type                    = "linux" 
  version                    = "~3"
  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY = "${azurerm_application_insights.aai.instrumentation_key}"
    FUNCTIONS_WORKER_RUNTIME = "python"
  }
  site_config {
    linux_fx_version = "PYTHON|3.9"
    use_32_bit_worker_process = false
  }
  
}

