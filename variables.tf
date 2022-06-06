
variable "auth0_tenant_domain" {
  description = "Auth0 domain"
  type        = string
}

variable "auth0_groupsClaim" {
  description = "OIDC Group Claim domain for justice cloud-platform account"
  default     = ""
}

variable "moj_github_org" {
  description = "MOJ Github Org"
  default     = "ministryofjustice"
}
