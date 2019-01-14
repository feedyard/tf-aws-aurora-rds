# feedyard/tf-aws-aurora-rds

Terraform moduile to provision aurora rds/serverless instances accessible to platform cluster

# assumptions related to a di-aurora-rds definition
#
# this are used in conjunction with a k8 cluster on a platform-vpc definition
#
# therefore, you must publish and make available
#
# for the target cluster
# vpc_id (id) the k8 cluster vpc id
# cluster_db_subnet_group (group id) the subnet group id for the k8 cluster private subnets
# cluster_db_subnets_azs (list of the k8 cluster private subnet azs)
# cluster_nodes_security_group (sg id) security group id associated with nodes in the k8 cluster to put in the allowed list


