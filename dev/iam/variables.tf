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
