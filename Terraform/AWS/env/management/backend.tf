terraform {
  backend "s3" {
    bucket = "workquark-0403"
    key    = "Terraform/EKS/terraform.tfstate"
    region = "ap-south-1"
  }
}
