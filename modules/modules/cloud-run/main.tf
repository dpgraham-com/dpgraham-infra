locals {
  name               = var.environment == "production" ? var.name : "${var.name}-${var.environment}"
  max_instance_count = var.environment == "production" ? 3 : 1
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
      connector = var.vpc_connector
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
}
