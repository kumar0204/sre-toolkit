terraform {
  required_version = ">= 1.11.0"

#   cloud {
#   organization = "miw"

#    workspaces {
#      project = "Scout"
#      tags = {
#        layer = "grafana"
#      }
      
#    }
#  }

  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 3.24"
    }
  }
}

provider "grafana" {
  url  = var.grafana_url
#  auth = var.grafana_api_token
  auth = "${var.grafana_username}:${var.grafana_password}"
  insecure_skip_verify = true
}