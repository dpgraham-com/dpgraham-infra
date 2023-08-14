#output "network" {
#  value = module.vpc.network_id
#}
#
#output "subnets" {
#  value = module.vpc.subnets
#}

output "internal_ip" {
  value = google_compute_address.internal_ip.address
}