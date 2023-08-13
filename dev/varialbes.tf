# variables.tf
variable "project_name" {
  description = "The project ID to deploy to"
  default     = "dpgraham-dev"
}

variable "project" {
  description = "The project ID to deploy to"
  default     = "dpgraham-com-dev"
}

variable "region" {
  description = "The region to deploy to"
  default     = "us-east1"
}