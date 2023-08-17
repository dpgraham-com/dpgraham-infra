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

  subnets = [
    {
      subnet_name               = "subnet-prod-1"
      subnet_ip                 = "10.128.0.0/16"
      subnet_region             = "us-east1"
      subnet_private_access     = true
      subnet_flow_logs          = true
      subnet_flow_logs_sampling = "0.5"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
    },
    {
      subnet_name               = "subnet-prod-2"
      subnet_ip                 = "10.1.0.0/16"
      subnet_region             = "us-central1"
      subnet_private_access     = true
      subnet_flow_logs          = true
      subnet_flow_logs_sampling = "0.5"
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
    },
  ]

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


# Development and non-prod organization level shared VPC
module "vpc-dev-shared" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id   = module.dpgraham-vpc-host-nonprod.project_id
  network_name = "vpc-dev-shared"

  subnets = [
    {
      subnet_name           = "subnet-dev-2"
      subnet_ip             = "10.1.0.0/16"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
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

