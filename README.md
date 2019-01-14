# feedyard/tf-aws-aurora-rds

Terraform moduile to provision aurora rds/serverless instances accessible to platform cluster

assumptions related to this aurora-rds definition  

this are used in conjunction with a k8 cluster on a platform-vpc definition  

you must publish and make available  

for the target cluster  
1. vpc_id (id) the k8 cluster vpc id
1. cluster_db_subnet_group (group id) the subnet group id for the k8 cluster private subnets
1. cluster_db_subnets_azs (list of the k8 cluster private subnet azs)
1. cluster_nodes_security_group (sg id) security group id associated with nodes in the k8 cluster to put in the allowed list


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | name for the rds cluster resource. This optional, terraform will assign a random unique identifier | string | - | yes |
| deletion\_protection | prevent database resource from being deleted | string | `false` | no |
| master\_password | must provide master password and username unless database being restored from master snapshot | string | - | no |
| master\_username | must provide master password and username unless database being restored from master snapshot | string | `postgres` | no |
| final\_snapshot\_identifier | when the database resource is deleted a final snapshot will be created unless set to skip | string | - | no |
| skip\_final\_snapshot | when the database resource is deleted a final snapshot will be created unless set to skip | string | `false` | no |
| cluster\_db\_subnets\_azs | list of the cluster db (private) subnet azs | list | - | yes |
| backtrack\_window | only for aurora. must be between 0 and 259200 (72 hours). default is 0 (off) | string | `0` | no |
| backup\_retention\_period | days to retain backup. default is 7 | string | `7` | no |
| preferred\_backup\_window | if automated backups enable, when should backups run? default is 2am | string | `02:00-03:00` | no |
| preferred\_maintenance\_window | preferred maintenance window. default is Sunday at 2am | string | `sun:05:00-sun:06:00` | no |
| port | default connection port. a local resource provider will set to default postgresql or mysql aurora values 3306-5432 | string | - | no |
| vpc\_id | vpc in which to create the db security group | string | - | yes |
| cluster\_worker\_security\_group | list of security groups associated with nodes in the k8 cluster | string | - | yes |
| snapshot\_identifier | create this cluster from a snapshot | string | - | no |
| storage\_encrypted | encrypt cluster | string | `true` | no |
| replication\_source\_identifier | ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica | string | - | no |
| apply\_immediately | cluster modifications are applied immediately or (false) during the next maintenance window. default is false | string | `false` | no |
| cluster\_db\_subnet\_group | subnets to assign to DB subnet group created for the cluster resource | string | - | yes |
| db\_cluster\_parameter\_group\_name | see aws docuemntation for customization details | string | - | no |
| kms\_key\_id | specify a specific key for database encryption | string | - | no |
| iam\_roles | list of IAM roles to assign to the cluster | list | `<list>` | no |
| iam\_database\_authentication\_enabled | mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled? | string | `false` | no |
| engine | rds engine, default is aurora-postgresql | string | `aurora-postgresql` | no |
| engine\_mode | engine mode (global, parallelquery, provisioned, serverless). default is provisioned | string | `provisioned` | no |
| engine\_version | engine version. default to postgresql 10.5 | string | `10.5` | no |
| source\_region | source region for an encrypted replica DB cluster | string | - | no |
| enabled\_cloudwatch\_logs\_exports | types of logs to emit (audit, error, general, slowquery). default is audit | list | `<list>` | no |
| scaling\_configuration | scaling configuration for use with serverless | list | `<list>` | no |
| replica\_count | number of replicas. If `replica_scale_enable` is `true`, the value of `replica_scale_min` is used instead | string | `1` | no |
| replica\_scale\_enabled | enable autoscaling for read replicas | string | `false` | no |
| replica\_scale\_max | max number of replicas | string | `0` | no |
| replica\_scale\_min | min number of replicas | string | `2` | no |
| instance\_type | default instance type | string | `db.r4.large` | no |
| publicly\_accessible | provide public ip for db. default is false | string | `false` | no |
| db\_parameter\_group\_name | see aws docuemntation for customization details | string | - | no |
| monitoring\_interval | interval (seconds) between points when Enhanced Monitoring metrics are collected | string | `0` | no |
| auto\_minor\_version\_upgrade | whether minor engine upgrades will be performed automatically in the maintenance window | string | `true` | no |
| performance\_insights\_enabled | Performance Insights enabled. default is false | string | `false` | no |
| performance\_insights\_kms\_key\_id | KMS key to encrypt Performance Insights data | string | - | no |
| replica\_scale\_cpu | CPU usage to trigger autoscaling | string | `70` | no |
| replica\_scale\_in\_cooldown | Cooldown in seconds before allowing further scaling operations after a scale in | string | `300` | no |
| replica\_scale\_out\_cooldown | Cooldown in seconds before allowing further scaling operations after a scale out | string | `300` | no |
| tags | tags | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| rds\_cluster\_id | - |
| rds\_cluster\_port | - |
| rds\_cluster\_endpoint | - |
| rds\_cluster\_reader\_endpoint | - |
| rds\_cluster\_master\_password | - |
| rds\_cluster\_master\_username | - |
| rds\_cluster\_instance\_endpoints | - |
| security\_group\_id | aurora rds cluster security group |

