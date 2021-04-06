terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.51.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project}"
  location = var.location
}

resource "azurerm_cosmosdb_account" "cosmos_account" {
  name                = "cdb-${var.project}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  offer_type       = "Standard"
  kind             = "GlobalDocumentDB"
  enable_free_tier = true

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "cosmos_database" {
  name                = "db-${var.project}"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos_account.name
}

resource "azurerm_cosmosdb_sql_container" "cosmos_deparments" {
  name                = "departments"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos_account.name
  database_name       = azurerm_cosmosdb_sql_database.cosmos_database.name
}

resource "azurerm_cosmosdb_sql_container" "cosmos_cheeses" {
  name                = "cheeses"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos_account.name
  database_name       = azurerm_cosmosdb_sql_database.cosmos_database.name
}

resource "null_resource" "call_python_script" {
  provisioner "local-exec" {
    command = "pip3 install azure-cosmos; python3 ${path.module}/load-data.py --url ${azurerm_cosmosdb_account.cosmos_account.endpoint} --key ${azurerm_cosmosdb_account.cosmos_account.primary_key} --database ${azurerm_cosmosdb_sql_database.cosmos_database.name}"
  }
}

resource "azurerm_app_service_plan" "plan" {
  name                = "plan-${var.project}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  kind     = "Linux"
  reserved = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "api" {
  name                = "web-${var.project}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.plan.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    dotnet_framework_version = "v5.0"
  }
}

resource "azurerm_role_assignment" "rbac_api_cosmos" {
  scope                = azurerm_cosmosdb_account.cosmos_account.id
  role_definition_name = "Cosmos DB Account Reader Role"
  principal_id         = azurerm_app_service.api.identity.0.principal_id
}
