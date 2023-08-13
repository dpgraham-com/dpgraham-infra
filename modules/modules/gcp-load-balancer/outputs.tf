# The global static ip address of our externally facing load balancer
output "ip_address" {
  value = module.lb-http.external_ip
}