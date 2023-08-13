output "network" {
  value = module.vpc.network_id
}

output "subnets" {
  value = module.vpc.subnets
}