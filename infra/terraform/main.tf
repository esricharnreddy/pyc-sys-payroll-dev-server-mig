resource "azurerm_resource_group" "this" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

locals {
  effective_resource_group_name     = var.create_resource_group ? azurerm_resource_group.this[0].name : var.resource_group_name
  effective_acr_resource_group_name = coalesce(var.acr_resource_group_name, local.effective_resource_group_name)

  effective_acr_name         = var.create_acr ? azurerm_container_registry.this[0].name : data.azurerm_container_registry.this[0].name
  effective_acr_login_server = var.create_acr ? azurerm_container_registry.this[0].login_server : data.azurerm_container_registry.this[0].login_server
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
