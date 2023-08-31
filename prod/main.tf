terraform {
  backend "gcs" {
    bucket = "tf-state-dpgraham-cs-host-a129ed3bccf04a1abf8760"
    prefix = "terraform/prod"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.78.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = "us-east1-b"
}

# Enable Google APIs
# API managed outside of terraform include
# compute.googleapis.com
# storage-component.googleapis.com
# go to https://console.cloud.google.com/apis/dashboard to see the full list of enabled APIs
module "apis" {
  source  = "../modules/gcp-apis" # using local modules until I can these are versioned in the main branch of the repo
  project = var.project_id
  services = [
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
    "vpcaccess.googleapis.com",
    "iamcredentials.googleapis.com"
  ]
}

module "vpc" {
  source          = "./vpc"
  name            = "vpc"
  environment     = var.environment
  host_project    = var.host_project
  shared_vpc_name = "vpc-prod-shared"
  depends_on      = [module.apis]
  project_id      = var.project_id
}

module "iam" {
  source         = "./iam"
  project_id     = var.project_id
  environment    = var.environment
  cloud_run_sa   = var.cloud_run_sa
  cloud_infra_sa = var.cloud_infra_sa
  github_org     = var.github_org
  pool_id        = "github-actions"
  depends_on     = [module.apis]
}

module "client_artifact_repo" {
  source = "../modules/registry"
  # using local modules until I can these are versioned in the main branch of the repo
  repo       = "client"
  region     = var.region
  depends_on = [module.apis]
}

module "server_artifact_repo" {
  source = "../modules/registry"
  # using local modules until I can these are versioned in the main branch of the repo
  repo       = "server"
  region     = var.region
  depends_on = [module.apis]
}

module "database" {
  source      = "../modules/sql" # using local modules until I can these are versioned in the main branch of the repo
  name        = var.db_name
  db_password = var.db_password
  db_username = var.db_username
  environment = var.environment
  project_id  = var.project_id
  vpc         = module.vpc.network
  #  vpc         = module.vpc.shared_vpc # uncomment if using shared vpc
  depends_on = [module.apis]
}

module "frontend-service" {
  source         = "../modules/cloud-run"
  name           = "client"
  image          = format("%s-docker.pkg.dev/%s/%s/%s:latest", module.client_artifact_repo.location, var.project_id, module.client_artifact_repo.name, var.client_image_name)
  vpc            = module.vpc.network
  port           = "3000"
  environment    = var.environment
  connector_cidr = "10.9.0.0/28"
  project        = var.project_id
  env = [
    {
      name  = "VITE_API_URL"
      value = "https://${var.domain}/api"
    }
  ]
}

module "server-service" {
  source = "../modules/cloud-run"

  project        = var.project_id
  connector_cidr = "10.8.0.0/28"
  name           = "server"
  image          = format("%s-docker.pkg.dev/%s/%s/%s:latest", module.server_artifact_repo.location, var.project_id, module.server_artifact_repo.name, var.server_image_name)
  vpc            = module.vpc.network
  port           = "8080"
  environment    = var.environment
  depends_on     = [module.apis, module.database]
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
      name  = "HOST"
      value = "0.0.0.0"
    },
    {
      name  = "DB_HOST"
      value = module.database.db_host
    }
  ]
}

module "load_balancer" {
  source           = "../modules/global-lb"
  name             = "${var.project_id}-lb"
  backend_service  = module.server-service.name
  frontend_service = module.frontend-service.name
  environment      = var.environment
  project_id       = var.project_id
  domain_name      = var.domain
}
