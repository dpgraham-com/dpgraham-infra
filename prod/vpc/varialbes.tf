variable "project_id" {
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
  type        = string
  description = "The environment to deploy to"
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be one of [dev, prod]"
  }
}

variable "shared_vpc_name" {
  description = "The name of the shared VPC to deploy to"
  type        = string
}
