variable "billing_account" {
  description = "The ID of the billing account to associate projects with"
  type        = string
}

variable "org_id" {
  description = "The organization id for the associated resources"
  type        = string
}

variable "primary_domain" {
  description = "The primary domain for the associated resources"
  type        = string
  default     = "dpgraham.com"
}

variable "dpgraham_dev_project_number" {
  description = "The project number for the dpgraham-dev project"
  type        = string
  default     = "1019596679104"
}

variable "dev_project_id" {
  description = "The project id for the dpgraham development env. project"
  type        = string
  default     = "dpgraham-com-dev"
}

variable "dev_shared_vpc_project_id" {
  description = "The project id for the nonprod shared VPC host project"
  type        = string
  default     = "dpgraham-vpc-host-nonprod"
}

variable "prod_project_id" {
  description = "The project id for the dpgraham production env. project"
  type        = string
  default     = "dpgraham-com-prod"
}
