terraform {
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

resource "grafana_dashboard" "scoutoverview" {
  config_json = file("${path.module}/dashboards/Overview-1746648726141.json")
}

resource "grafana_dashboard" "scoutdrilldown" {
  config_json = file("${path.module}/dashboards/Drilldown-1746648722643.json")
}
