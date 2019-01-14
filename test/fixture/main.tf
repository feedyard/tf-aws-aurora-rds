module "aurora" {
  source = "../../"

  name                = "${var.name}"
  engine              = "${var.engine}"
  engine_version      = "${var.engine_version}"
  replica_count       = "${var.replica_count}"
  apply_immediately   = "${var.apply_immediately}"
  skip_final_snapshot = "${var.skip_final_snapshot}"

  vpc_id                        = "${module.cluster_vpc.vpc_id}"
  cluster_db_subnet_group       = "${module.cluster_vpc.db_subnet_group}"
  cluster_db_subnets_azs        = ["${slice(var.cluster_azs,0,3)}"]
  cluster_worker_security_group = "${aws_security_group.cluster_worker_security_group.id}"

  tags = {
    "test"     = "terraform module continuous integration testing"
    "pipeline" = "feedyard/tf-aws-aurora-rds"
  }
}

module "cluster_vpc" {
  source = "github.com/feedyard/tf-aws-platform-vpc?ref=0.0.1"

  name                   = "${var.cluster_vpc_name}"
  cluster_name           = "${var.cluster_name}"
  cidr_reservation_start = "${var.cluster_cidr_reservation_start}"
  azs                    = "${var.cluster_azs}"

  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  enable_nat_gateway   = "false}"

  tags {
    "test"     = "terraform module continuous integration testing"
    "pipeline" = "feedyard/tf-aws-aurora-rds"
  }
}

locals {
  workers_sg_tags = {
    test     = "terraform module continuous integration testing"
    pipeline = "feedyard/tf-aws-aurora-rds"
  }
}

resource "aws_security_group" "cluster_worker_security_group" {
  description = "Security group for all nodes in the cluster."

  name_prefix = "${var.cluster_name}"
  vpc_id      = "${module.cluster_vpc.vpc_id}"

  tags = "${merge("${local.workers_sg_tags}", map("Name", "ci_worker_sg", "kubernetes.io/cluster/${var.cluster_name}", "shared"))}"
}
