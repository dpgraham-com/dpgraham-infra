# network.tf
# configuration for the dpgraham.com organization level network topology
# This document was originally created with the organization setup checklist

# Try to adhere to the following naming conventions recommended by Google:
# https://cloud.google.com/architecture/best-practices-vpc-design#naming
module "vpc-prod-shared" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id   = module.dpgraham-vpc-host-prod.project_id
  network_name = "vpc-prod-shared"

  subnets = []

  firewall_rules = [
    {
      name      = "vpc-prod-shared-allow-icmp"
      direction = "INGRESS"
      priority  = 10000

      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }

      allow = [
        {
          protocol = "icmp"
          ports    = []
        }
      ]

      ranges = [
        "10.128.0.0/9",
      ]
    },
    {
      name      = "vpc-prod-shared-allow-ssh"
      direction = "INGRESS"
      priority  = 10000

      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }

      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]

      ranges = [
        "35.235.240.0/20",
      ]
    },
    {
      name      = "vpc-prod-shared-allow-rdp"
      direction = "INGRESS"
      priority  = 10000

      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }

      allow = [
        {
          protocol = "tcp"
          ports    = ["3389"]
        }
      ]

      ranges = [
        "35.235.240.0/20",
      ]
    },
  ]
}

## Prod shared VPC subnets
# naming syntax: {company-name}-{description-label}-{region/zone-label}
resource "google_compute_subnetwork" "subnet-prod-east1" {
  project                  = module.dpgraham-vpc-host-prod.project_id
  region                   = "us-east1"
  ip_cidr_range            = "10.10.0.0/16"
  name                     = "subnet-prod-east1"
  network                  = module.vpc-prod-shared.network_id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnet-prod-central1" {
  project                  = module.dpgraham-vpc-host-prod.project_id
  region                   = "us-central1"
  ip_cidr_range            = "10.11.0.0/16"
  name                     = "subnet-prod-central1"
  network                  = module.vpc-prod-shared.network_id
  private_ip_google_access = true
}


# Development and non-prod organization level shared VPC
module "vpc-dev-shared" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id   = module.dpgraham-vpc-host-nonprod.project_id
  network_name = "vpc-dev-shared"

  subnets = [
  ]

  firewall_rules = [
    {
      name      = "vpc-dev-shared-allow-icmp"
      direction = "INGRESS"
      priority  = 10000

      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }

      allow = [
        {
          protocol = "icmp"
          ports    = []
        }
      ]

      ranges = [
        "10.128.0.0/9",
      ]
    },
    {
      name      = "vpc-dev-shared-allow-ssh"
      direction = "INGRESS"
      priority  = 10000

      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }

      allow = [
        {
          protocol = "tcp"
          ports    = ["22"]
        }
      ]

      ranges = [
        "35.235.240.0/20",
      ]
    },
    {
      name      = "vpc-dev-shared-allow-rdp"
      direction = "INGRESS"
      priority  = 10000

      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }

      allow = [
        {
          protocol = "tcp"
          ports    = ["3389"]
        }
      ]

      ranges = [
        "35.235.240.0/20",
      ]
    },
  ]
}

## Dev shared VPC subnets
# naming syntax: {company-name}-{description-label}-{region/zone-label}
resource "google_compute_subnetwork" "subnet-dev-east1" {
  project                  = module.dpgraham-vpc-host-nonprod.project_id
  region                   = "us-east1"
  ip_cidr_range            = "10.10.0.0/16"
  name                     = "subnet-dev-east1"
  network                  = module.vpc-dev-shared.network_id
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "subnet-dev-central1" {
  project                  = module.dpgraham-vpc-host-nonprod.project_id
  region                   = "us-central1"
  ip_cidr_range            = "10.11.0.0/16"
  name                     = "subnet-dev-central1"
  network                  = module.vpc-dev-shared.network_id
  private_ip_google_access = true
}