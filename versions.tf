terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    auth0 = {
      source = "auth0/auth0"
    }
  }
  required_version = ">= 0.14"
}
