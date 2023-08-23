locals {
  env_suffix = var.environment == "prod" ? "" : "-dev"
}

module "service_accounts" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "~> 3.0"

  project_id    = var.project_id
  names         = ["cloud-run${local.env_suffix}"]
  project_roles = [
    "${var.project_id}=>roles/run.developer",
    "${var.project_id}=>roles/artifactregistry.writer",
  ]
}