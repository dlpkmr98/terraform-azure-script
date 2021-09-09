variable "environment" {
  type = string
  description = "Environment (dev / stage / prod)"
}

variable "rg_name" {
  type = string
  description = "Azure resource group name"
}

variable "blob_storage_account_name" {
  type = string
  description = "Blob storage account name"
}

variable "storage_container_name" {
  type = string  
}

variable "storage_queue_name" {
  type = string  
}

variable "application_insights_name" {
  type = string  
}

variable "app_plan_name" {
  type = string  
}

variable "function_app_name" {
  type = string  
}