# backend.tf
terraform {
  backend "gcs" {
    # Use the cloud setup host project to store the state
    bucket = "tf-state-dpgraham-cs-host-a129ed3bccf04a1abf8760"
    prefix = "terraform/state"
  }
}
