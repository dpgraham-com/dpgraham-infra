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
  source   = "../modules/gcp-apis" # using local modules until I can these are versioned in the main branch of the repo
  project  = var.project
  services = [
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "vpcaccess.googleapis.com"
  ]
}

module "vpc" {
  source      = "./vpc"
  name        = "vpc"
  environment = "dev"
}

module "artifact_registry" {
  source = "../modules/registry" # using local modules until I can these are versioned in the main branch of the repo
  repo   = var.artifact_repo
  region = var.region
}

module "database" {
  source      = "../modules/sql" # using local modules until I can these are versioned in the main branch of the repo
  name        = var.db_name
  db_password = var.db_password
  db_username = var.db_username
  environment = "dev"
  project_id  = var.project
  vpc         = module.vpc.network
}


#resource "google_cloud_run_v2_service" "default" {
#  name     = "server"
#  location = var.region
#  lifecycle {
#    ignore_changes = [template, client, client_version, labels]
#  }
#
#  template {
#    containers {
#      ports {
#        container_port = "8080"
#      }
#      #      image = var.image
#      image = format("%s-docker.pkg.dev/%s/%s/%s:test", module.artifact_registry.location, var.project, module.artifact_registry.id, var.server_image_name)
#      env {
#        name  = "DB_PORT"
#        value = "5432"
#      }
#      env {
#        name  = "DB_NAME"
#        value = module.database.db_name
#      }
#      env {
#        name  = "DB_USER"
#        value = module.database.db_user
#      }
#      env {
#        name  = "DB_PASSWORD"
#        value = module.database.db_password
#      }
#      env {
#        name  = "DB_HOST"
#        value = module.database.db_host
#      }
#    }
#    scaling {
#      max_instance_count = 3
#    }
#  }
#}


#module "server-service" {
#  source        = "../modules/cloud-run"
#  name          = "server"
#  image         = format("%s-docker.pkg.dev/%s/%s/%s:test", module.artifact_registry.location, var.project, module.artifact_registry.id, var.server_image_name)
#  vpc_connector = module.database.vpc_connector
#  port          = "8080"
#  environment   = "dev"
#  env           = [
#    {
#      name  = "DB_PORT"
#      value = "5432"
#    },
#    {
#      name  = "DB_NAME"
#      value = module.database.db_name
#    },
#    {
#      name  = "DB_USER"
#      value = module.database.db_user
#    },
#    {
#      name  = "DB_PASSWORD"
#      value = module.database.db_password
#    },
#    {
#      name  = "DB_HOST"
#      value = module.database.db_host
#    }
#  ]
#}
