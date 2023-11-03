locals {
  env_suffix   = var.environment == "prod" ? "" : "-dev"
  cloud_run_sa = var.environment == "prod" ? var.cloud_run_sa : "${var.cloud_run_sa}${local.env_suffix}"
}

data "google_service_account" "cloud_infra_sa" {
  account_id = "infra-deployer-dev@dpgraham-com-dev.iam.gserviceaccount.com"
}

resource "google_service_account" "cloud_run_sa" {
  project    = var.project_id
  account_id = "${var.cloud_run_sa}${local.env_suffix}"
}


resource "google_project_iam_member" "run_developer" {
  project = var.project_id
  role    = "roles/run.developer"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

resource "google_project_iam_member" "gar_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}


resource "google_project_iam_member" "iam_workload_identity_user" {
  project = var.project_id
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}


module "gh_oidc" {
  source  = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version = "3.1.2"

  project_id       = var.project_id
  pool_id          = var.pool_id
  provider_id      = "github"
  pool_description = "A pool of identities to be used by GitHub Actions workflow runners"
  sa_mapping = {
    "cloud_run_service_account" = {
      sa_name   = google_service_account.cloud_run_sa.name
      attribute = "attribute.repository/${var.github_org}/dpgraham-client"
    }
    "infra_editor_service_account" = {
      sa_name   = data.google_service_account.cloud_infra_sa.name
      attribute = "attribute.repository/${var.github_org}/dpgraham-infra"
    }
  }
  depends_on = [
    google_service_account.cloud_run_sa,
    data.google_service_account.cloud_infra_sa,
  ]
}
