terraform {
  backend "gcs" {
    bucket = "tf-state-dpgraham-cs-host-a129ed3bccf04a1abf8760"
    prefix = "terraform/dev"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.78.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = "us-east1-b"
}

module "apis" {
  source  = "../modules/gcp-apis" # using local modules until I can these are versioned in the main branch of the repo
  project = var.project
  services = [
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "vpcaccess.googleapis.com"
  ]
}

module "vpc" {
  source       = "./vpc"
  name         = "vpc"
  environment  = "dev"
  host_project = var.host_project
}

module "client_artifact_repo" {
  source = "../modules/registry" # using local modules until I can these are versioned in the main branch of the repo
  repo   = "client"
  region = var.region
}

module "server_artifact_repo" {
  source = "../modules/registry" # using local modules until I can these are versioned in the main branch of the repo
  repo   = "server"
  region = var.region
}

module "database" {
  source      = "../modules/sql" # using local modules until I can these are versioned in the main branch of the repo
  name        = var.db_name
  db_password = var.db_password
  db_username = var.db_username
  environment = "dev"
  project_id  = var.project
  vpc         = module.vpc.shared_vpc
}


module "frontend-service" {
  source = "../modules/cloud-run"
  name   = "frontend"
  image  = format("%s-docker.pkg.dev/%s/%s/%s:test", module.client_artifact_repo.location, var.project, module.client_artifact_repo.name, var.client_image_name)
  #  image         = "us-east1-docker.pkg.dev/dpgraham-com-dev/client/dpgraham-client:test"
  vpc_connector = module.vpc.serverless_vpc_connector
  port          = "3000"
  environment   = "dev"
  depends_on    = [module.vpc.serverless_vpc_connector]
}

module "server-service" {
  source        = "../modules/cloud-run"
  name          = "server"
  image         = format("%s-docker.pkg.dev/%s/%s/%s:latest", module.server_artifact_repo.location, var.project, module.server_artifact_repo.name, var.server_image_name)
  vpc_connector = module.vpc.serverless_vpc_connector
  port          = "8080"
  environment   = "dev"
  env = [
    {
      name  = "DB_PORT"
      value = "5432"
    },
    {
      name  = "DB_NAME"
      value = module.database.db_name
    },
    {
      name  = "DB_USER"
      value = module.database.db_user
    },
    {
      name  = "DB_PASSWORD"
      value = module.database.db_password
    },
    {
      name  = "DB_HOST"
      value = module.database.db_host
    }
  ]
}
