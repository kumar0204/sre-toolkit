variable "grafana_url" {
  description = "URL of the Grafana instance"
  type        = string
}
/*
variable "grafana_api_token" {
  description = "Grafana API token"
  type        = string
  sensitive   = true
}
*/
variable "azuread_client_id" {
  description = "Azure AD Application (client) ID"
  type        = string
}

variable "azuread_client_secret" {
  description = "Azure AD client secret"
  type        = string
  sensitive   = true
}

variable "azuread_tenant_id" {
  description = "Azure AD Tenant ID"
  type        = string
}

variable "azuread_group_object_id" {
  description = "Azure AD Group Object ID"
  type        = string
}
/*
variable "grafana_team_name" {
  description = "Name of the Grafana team to create and sync"
  type        = string
}
*/

variable "grafana_username" {
  description = "Username for Grafana basic authentication"
  type        = string
  default     = "admin"
}

variable "grafana_password" {
  description = "password for Grafana basic authentication"
  type        = string
  
}