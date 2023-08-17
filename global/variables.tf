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

