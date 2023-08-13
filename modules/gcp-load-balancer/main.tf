resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  provider              = google-beta
  name                  = "serverless-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  project               = var.project_id
  cloud_run {
    service = var.backend_service
  }
}

resource "google_compute_region_network_endpoint_group" "client_serverless_neg" {
  provider              = google-beta
  name                  = "client-serverless-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  project               = var.project_id
  cloud_run {
    service = var.frontend_service
  }
}


resource "google_compute_url_map" "lb-server-client-map" {
  name            = var.name
  default_service = module.lb-http.backend_services["default"].self_link

  host_rule {
    hosts        = [var.domain_name]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = module.lb-http.backend_services["default"].self_link

    path_rule {
      paths = [
        "/api/*"
      ]
      service = module.lb-http.backend_services["server"].self_link
    }
  }
}

resource "google_compute_url_map" "https_redirect" {
  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }

  name    = format("%s-%s", var.name, "http-redirect")
  project = var.project_id
}


module "lb-http" {
  source                          = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version                         = "~> 9.0"
  name                            = var.name
  project                         = var.project_id
  ssl                             = var.ssl
  managed_ssl_certificate_domains = [var.domain_name]
  https_redirect                  = var.ssl
  labels                          = { "example-label" = "cloud-run-example" }
  load_balancing_scheme           = "EXTERNAL_MANAGED"
  url_map                         = google_compute_url_map.lb-server-client-map.self_link
  create_url_map                  = false

  backends = {
    default = {
      description = "Cloud backend for directing requests to the react backend"
      groups      = [
        {
          group = google_compute_region_network_endpoint_group.client_serverless_neg.id
        }
      ]
      enable_cdn = false

      iap_config = {
        enable = false
      }
      log_config = {
        enable = false
      }
    }
    server = {
      description = "Cloud backend for directing to a NEG for the restful API (server)"
      groups      = [
        {
          group = google_compute_region_network_endpoint_group.serverless_neg.id
        }
      ]
      enable_cdn = false

      iap_config = {
        enable = false
      }
      log_config = {
        enable = false
      }
    }
  }
}
