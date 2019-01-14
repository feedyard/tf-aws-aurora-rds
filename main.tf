locals {
  port                      = "${var.port == "" ? "${var.engine == "aurora-postgresql" ? "5432" : "3306"}" : var.port}"
  master_password           = "${var.master_password == "" ? random_id.master_password.b64 : var.master_password}"
  final_snapshot_identifier = "${var.final_snapshot_identifier == "" ? "final-snapshot-${var.name}-${random_id.snapshot_identifier.hex}" : var.final_snapshot_identifier}"
}

resource "aws_rds_cluster" "mod" {
  cluster_identifier                  = "${var.name}"
  deletion_protection                 = "${var.deletion_protection}"
  master_password                     = "${local.master_password}"
  master_username                     = "${var.master_username}"
  final_snapshot_identifier           = "${local.final_snapshot_identifier}"
  skip_final_snapshot                 = "${var.skip_final_snapshot}"
  availability_zones                  = "${var.cluster_db_subnets_azs}"
  backtrack_window                    = "${var.backtrack_window}"
  backup_retention_period             = "${var.backup_retention_period}"
  preferred_backup_window             = "${var.preferred_backup_window}"
  preferred_maintenance_window        = "${var.preferred_maintenance_window}"
  port                                = "${local.port}"
  vpc_security_group_ids              = ["${aws_security_group.mod.id}"]
  snapshot_identifier                 = "${var.snapshot_identifier}"
  storage_encrypted                   = "${var.storage_encrypted}"
  replication_source_identifier       = "${var.replication_source_identifier}"
  apply_immediately                   = "${var.apply_immediately}"
  db_subnet_group_name                = "${var.cluster_db_subnet_group}"
  db_cluster_parameter_group_name     = "${var.db_cluster_parameter_group_name}"
  kms_key_id                          = "${var.kms_key_id}"
  iam_roles                           = "${var.iam_roles}"
  iam_database_authentication_enabled = "${var.iam_database_authentication_enabled}"
  engine                              = "${var.engine}"
  engine_mode                         = "${var.engine_mode}"
  engine_version                      = "${var.engine_version}"
  source_region                       = "${var.source_region}"
  enabled_cloudwatch_logs_exports     = "${var.enabled_cloudwatch_logs_exports}"
  scaling_configuration               = "${var.scaling_configuration}"

  tags = "${var.tags}"
}

# generate random string as master password unless specified
resource "random_id" "master_password" {
  byte_length = 16
}

resource "random_id" "snapshot_identifier" {
  keepers = {
    id = "${var.name}"
  }

  byte_length = 4
}

resource "aws_security_group" "mod" {
  name   = "${var.name}-aurora-rds-sg"
  vpc_id = "${var.vpc_id}"

  tags = "${var.tags}"
}

resource "aws_security_group_rule" "default_ingress" {
  type                     = "ingress"
  from_port                = "${aws_rds_cluster.mod.port}"
  to_port                  = "${aws_rds_cluster.mod.port}"
  protocol                 = "tcp"
  source_security_group_id = "${var.cluster_worker_security_group}"
  security_group_id        = "${aws_security_group.mod.id}"
}

resource "aws_rds_cluster_instance" "mod" {
  count = "${var.replica_scale_enabled ? var.replica_scale_min : var.replica_count}"

  identifier                      = "${var.name}-${count.index + 1}"
  cluster_identifier              = "${aws_rds_cluster.mod.id}"
  engine                          = "${var.engine}"
  engine_version                  = "${var.engine_version}"
  instance_class                  = "${var.instance_type}"
  publicly_accessible             = "${var.publicly_accessible}"
  db_subnet_group_name            = "${var.cluster_db_subnet_group}"
  db_parameter_group_name         = "${var.db_parameter_group_name}"
  preferred_maintenance_window    = "${var.preferred_maintenance_window}"
  apply_immediately               = "${var.apply_immediately}"
  monitoring_role_arn             = "${join("", aws_iam_role.rds_enhanced_monitoring.*.arn)}"
  monitoring_interval             = "${var.monitoring_interval}"
  auto_minor_version_upgrade      = "${var.auto_minor_version_upgrade}"
  promotion_tier                  = "${count.index + 1}"
  performance_insights_enabled    = "${var.performance_insights_enabled}"
  performance_insights_kms_key_id = "${var.performance_insights_kms_key_id}"

  tags = "${var.tags}"
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
  count = "${var.monitoring_interval > 0 ? 1 : 0}"

  name               = "rds-enhanced-monitoring-${var.name}"
  assume_role_policy = "${data.aws_iam_policy_document.monitoring_rds_assume_role.json}"
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count = "${var.monitoring_interval > 0 ? 1 : 0}"

  role       = "${aws_iam_role.rds_enhanced_monitoring.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "monitoring_rds_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_appautoscaling_target" "read_replica_count" {
  count = "${var.replica_scale_enabled ? 1 : 0}"

  max_capacity       = "${var.replica_scale_max}"
  min_capacity       = "${var.replica_scale_min}"
  resource_id        = "cluster:${aws_rds_cluster.mod.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}

resource "aws_appautoscaling_policy" "autoscaling_read_replica_count" {
  count = "${var.replica_scale_enabled ? 1 : 0}"

  name               = "target-metric"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "cluster:${aws_rds_cluster.mod.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "RDSReaderAverageCPUUtilization"
    }

    scale_in_cooldown  = "${var.replica_scale_in_cooldown}"
    scale_out_cooldown = "${var.replica_scale_out_cooldown}"
    target_value       = "${var.replica_scale_cpu}"
  }

  depends_on = ["aws_appautoscaling_target.read_replica_count"]
}
