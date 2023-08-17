locals {
  name = var.environment == "prod" ? "${var.name}-prod" : "${var.name}-dev"
}

data "google_compute_network" "shared_vpc" {
  name    = "vpc-dev-shared"
  project = "dpgraham-vpc-host-nonprod"
}

data "google_compute_subnetwork" "shared_vpc_subnet" {
  name       = "subnet-dev-east1"
  region     = "us-east1"
  #  network    = data.google_compute_network.shared_vpc.self_link
  project    = "dpgraham-vpc-host-nonprod"
  depends_on = [data.google_compute_network.shared_vpc]
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
