locals {
  name = var.environment == "prod" ? "${var.name}-prod" : "${var.name}-dev"
}

data "google_compute_network" "shared_vpc" {
  name    = "vpc-dev-shared"
  project = "dpgraham-vpc-host-nonprod"
}

data "google_compute_subnetwork" "shared_vpc_subnet" {
  name    = "subnet-dev-east1"
  region  = "us-east1"
  project = var.host_project
}

data "google_compute_subnetwork" "shared_vpc_serverless_subnet" {
  name    = "subnet-dev-east1-serverless"
  region  = "us-east1"
  project = var.host_project
}

module "serverless_connector" {
  source  = "terraform-google-modules/network/google//modules/vpc-serverless-connector-beta"
  version = "~> 7.3"

  project_id     = var.project_id
  vpc_connectors = [
    {
      name            = "frontend-serverless"
      region          = "us-east1"
      subnet_name     = data.google_compute_subnetwork.shared_vpc_serverless_subnet.name
      host_project_id = var.host_project
      machine_type    = "e2-micro"
      min_instances   = 2
      max_instances   = 10
      max_throughput  = 1000
    }
  ]
  depends_on = [data.google_compute_subnetwork.shared_vpc_serverless_subnet]
}

module "vpc" {
  source                  = "terraform-google-modules/network/google"
  version                 = "~> 7.1"
  project_id              = var.project_id
  network_name            = local.name
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
  #  ToDo, allows creating multiple subnets
  subnets                 = [
    {
      subnet_name   = "subnet-${var.region}-1"
      subnet_ip     = "10.1.1.0/24"
      subnet_region = var.region
    }
  ]
}
