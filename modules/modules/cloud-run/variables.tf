variable "name" {
  type        = string
  description = "The name of the cloud run resource instance"
}

variable "project" {
  default     = "dpgraham"
  type        = string
  description = "The project ID"
}

variable "region" {
  type        = string
  description = "The region to deploy to"
  default     = "us-east1"
}

variable "environment" {
  description = "the environment to deploy to"
  type        = string
  validation {
    condition     = contains(["development", "production"], var.environment)
    error_message = "environment must be one of development or production"
  }
}

variable "port" {
  type        = string
  description = "The PORT cloud run will listen for"
}

variable "image" {
  type        = string
  description = "The container image, located on GCP artifact registry to use"
}

variable "vpc_connector" {
  type        = string
  description = "The ID of the VPC connector to use"
}

variable "env" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}
