# network inputs

variable "project" {
  description = "The GCP project to deploy to"
  type        = string
}

variable "region" {
  description = "The region to deploy to"
  type        = string
  default     = "us-east1"
}

variable "environment" {
  description = "The environment to deploy to"
  type        = string
  validation {
    condition     = contains(["development", "production"], var.environment)
    error_message = "Environment must be one of [development, production]"
  }
}

# Note: A VPC is a global resource, subnets are regional.
variable "subnets" {
  description = "Any subnets of the VPC."
  type        = list(object({
    subnet_name                = string
    subnet_ip                  = string
    subnet_region              = string
    subnet_private_access      = optional(string)
    subnet_private_ipv6_access = optional(string)
    description                = optional(string)
  }))
  default = []
}