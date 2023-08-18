# variables.tf
variable "project_name" {
  description = "The project ID to deploy to"
  type        = string
  default     = "dpgraham-dev"
}

variable "project" {
  description = "The project ID to deploy to"
  type        = string
  default     = "dpgraham-com-dev"
}

variable "host_project" {
  description = "The project ID to deploy to"
  type        = string
  default     = "dpgraham-vpc-host-nonprod"
}

variable "region" {
  description = "The region to deploy to"
  type        = string
  default     = "us-east1"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_username" {
  description = "The username of the built in database user"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password of the built in database user"
  type        = string
  sensitive   = true
}

variable "artifact_repo" {
  description = "The ID of the artifact repository"
  type        = string
  default     = "dpgraham-com-dev"
}

variable "server_image_name" {
  description = "The name of the HTTP server image stored in the GCP Artifact Repository"
  type        = string
  default     = "server"
}

variable "client_image_name" {
  description = "The name of the front end image stored in the GCP Artifact Repository"
  type        = string
  default     = "dpgraham-client"
}
