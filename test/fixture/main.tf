module "aurora" {
  source                        = "../../"

  name                          = "${var.name}"
  engine                        = "${var.engine}"
  engine_version                = "${var.engine_version}"
  cluster_db_subnet_group       = "${module.vpc.database_subnet_group}"
  cluster_db_subnets_azs        = ["${var.availability_zones}"]
  vpc_id                        = "${module.vpc.vpc_id}"
  replica_count                 = "${var.replica_count}"
  apply_immediately             = "${var.apply_immediately}"
  skip_final_snapshot           = "${var.skip_final_snapshot}"
  cluster_nodes_security_group  = "${aws_security_group.test_security_group.id}"

  tags = {
    "test"     = "terraform module continuous integration testing"
    "pipeline" = "feedyard/tf-aws-aurora-rds"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "feedyard-ci-test-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["${var.availability_zones}"]

  private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/25",
  ]

  public_subnets = [
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/25",
  ]

  database_subnets = [
    "10.0.7.0/24",
    "10.0.8.0/24",
    "10.0.9.0/25",
  ]
}

resource "aws_security_group" "test_security_group" {
  name   = "feedyard-ci-test-security-group"
  vpc_id = "${module.vpc.vpc_id}"
}
