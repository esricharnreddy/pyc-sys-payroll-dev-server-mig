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
