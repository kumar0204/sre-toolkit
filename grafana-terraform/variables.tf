variable "grafana_url" {
  description = "URL of the Grafana instance"
  type        = string
}

variable "grafana_auth_token" {
  description = "Service account token for Grafana authentication"
  type        = string
  sensitive   = true
}