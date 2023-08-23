locals {
  env_suffix   = var.environment == "prod" ? "" : "-dev"
  cloud_run_sa = var.environment == "prod" ? var.cloud_run_sa : "${var.cloud_run_sa}${local.env_suffix}"
}

module "service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 3.0"

  project_id    = var.project_id
  names         = ["${var.cloud_run_sa}${local.env_suffix}"]
  display_name  = "Cloud Run and GAR"
  project_roles = [
    "${var.project_id}=>roles/run.developer",
    "${var.project_id}=>roles/artifactregistry.writer",
    "${var.project_id}=>roles/iam.workloadIdentityUser"
  ]
}

module "gh_oidc" {
  source  = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version = "3.1.1"

  project_id       = var.project_id
  pool_id          = var.pool_id
  provider_id      = "github"
  pool_description = "A pool of identities to be used by GitHub Actions workflow runners"
  sa_mapping       = {
    "devops_service_account" = {
      sa_name   = "projects/${var.project_id}/serviceAccounts/${var.cloud_infra_sa}@${var.project_id}.iam.gserviceaccount.com"
      attribute = "attribute.repository/${var.github_org}/dpgraham-infra"
    }
    "cloud_run_service_account" = {
      sa_name   = "projects/${var.project_id}/serviceAccounts/${local.cloud_run_sa}@${var.project_id}.iam.gserviceaccount.com"
      attribute = "attribute.repository/${var.github_org}/dpgraham-client"
    }
    "cloud_run_service_account" = {
      sa_name   = "projects/${var.project_id}/serviceAccounts/${local.cloud_run_sa}@${var.project_id}.iam.gserviceaccount.com"
      attribute = "attribute.repository/${var.github_org}/dpgraham-server"
    }
  }
}
