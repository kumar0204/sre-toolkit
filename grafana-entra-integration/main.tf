resource "grafana_sso_settings" "azuread" {
  provider_name = "azuread"

  oauth2_settings {
    name                  = "Azure AD"
    auth_url              = "https://login.microsoftonline.com/${var.azuread_tenant_id}/oauth2/v2.0/authorize"
    token_url             = "https://login.microsoftonline.com/${var.azuread_tenant_id}/oauth2/v2.0/token"
    client_id             = var.azuread_client_id
    client_secret         = var.azuread_client_secret
    scopes                = "openid email profile"
    allow_sign_up         = true
    auto_login            = false
    allowed_organizations = var.azuread_tenant_id
    use_pkce              = true
  }
}
/*
resource "grafana_team" "synced_team" {
  name = var.grafana_team_name
}

resource "grafana_team_external_group" "sync_groups" {
  team_id = grafana_team.synced_team.id
  groups = [var.azuread_group_object_id]
}
*/