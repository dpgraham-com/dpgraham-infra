# variables.tf
variable "project_name" {
  description = "The project ID to deploy to"
  type        = string
  default     = "dpgraham-dev"
}

variable "project_id" {
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
  default     = "dpgraham-server"
}

variable "client_image_name" {
  description = "The name of the front end image stored in the GCP Artifact Repository"
  type        = string
  default     = "dpgraham-client"
}

variable "domain" {
  description = "The domain name to use for the application"
  type        = string
  default     = "dev.dpgraham.com"
}

variable "github_org" {
  description = "The name of the GitHub organization to use for the application"
  type        = string
  default     = "dpgraham-com"
}

variable "cloud_infra_sa" {
  description = "The username of the service account that has permissions to provision cloud infrastructure"
  type        = string
  default     = "infra-deployer-dev"
}

variable "cloud_infra_sa_id" {
  description = "The unique ID of the service account that has permissions to provision cloud infrastructure"
  type        = string
  default     = "111498446616234598201"
}

variable "cloud_run_sa" {
  description = "The username of the service account that has permissions to deploy cloud run and read/write access to Google Artifact Registry"
  type        = string
  default     = "cloud-run-deployer"
}

variable "environment" {
  description = "The environment to deploy to"
  type        = string
  default     = "dev"
}
