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
