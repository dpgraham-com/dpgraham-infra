variable "project_id" {
  default     = "dpgraham-com-dev"
  type        = string
  description = "The project ID to deploy to"
}


variable "host_project" {
  description = "The project ID to deploy to"
  type        = string
}

variable "name" {
  type        = string
  description = "The project name to deploy to"
}

variable "region" {
  default     = "us-east1"
  type        = string
  description = "The region to deploy to"
}

variable "environment" {
  default     = "dev"
  type        = string
  description = "The environment to deploy to"
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be one of [dev, prod]"
  }
}