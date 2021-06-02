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
  partition_key_path  = "/id"
}

resource "azurerm_cosmosdb_sql_container" "cosmos_cheeses" {
  name                = "cheeses"
  resource_group_name = azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.cosmos_account.name
  database_name       = azurerm_cosmosdb_sql_database.cosmos_database.name
  partition_key_path  = "/id"
}

resource "null_resource" "call_python_script" {
  depends_on = [
    azurerm_cosmosdb_sql_container.cosmos_deparments,
    azurerm_cosmosdb_sql_container.cosmos_cheeses
  ]

  provisioner "local-exec" {
    command = "pip3 install azure-cosmos;pip3 install unidecode; python3 ${path.module}/load-data.py --url ${azurerm_cosmosdb_account.cosmos_account.endpoint} --key ${azurerm_cosmosdb_account.cosmos_account.primary_key} --database ${azurerm_cosmosdb_sql_database.cosmos_database.name}"
  }
}
