# cloud-platform-terraform-global-resources-auth0

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-global-resources-auth0/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-global-resources-auth0/releases)

Terraform module that deploys Auth0 actions

## Usage

```
module "global_auth0" {
  source = "github.com/ministryofjustice/ccloud-platform-terraform-global-resources-auth0=1.0.0"

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
| aws | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) |
| [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) |

## Inputs

No input.

## Outputs

No output.

<!--- END_TF_DOCS --->

## Reading Material

https://auth0.com/docs/customize/actions/use-cases
https://auth0.com/docs/customize/actions/migrate/migrate-from-rules-to-actions
