variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name to create or reuse."
  type        = string
}

variable "create_resource_group" {
  description = "Whether Terraform should create the resource group."
  type        = bool
  default     = false
}

variable "acr_name" {
  description = "Azure Container Registry name (5-50 lowercase alphanumeric)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{5,50}$", var.acr_name))
    error_message = "acr_name must be 5-50 characters and lowercase alphanumeric only."
  }
}

variable "create_acr" {
  description = "Whether Terraform should create the Azure Container Registry. When false, Terraform looks up an existing ACR."
  type        = bool
  default     = true
}

variable "acr_resource_group_name" {
  description = "Resource group that owns the ACR. Defaults to resource_group_name when not provided."
  type        = string
  default     = null
}

variable "acr_sku" {
  description = "ACR SKU. Typical values: Basic, Standard, Premium."
  type        = string
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "acr_sku must be Basic, Standard, or Premium."
  }
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------------------------
# Azure SQL Database
# ---------------------------------------------------------------------------

variable "create_sql" {
  description = "Whether Terraform should create the Azure SQL server and database. Defaults to false so existing pipelines stay green until configured."
  type        = bool
  default     = false
}

variable "sql_server_name" {
  description = "Globally-unique Azure SQL logical server name (lowercase alphanumeric and hyphens). Required only when create_sql = true."
  type        = string
  default     = ""
}

variable "sql_location" {
  description = "Azure region for the SQL logical server. Defaults to location when not provided."
  type        = string
  default     = null
}

variable "sql_database_name" {
  description = "Azure SQL database name."
  type        = string
  default     = "PayrollDB"
}

variable "sql_admin_username" {
  description = "Azure SQL administrator login. Required only when create_sql = true."
  type        = string
  default     = ""
}

variable "sql_admin_password" {
  description = "Azure SQL administrator password. Provide via TF_VAR_sql_admin_password / pipeline secret. Required only when create_sql = true."
  type        = string
  sensitive   = true
  default     = ""
}

variable "sql_database_sku" {
  description = "Azure SQL database SKU (e.g. Basic, S0, S1)."
  type        = string
  default     = "Basic"
}

variable "sql_max_size_gb" {
  description = "Maximum database size in GB."
  type        = number
  default     = 2
}

variable "sql_allowed_ip_addresses" {
  description = "Map of name => IP address allowed through the SQL firewall (e.g. your machine for data migration)."
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------------------------
# Existing AKS cluster (data source) + ACR pull
# ---------------------------------------------------------------------------

variable "configure_aks" {
  description = "Whether to look up the existing AKS cluster and grant it AcrPull on the ACR. Defaults to false."
  type        = bool
  default     = false
}

variable "aks_cluster_name" {
  description = "Name of the existing AKS cluster. Required only when configure_aks = true."
  type        = string
  default     = ""
}

variable "aks_resource_group_name" {
  description = "Resource group that owns the existing AKS cluster. Defaults to resource_group_name when not provided."
  type        = string
  default     = null
}

variable "grant_aks_acr_pull" {
  description = "Whether to grant the AKS kubelet identity AcrPull on the ACR."
  type        = bool
  default     = true
}
