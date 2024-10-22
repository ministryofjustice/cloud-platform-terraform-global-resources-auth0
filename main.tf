provider "auth0" {
  domain = var.auth0_tenant_domain
}

resource "auth0_client" "management_auth0_actions" {
  name              = "management:auth0-actions"
  description       = "Cloud Platform machine to machine application to manage Auth0 actions"
  logo_uri          = "https://ministryofjustice.github.io/assets/moj-crest.png"
  app_type          = "non_interactive"
  cross_origin_auth = true

  custom_login_page_on = true
  is_first_party       = true
  oidc_conformant      = true
  sso                  = true
  grant_types          = ["client_credentials"]


  jwt_configuration {
    alg                 = "RS256"
    lifetime_in_seconds = "36000"
  }
}

resource "auth0_client_grant" "management_grant" {
  client_id = auth0_client.management_auth0_actions.id
  audience  = "https://${var.auth0_tenant_domain}/api/v2/"
  scopes    = ["read:user_idp_tokens"]
}

# Get client secret
data "auth0_client" "management_auth0_actions" {
  client_id = auth0_client.management_auth0_actions.client_id
}

resource "auth0_action" "add_github_teams_to_oidc_group_claim" {
  name    = "add-github-teams-to-oidc-group-claim"
  runtime = "node18"
  deploy  = true
  code    = file("${path.module}/resources/auth0-actions/action-add-github-teams-to-oidc-group-claim.js")

  supported_triggers {
    id      = "post-login"
    version = "v3"
  }

  secrets {
    name  = "AUTH0_TENANT_DOMAIN"
    value = var.auth0_tenant_domain
  }

  secrets {
    name  = "AUTH0_GROUPS_CLAIM"
    value = var.auth0_groupsClaim
  }

  secrets {
    name  = "MOJ_ORG"
    value = var.moj_github_org
  }

  secrets {
    name  = "MGMT_ID"
    value = auth0_client.management_auth0_actions.client_id
  }

  secrets {
    name  = "MGMT_SECRET"
    value = data.auth0_client.management_auth0_actions.client_secret
  }
}

resource "auth0_action" "allow-gh-orgs" {
  name = "add-github-moj-orgs"
  code = file(
    "${path.module}/resources/auth0-actions/allow-github-orgs.js",
  )
  deploy  = true
  runtime = "node18"

  supported_triggers {
    id      = "post-login"
    version = "v3"
  }
}
