# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "app-service" {
  source  = "hashicorp/azurerm"
  version = ">= 2.0.0"
  resource_group_name = "rg-shared-westeurope-01"

service_plan = {
    kind = "Windows"
    size = "P1v2"
    tier = "PremiumV2"
  }
  # Backup, connection_string, auth_settings, Storage for mounts are optional configuration
  app_service_name       = "myapp-poc-project"
  enable_client_affinity = true

  site_config = {
    always_on                 = true
    dotnet_framework_version  = "v2.0"
    ftps_state                = "FtpsOnly"
    managed_pipeline_mode     = "Integrated"
    use_32_bit_worker_process = true
    windows_fx_version        = "DOTNETCORE|2.1"
  }

  # (Optional) A key-value pair of Application Settings
  app_settings = {
    APPINSIGHTS_PROFILERFEATURE_VERSION             = "1.0.0"
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION             = "1.0.0"
    DiagnosticServices_EXTENSION_VERSION            = "~3"
    InstrumentationEngine_EXTENSION_VERSION         = "disabled"
    SnapshotDebugger_EXTENSION_VERSION              = "disabled"
    XDT_MicrosoftApplicationInsights_BaseExtensions = "disabled"
    XDT_MicrosoftApplicationInsights_Java           = "1"
    XDT_MicrosoftApplicationInsights_Mode           = "recommended"
    XDT_MicrosoftApplicationInsights_NodeJS         = "1"
    XDT_MicrosoftApplicationInsights_PreemptSdk     = "disabled"
  }

  # Azure storage account and container in the same subscription as the app that you want to back up. 
  # This module creates a Storage Container to keep the all backup items. 
  # Backup items - App configuration , File content, Database connected to your app
  enable_backup        = true
  storage_account_name = "stdiagfortesting1"
  backup_settings = {
    enabled                  = true
    name                     = "DefaultBackup"
    frequency_interval       = 1
    frequency_unit           = "Day"
    retention_period_in_days = 90
  }
 
  app_insights_name = "otkpocshared"

  # Adding TAG's to your Azure resources 
  tags = {
    ProjectName  = "demo-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}
