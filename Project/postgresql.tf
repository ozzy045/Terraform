resource "azurerm_postgresql_server" "postgresql" {
  name                = "postgres-terraform-project"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  sku_name   = "GP_Gen5_4"
  version    = "11"
  storage_mb = 640000

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = true
  ssl_enforcement_enabled          = false
}
resource "azurerm_postgresql_firewall_rule" "postgres_rules" {
  name                = "office"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgresql.name
  start_ip_address    = "20.50.57.130"
  end_ip_address      = "20.50.57.130"
}
resource "azurerm_postgresql_database" "database" {
  name                = "postgres-terraform-project"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_server.postgresql.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}