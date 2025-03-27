provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "ap-southeast-1"
}
