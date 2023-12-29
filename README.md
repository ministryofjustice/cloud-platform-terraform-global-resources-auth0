# cloud-platform-terraform-global-resources-auth0

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-global-resources-auth0/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-global-resources-auth0/releases)

Terraform module that deploys Auth0 actions

## Usage

```
module "global_auth0" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-global-resources-auth0?ref=1.0.0"

  auth0_tenant_domain = local.auth0_tenant_domain
  auth0_groupsClaim   = local.auth0_groupsClaim
}
```

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| auth0 | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [auth0_action](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/action) |
| [auth0_client](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/client) |
| [auth0_client_grant](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/client_grant) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auth0\_groupsClaim | OIDC Group Claim domain for justice cloud-platform account | `string` | `""` | no |
| auth0\_tenant\_domain | Auth0 domain | `string` | n/a | yes |
| moj\_github\_org | MOJ Github Org | `string` | `"ministryofjustice"` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->

## Reading Material

https://auth0.com/docs/customize/actions/use-cases
https://auth0.com/docs/customize/actions/migrate/migrate-from-rules-to-actions

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_auth0"></a> [auth0](#provider\_auth0) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [auth0_action.add_github_teams_to_oidc_group_claim](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/action) | resource |
| [auth0_client.management_auth0_actions](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/client) | resource |
| [auth0_client_grant.management_grant](https://registry.terraform.io/providers/auth0/auth0/latest/docs/resources/client_grant) | resource |
| [auth0_client.management_auth0_actions](https://registry.terraform.io/providers/auth0/auth0/latest/docs/data-sources/client) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auth0_groupsClaim"></a> [auth0\_groupsClaim](#input\_auth0\_groupsClaim) | OIDC Group Claim domain for justice cloud-platform account | `string` | `""` | no |
| <a name="input_auth0_tenant_domain"></a> [auth0\_tenant\_domain](#input\_auth0\_tenant\_domain) | Auth0 domain | `string` | n/a | yes |
| <a name="input_moj_github_org"></a> [moj\_github\_org](#input\_moj\_github\_org) | MOJ Github Org | `string` | `"ministryofjustice"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->