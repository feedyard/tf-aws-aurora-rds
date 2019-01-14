# name for the rds cluster resource. This optional, terraform will assign a random unique identifier
variable "name" {}

# prevent database resource from being deleted
variable "deletion_protection" {
  default = "false"
}

# must provide master password and username unless database being restored from master snapshot
variable "master_password" { default = "" }

# must provide master password and username unless database being restored from master snapshot
variable "master_username" {
  default = "postgres"
}

# when the database resource is deleted a final snapshot will be created unless set to skip
variable "final_snapshot_identifier" { default = "" }

# when the database resource is deleted a final snapshot will be created unless set to skip
variable "skip_final_snapshot" {
  default = "false"
}

# list of the cluster db (private) subnet azs
variable "cluster_db_subnets_azs" { type = "list" }

# only for aurora. must be between 0 and 259200 (72 hours). default is 0 (off)
variable "backtrack_window" {
  default = "0"
}

# days to retain backup. default is 7
variable "backup_retention_period" {
  default = "7"
}

# if automated backups enable, when should backups run? default is 2am
variable "preferred_backup_window" {
  default = "02:00-03:00"
}

# preferred maintenance window. default is Sunday at 2am
variable "preferred_maintenance_window" {
  default = "sun:05:00-sun:06:00"
}

# default connection port. a local resource provider will set to default postgresql or mysql aurora values 3306-5432
variable "port" { default = "" }

# vpc in which to create the db security group
variable "vpc_id" { type = "string" }

# list of security groups associated with nodes in the k8 cluster
variable "cluster_worker_security_group" { type = "string" }

# create this cluster from a snapshot
variable "snapshot_identifier" { default = "" }

# encrypt cluster
variable "storage_encrypted" {
  default = "true"
}

# ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica
variable "replication_source_identifier" { default = "" }

# cluster modifications are applied immediately or (false) during the next maintenance window. default is false
variable "apply_immediately" {
  default = "false"
}

# subnets to assign to DB subnet group created for the cluster resource
variable "cluster_db_subnet_group" { type = "string" }

# see aws docuemntation for customization details
variable "db_cluster_parameter_group_name" { default = "" }

# specify a specific key for database encryption
variable "kms_key_id" { default = "" }

# list of IAM roles to assign to the cluster
variable "iam_roles" {
  type    = "list"
  default = []
}

# mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled?
variable "iam_database_authentication_enabled" {
  default = "false"
}

# rds engine, default is aurora-postgresql
variable "engine" {
  default = "aurora-postgresql"
}

# engine mode (global, parallelquery, provisioned, serverless). default is provisioned
variable "engine_mode" {
  default = "provisioned"
}

# engine version. default to postgresql 10.5
variable "engine_version" {
  default = "10.5"
}

# source region for an encrypted replica DB cluster
variable "source_region" { default = "" }

# types of logs to emit (audit, error, general, slowquery). default is audit
variable "enabled_cloudwatch_logs_exports" {
  type    = "list"
  default = []
}

# scaling configuration for use with serverless
variable "scaling_configuration" {
  type    = "list"
  default = []
}

# number of replicas. If `replica_scale_enable` is `true`, the value of `replica_scale_min` is used instead
variable "replica_count" {
  default = 1
}

# enable autoscaling for read replicas
variable "replica_scale_enabled" {
  default = "false"
}

# max number of replicas
variable "replica_scale_max" {
  default = "0"
}

# min number of replicas
variable "replica_scale_min" {
  default = "2"
}

# default instance type
variable "instance_type" {
  default = "db.r4.large"
}

# provide public ip for db. default is false
variable "publicly_accessible" {
  default = "false"
}

# see aws docuemntation for customization details
variable "db_parameter_group_name" { default = "" }

#interval (seconds) between points when Enhanced Monitoring metrics are collected
variable "monitoring_interval" {
  default = "0"
}

# whether minor engine upgrades will be performed automatically in the maintenance window
variable "auto_minor_version_upgrade" {
  default = "true"
}

# Performance Insights enabled. default is false
variable "performance_insights_enabled" {
  default = "false"
}

# KMS key to encrypt Performance Insights data
variable "performance_insights_kms_key_id" { default = "" }

# CPU usage to trigger autoscaling
variable "replica_scale_cpu" {
  default = "70"
}

# Cooldown in seconds before allowing further scaling operations after a scale in
variable "replica_scale_in_cooldown" {
  default = "300"
}

# Cooldown in seconds before allowing further scaling operations after a scale out
variable "replica_scale_out_cooldown" {
  default = "300"
}

# tags
variable "tags" {
  type    = "map"
  default = {}
}
