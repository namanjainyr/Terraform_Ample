terraform {
  backend "s3" {
    bucket = "amplebucketstate"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}