# Terraform v1.5.4

locals {
  vpc_name             = var.environment == "production" ? "${var.project}-vpc-prod" : "${var.project}-vpc-dev"
  database_subnet_name = var.environment == "production" ? "${var.project}-database-subnet-prod" : "${var.project}-database-subnet-dev"
}

# enable API for serverless VPC access.
resource "google_project_service" "vpc_access_api" {
  project = var.project
  service = "vpcaccess.googleapis.com"
}

resource "google_compute_subnetwork" "database_subnet" {
  ip_cidr_range = "10.10.0.0/16"
  name          = local.database_subnet_name
  network       = module.vpc.network_id
  region        = var.region
}

module "vpc" {
  source                  = "terraform-google-modules/network/google"
  version                 = "~> 7.1"
  project_id              = var.project
  network_name            = local.vpc_name
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
  subnets                 = var.subnets
}