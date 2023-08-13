# network outputs

output "database_subnet_cidr" {
  value = google_compute_subnetwork.database_subnet.ip_cidr_range
}

output "db_subnet_id" {
  value = google_compute_subnetwork.database_subnet.id
}

output "network" {
  value = module.vpc.network
}

output "vpc" {
  value = module.vpc.network_id
}