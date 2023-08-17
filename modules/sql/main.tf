# A module to create a Cloud SQL Postgres instance, database, user and related networking resources.

# This modules uses a private IP address and private services access to set up database access.
# For an overview of using a Private IP address with Cloud SQL see:
# https://cloud.google.com/sql/docs/postgres/private-ip

locals {
  # database tiers follow legacy sets of "db-custom-<VCPUs>-<RAM in MB>"
  database_tier = var.environment == "prod" ? "db-custom-1-3840" : "db-f1-micro"
  disk_size     = var.environment == "prod" ? 10 : 10 # in GB, 10 GB is the minimum
  availability  = var.environment == "prod" ? "REGIONAL" : "ZONAL"
  instance_name = var.environment == "prod" ? "${replace(var.name,"_","-")}-postgres" : "${replace(var.name,"_" ,"-" )}-postgres-dev"
  ip_range_name = "${replace(var.name, "_", "-")}-ip-range"
}


resource "google_sql_database_instance" "default" {
  database_version = "POSTGRES_15"
  name             = "test-using-shared-vpc"
  project          = var.project_id
  region           = var.region

  settings {
    activation_policy = "ALWAYS"
    availability_type = "ZONAL"

    backup_configuration {
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }

      enabled                        = true
      location                       = "us"
      point_in_time_recovery_enabled = true
      start_time                     = "12:00"
      transaction_log_retention_days = 7
    }

    disk_autoresize       = true
    disk_autoresize_limit = 0
    disk_size             = 10
    disk_type             = "PD_SSD"

    ip_configuration {
      ipv4_enabled    = true
      private_network = var.vpc
    }
    pricing_plan = "PER_USE"
    tier         = local.database_tier
  }
}

#resource "google_sql_database_instance" "database_instance" {
#  name             = local.instance_name
#  database_version = "POSTGRES_15"
#  region           = var.region
#  project          = var.project_id
#  depends_on       = [
#    google_service_networking_connection.sql_vpc_connection
#  ]
#
#  settings {
#    tier              = local.database_tier
#    activation_policy = "ALWAYS"
#    availability_type = local.availability
#    disk_size         = local.disk_size
#    database_flags {
#      name  = "cloudsql.iam_authentication"
#      value = "on"
#    }
#    ip_configuration {
#      private_network    = var.vpc
#      ipv4_enabled       = true
#      allocated_ip_range = google_compute_global_address.private_ip_range.name
#    }
#    backup_configuration {
#      backup_retention_settings {
#        retained_backups = 3
#        retention_unit   = "COUNT"
#      }
#      enabled                        = true
#      location                       = "us"
#      point_in_time_recovery_enabled = true
#      start_time                     = "12:00"
#      transaction_log_retention_days = 3
#    }
#  }
#}

#resource "google_sql_database" "postgres" {
#  name     = var.name
#  instance = google_sql_database_instance.database_instance.name
#}

resource "google_sql_user" "user" {
  instance = google_sql_database_instance.default.name
  type     = "BUILT_IN"
  name     = var.db_username
  password = var.db_password
}

# This is part of setting up private services access for Cloud SQL
resource "google_compute_global_address" "private_ip_range" {
  name          = local.ip_range_name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.vpc
}

resource "google_service_networking_connection" "sql_vpc_connection" {
  network                 = var.vpc
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.private_ip_range.name
  ]
}
