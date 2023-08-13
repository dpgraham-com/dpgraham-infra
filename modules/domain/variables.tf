variable "project_id" {
  type        = string
  description = "The project identifier"
}

variable "domain_name" {
  description = "the top level domain of the project"
  type        = string
  default     = "dpgraham.com"
}

variable "dns_zone_name" {
  description = "The Name given to our DNS managed zone"
  type        = string
  default     = "dpgraham-dns-zone"
}

variable "ipv4_address" {
  description = "The Static address that nameservers should resolve to for our top level domain"
  type        = string
}

variable "ssl_cert_name" {
  description = "name to give to the google managed ssl certification"
  type        = string
  default     = "dpgraham-com-ssl-cert"
}
