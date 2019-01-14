terraform {
  required_version = ">= 0.11.11"
}

provider "aws" {
  version = ">= 1.55"
  region  = "${var.aws_region}"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "name" {}
variable "engine" {}
variable "engine_version" {}
variable "replica_count" {}
variable "apply_immediately" {}
variable "skip_final_snapshot" {}

variable "cluster_name" {}
variable "cluster_vpc_name" {}
variable "cluster_cidr_reservation_start" {}

variable "cluster_azs" {
  type = "list"
}
