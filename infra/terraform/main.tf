resource "azurerm_resource_group" "this" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

locals {
  effective_resource_group_name     = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
  effective_acr_resource_group_name = coalesce(var.acr_resource_group_name, local.effective_resource_group_name)
  effective_aks_resource_group_name = coalesce(var.aks_resource_group_name, local.effective_resource_group_name)
  effective_sql_location            = coalesce(var.sql_location, var.location)

  effective_acr_name         = var.create_acr ? azurerm_container_registry.this[0].name : data.azurerm_container_registry.this[0].name
  effective_acr_login_server = var.create_acr ? azurerm_container_registry.this[0].login_server : data.azurerm_container_registry.this[0].login_server
  effective_acr_id           = var.create_acr ? azurerm_container_registry.this[0].id : data.azurerm_container_registry.this[0].id
}

resource "azurerm_container_registry" "this" {
  count               = var.create_acr ? 1 : 0
  name                = var.acr_name
  resource_group_name = local.effective_acr_resource_group_name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = false
  tags                = var.tags
}

data "azurerm_container_registry" "this" {
  count               = var.create_acr ? 0 : 1
  name                = var.acr_name
  resource_group_name = local.effective_acr_resource_group_name
}

# ---------------------------------------------------------------------------
# Azure SQL Database (managed SQL Server)
# ---------------------------------------------------------------------------

resource "azurerm_mssql_server" "this" {
  count                        = var.create_sql ? 1 : 0
  name                         = var.sql_server_name
  resource_group_name          = local.effective_resource_group_name
  location                     = local.effective_sql_location
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"
  tags                         = var.tags
}

resource "azurerm_mssql_database" "this" {
  count       = var.create_sql ? 1 : 0
  name        = var.sql_database_name
  server_id   = azurerm_mssql_server.this[0].id
  sku_name    = var.sql_database_sku
  max_size_gb = var.sql_max_size_gb
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  tags        = var.tags
}

# Allow Azure services (including AKS egress) to reach the SQL server.
# The 0.0.0.0 start/end is the Azure-documented rule for "Allow Azure services".
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  count            = var.create_sql ? 1 : 0
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.this[0].id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Optional explicit IPs (e.g. your workstation for data migration).
resource "azurerm_mssql_firewall_rule" "allowed" {
  for_each         = var.create_sql ? var.sql_allowed_ip_addresses : {}
  name             = each.key
  server_id        = azurerm_mssql_server.this[0].id
  start_ip_address = each.value
  end_ip_address   = each.value
}

# ---------------------------------------------------------------------------
# Existing AKS cluster + ACR pull permission
# ---------------------------------------------------------------------------

data "azurerm_kubernetes_cluster" "this" {
  count               = var.configure_aks ? 1 : 0
  name                = var.aks_cluster_name
  resource_group_name = local.effective_aks_resource_group_name
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  count                            = var.configure_aks && var.grant_aks_acr_pull ? 1 : 0
  scope                            = local.effective_acr_id
  role_definition_name             = "AcrPull"
  principal_id                     = data.azurerm_kubernetes_cluster.this[0].kubelet_identity[0].object_id
  skip_service_principal_aad_check = true

  # The AcrPull assignment frequently already exists in Azure and is imported
  # into state before apply. Several attributes are write-only or computed by
  # Azure (skip_service_principal_aad_check is never returned by the API), which
  # produces a post-import diff. azurerm_role_assignment does not support
  # in-place updates, so ignore these attributes to avoid a failing modify.
  lifecycle {
    ignore_changes = [
      skip_service_principal_aad_check,
      principal_type,
      description,
      condition,
      condition_version,
    ]
  }
}
