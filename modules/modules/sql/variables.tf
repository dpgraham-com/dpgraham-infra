variable "region" {
  description = "The region to deploy to"
  type        = string
  default     = "us-east1"
}

variable "project_id" {
  description = "The project id to deploy to"
  type        = string
  default     = "dpgraham"
}

variable "name" {
  description = "The name to deploy to"
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
    condition     = contains(["development", "production"], var.environment)
    error_message = "Environment must be one of [development, production]"
  }
}

variable "vpc" {
  description = "The ID of vpc the database is deployed to"
  type        = string
}
