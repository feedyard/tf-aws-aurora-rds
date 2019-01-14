
output "rds_cluster_id" {
  value = "${aws_rds_cluster.mod.id}"
}

output "rds_cluster_port" {
  value = "${aws_rds_cluster.mod.port}"
}

output "rds_cluster_endpoint" {
  value = "${aws_rds_cluster.mod.endpoint}"
}

output "rds_cluster_reader_endpoint" {
  value = "${aws_rds_cluster.mod.reader_endpoint}"
}

output "rds_cluster_master_password" {
  value = "${aws_rds_cluster.mod.master_password}"
}

output "rds_cluster_master_username" {
  value = "${aws_rds_cluster.mod.master_username}"
}

output "rds_cluster_instance_endpoints" {
  value = ["${aws_rds_cluster_instance.mod.*.endpoint}"]
}

# aurora rds cluster security group
output "security_group_id" {
  value = "${aws_security_group.mod.id}"
}
