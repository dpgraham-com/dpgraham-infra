locals {
  name                   = var.environment == "prod" ? var.name : "${var.name}-dev"
  max_instance_count     = var.environment == "prod" ? 3 : 1
  connector_machine_type = var.environment == "prod" ? "e2-micro" : "f1-micro"
}

resource "google_vpc_access_connector" "vpc_connector" {
  name          = "${local.name}-vpc-connector"
  project       = var.project
  network       = var.vpc
  region        = var.region
  ip_cidr_range = var.connector_cidr
  machine_type  = local.connector_machine_type
}

resource "google_cloud_run_v2_service" "default" {
  name     = local.name
  location = var.region
  lifecycle {
    ignore_changes = [template, client, client_version, labels]
  }

  template {
    containers {
      ports {
        container_port = var.port
      }
      image = var.image
      dynamic "env" {
        for_each = var.env
        content {
          name  = env.value.name
          value = env.value.value
        }
      }
    }
    vpc_access {
      connector = google_vpc_access_connector.vpc_connector.id
      egress    = "ALL_TRAFFIC"
    }
    scaling {
      # Limit scale up to prevent any cost blow outs!
      max_instance_count = local.max_instance_count
    }
  }
}

data "google_iam_policy" "no_auth" {
  binding {
    role    = "roles/run.invoker"
    members = ["allUsers"]
  }
}

resource "google_cloud_run_service_iam_policy" "no_auth" {
  location = google_cloud_run_v2_service.default.location
  project  = google_cloud_run_v2_service.default.project
  service  = google_cloud_run_v2_service.default.name

  policy_data = data.google_iam_policy.no_auth.policy_data
  depends_on  = [google_cloud_run_v2_service.default, data.google_iam_policy.no_auth]
}
