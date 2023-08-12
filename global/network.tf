# VPC and Subnets
module "cs-vpc-prod-shared" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id   = module.cs-vpc-host-prod-km289-xm965.project_id
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

      allow = [{
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

      allow = [{
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

      allow = [{
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


# VPC and Subnets
module "cs-vpc-dev-shared" {
  source  = "terraform-google-modules/network/google"
  version = "~> 5.0"

  project_id   = module.cs-vpc-host-nonprod-km289-xm965.project_id
  network_name = "vpc-dev-shared"

  subnets = [
    {
      subnet_name           = "subnet-dev-1"
      subnet_ip             = "10.128.0.0/16"
      subnet_region         = "us-east1"
      subnet_private_access = true
    },
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

      allow = [{
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

      allow = [{
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

      allow = [{
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


