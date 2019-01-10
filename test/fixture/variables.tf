terraform {
  required_version = ">= 0.11.11"
}

provider "aws" {
  version = ">= 1.54"
  region  = "${var.aws_region}"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "name" {}
variable "engine" {}
variable "engine_version" {}

variable "availability_zones" {
  type = "list"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "replica_count" {}
variable "apply_immediately" {}
variable "skip_final_snapshot" {}
