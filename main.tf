provider "auth0" {
  domain = var.auth0_tenant_domain
}

resource "auth0_client" "management_auth0_actions" {
  name        = "management:auth0-actions"
  description = "Cloud Platform machine to machine application to manage Auth0 actions"
  logo_uri    = "https://ministryofjustice.github.io/assets/moj-crest.png"
  app_type    = "non_interactive"

  custom_login_page_on = true
  is_first_party       = true
  oidc_conformant      = true
  sso                  = true
  grant_types = [ "client_credentials" ]
  

  jwt_configuration {
    alg                 = "RS256"
    lifetime_in_seconds = "36000"
  }
}

resource "auth0_client_grant" "management_grant" {
  client_id = auth0_client.management_auth0_actions.id
  audience  = "https://${var.auth0_tenant_domain}/api/v2/"
  scope     = ["read:user_idp_tokens"]
}

resource "auth0_action" "add_github_teams_to_oidc_group_claim" {
    name = "add-github-teams-to-oidc-group-claim"
    supported_triggers {
        id = "post-login"
        version = "v3"
    }
    runtime = "node16"
    code = templatefile("${path.module}/resources/auth0-rules/action-add-github-teams-to-oidc-group-claim.js.tpl", {
      auth0_tenant_domain = var.auth0_tenant_domain
      auth0_groupsClaim   = var.auth0_groupsClaim
      moj_github_org      = var.moj_github_org
    })
    secrets {
        name  = "MGMT_ID"
        value = auth0_client.management_auth0_actions.client_id
    }
    secrets {
        name  = "MGMT_SECRET"
        value = auth0_client.management_auth0_actions.client_secret
    }

    deploy = true
}