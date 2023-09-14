variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  type        = string
}

variable "location" {
  description = "The GCP region in which to create the bucket"
  type        = string
  default     = "US"
}

variable "project_id" {
  description = "The GCP project ID in which to create the bucket"
  type        = string
}

variable "environment" {
  description = "The environment in which to create the bucket"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be one of [devel, prod]"
  }
}