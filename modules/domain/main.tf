# The domain modules sets up a our Domain name and resources related
# to DNS, sub-domains, and the like... (todo update module docs LOL)

resource "google_compute_managed_ssl_certificate" "dpgraham_com_ssl_cert" {
  project     = var.project_id
  provider    = google-beta
  description = "Google managed SSL certificate for dpgraham.com"
  name        = var.ssl_cert_name

  managed {
    domains = [var.domain_name]
  }
}

# Create a DNS managed zone
resource "google_dns_managed_zone" "dpgraham_com" {
  name          = var.dns_zone_name
  dns_name      = format("%s%s", var.domain_name, ".")
  description   = "DNS top level namespace"
  force_destroy = "true"
}


# to register web-server's ip address in DNS
resource "google_dns_record_set" "dpgraham_com_record_set" {
  name         = google_dns_managed_zone.dpgraham_com.dns_name
  managed_zone = google_dns_managed_zone.dpgraham_com.name
  type         = "A"
  ttl          = 300
  rrdatas      = [
    var.ipv4_address
  ]
}
