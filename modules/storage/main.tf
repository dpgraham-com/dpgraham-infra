locals {
  versioning        = var.environment == "prod" ? true : false
  asset_path_prefix = "assets/"
}

resource "random_uuid" "storage_uuid" {}

resource "google_storage_bucket" "default" {
  name                        = "${var.bucket_name}-${random_uuid.storage_uuid.result}"
  location                    = var.location
  project                     = var.project_id
  uniform_bucket_level_access = false

  versioning {
    enabled = local.versioning
  }
}

resource "google_storage_default_object_access_control" "public_access" {
  bucket = google_storage_bucket.default.name
  role   = "READER"
  entity = "allUsers"
}

resource "google_storage_bucket_object" "resume" {
  bucket = google_storage_bucket.default.name
  name   = "${local.asset_path_prefix}resume/DavidGrahamResume.pdf"
  source = var.resume_path
}

