variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "environment" {
  description = "The deployment environment"
  type        = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be one of [dev, prod]"
  }
}

variable "cloud_infra_sa" {
  description = "The username of the service account that has permissions to provision cloud infrastructure"
  type        = string
}

variable "cloud_run_sa" {
  description = "The username of the service account that has permissions to deploy cloud run and read/write access to Google Artifact Registry"
  type        = string
}

variable "github_org" {
  description = "The name of the GitHub organization to use for the application"
  type        = string
}

variable "pool_id" {
  description = "The ID of the pool to use for the WIF pool for using service accounts with GitHub Actions"
  type        = string
}
