# backend.tf
terraform {
  backend "gcs" {
    bucket = "tf-state-dpgraham"
    prefix = "terraform/state"
  }
}
