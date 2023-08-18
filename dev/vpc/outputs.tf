output "network" {
  value = module.vpc.network_id
}

output "shared_vpc_subnet" {
  value = data.google_compute_subnetwork.shared_vpc_subnet.id
}

output "shared_vpc" {
  value = data.google_compute_network.shared_vpc.id
}

output "serverless_vpc_connector" {
  value = sort(module.serverless_connector.connector_ids)[0]
}