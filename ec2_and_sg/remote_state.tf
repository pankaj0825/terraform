data "terraform_remote_state" "vpc" {
    backend = "s3"
    config = {
      bucket = "backendstatefile-tf"
      key = "vpc/dev"
      region = "ap-south-1"
    }
}