locals {
  versioning = var.environment == "prod" ? true : false
}

resource "google_storage_bucket" "default" {
  name                        = var.bucket_name
  location                    = var.location
  project                     = var.project_id
  uniform_bucket_level_access = true

  versioning {
    enabled = local.versioning
  }
}