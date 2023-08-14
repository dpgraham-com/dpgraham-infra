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
    "sqladmin.googleapis.com"
  ]
}

module "vpc" {
  source      = "./vpc"
  environment = "dev"
}

#module "network" {
#  source      = "./modules/network"
#  project     = var.project
#  environment = "production"
#}

#module "database" {
#  source      = "../modules/sql"
#  name        = "test-database"
#  db_password = "password123"
#  db_username = "user123"
#  environment = "development"
#  vpc         = module.vpc.network
#}

resource "google_sql_database_instance" "database_instance" {
  name             = "test-database"
  database_version = "POSTGRES_14"
  region           = var.region
  project          = var.project

  settings {
    tier              = "db-f1-micro"
    activation_policy = "ALWAYS"
    availability_type = "ZONAL"
    disk_size         = 10
    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
    ip_configuration {
      #      private_network = module.vpc.network
      ipv4_enabled = true
    }
  }
}

resource "google_sql_database" "postgres" {
  name     = "test-database"
  instance = google_sql_database_instance.database_instance.name
}
