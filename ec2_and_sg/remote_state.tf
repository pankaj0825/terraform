data "terraform_remote_state" "vpc" {
    backend = "s3"
    config = {
      bucket = "backendstatefile-tf"
      key = "vpc/frontend"
      region = "ap-south-1"
    }
}