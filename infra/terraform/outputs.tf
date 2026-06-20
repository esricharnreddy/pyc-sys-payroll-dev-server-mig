output "resource_group_name" {
  description = "Resource group used for deployment."
  value       = local.effective_resource_group_name
}

output "acr_name" {
  description = "Azure Container Registry name."
  value       = local.effective_acr_name
}

output "acr_login_server" {
  description = "ACR login server used for docker login and push."
  value       = local.effective_acr_login_server
}

output "sql_server_fqdn" {
  description = "Fully-qualified domain name of the Azure SQL logical server."
  value       = var.create_sql ? azurerm_mssql_server.this[0].fully_qualified_domain_name : null
}

output "sql_database_name" {
  description = "Azure SQL database name."
  value       = var.create_sql ? azurerm_mssql_database.this[0].name : null
}

output "aks_cluster_name" {
  description = "Name of the existing AKS cluster targeted for deployment."
  value       = var.configure_aks ? data.azurerm_kubernetes_cluster.this[0].name : null
}

output "aks_resource_group_name" {
  description = "Resource group of the existing AKS cluster."
  value       = var.configure_aks ? local.effective_aks_resource_group_name : null
}
