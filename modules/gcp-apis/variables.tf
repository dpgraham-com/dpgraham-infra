variable "services" {
  description = "List of Google Cloud service names to enable."
  type        = list(string)
}

variable "project" {
  description = "The Google Cloud project ID to enable services in."
  type        = string
}