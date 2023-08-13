variable "project_id" {
  description = "The project ID to deploy to"
  type        = string
  default     = "dpgraham"
}

variable "static_ip_name" {
  description = "the name applied to the static IP resource"
  type        = string
  default     = "dpgraham-com-global-ip"
}

variable "name" {
  description = "Name of the load balancer"
  type        = string
}

variable "domain_name" {
  description = "The domain name to use for the load balancer"
  type        = string
  default     = "dpgraham.com"
}

variable "ssl" {
  description = "Whether to use SSL or not"
  type        = bool
  default     = true
}

variable "backend_service" {
  description = "The name of the backend service that serves our restful API"
  type        = string
}

variable "frontend_service" {
  description = "The name of the frontend service the serves our react app"
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
