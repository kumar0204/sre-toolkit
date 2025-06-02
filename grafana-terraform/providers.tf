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
      version = ">= 2.9.0"
    }
  }
}

provider "grafana" {
  url  = var.grafana_url
  auth = var.grafana_auth_token
}
