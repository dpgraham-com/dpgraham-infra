variable "region" {
  description = "The GCP region the database will be hosted in"
  type        = string
  default     = "us-east1"
}

variable "project_id" {
  description = "The project id to deploy to"
  type        = string
}

variable "name" {
  description = "The name of the database to create"
  type        = string
  default     = "dpgraham"
}

variable "db_username" {
  description = "The database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The database password"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "The environment to deploy to"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be one of [devel, prod]"
  }
}

variable "vpc" {
  description = "The ID of vpc the database is deployed to"
  type        = string
}
