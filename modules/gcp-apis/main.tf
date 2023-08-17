resource "google_project_service" "enabled_services" {
  count = length(var.services)

  project = var.project
  service = var.services[count.index]
}