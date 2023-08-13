# terraform module for setting up a GCP Artifact Registry repository

resource "google_artifact_registry_repository" "gar" {
  location      = var.region
  repository_id = var.repo
  description   = "Repository for dpgraham.com"
  format        = "DOCKER"
}
