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

resource "grafana_folder" "scout" {
  title = "Scout"
}

resource "grafana_dashboard" "scout_dashboards" {
  for_each    = fileset("${path.module}/dashboards", "*.json")
  config_json = file("${path.module}/dashboards/${each.key}")
  folder      = grafana_folder.scout.id
}
