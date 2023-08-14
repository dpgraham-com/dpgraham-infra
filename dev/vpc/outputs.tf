output "network" {
  value = module.vpc.network_id
}

#output "subnets" {
#  value = module.vpc.subnets
#}

output "internal_ip" {
  value = google_compute_address.internal_ip.address
}

output "shared_vpc" {
  value = data.google_compute_network.shared_vpc.id
}