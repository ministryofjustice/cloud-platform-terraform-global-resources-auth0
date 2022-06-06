provider "aws" {
  region  = "eu-west-2"
  profile = "moj-cp"
}

module "global_auth0" {
  source = "../"

  auth0_tenant_domain = "test.eu.auth0.com"
  auth0_groupsClaim   = "test.eu.auth0.com/groups"
}
