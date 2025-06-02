resource "grafana_folder" "scout" {
  title = "Scout"
}

resource "grafana_dashboard" "scout_dashboards" {
  for_each    = fileset("${path.module}/dashboards", "*.json")
  config_json = file("${path.module}/dashboards/${each.key}")
  folder      = grafana_folder.scout.id
}
