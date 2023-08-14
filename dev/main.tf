terraform {
  backend "gcs" {
    bucket = "tf-state-dpgraham-cs-host-a129ed3bccf04a1abf8760"
    prefix = "terraform/dev"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = "us-east1-b"
}

module "apis" {
  source   = "../modules/gcp-apis"
  project  = var.project
  services = [
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "artifactregistry.googleapis.com"
  ]
}

module "vpc" {
  source      = "./vpc"
  name        = "vpc"
  environment = "dev"
}

module "database" {
  source      = "../modules/sql"
  name        = var.db_name
  db_password = var.db_password
  db_username = var.db_username
  environment = "dev"
  project_id  = var.project
  vpc         = module.vpc.network
}

module "artifact_registry" {
  source = "../modules/registry"
  repo   = var.artifact_repo
  region = var.region
}

