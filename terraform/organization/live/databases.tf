# NOTE: Aurora Serverless no funciona, hay que levantar una RDS convencional O ir por DynamoDB 
#
# locals {
#   name = "app-db"
# }

# module "cluster" {
#   source  = "terraform-aws-modules/rds-aurora/aws"

#   name = local.name

#   engine            = "aurora-postgresql"
#   engine_mode       = "provisioned"
#   engine_version    = "14.3"
#   storage_encrypted = true

#   vpc_id                = module.vpc.vpc_id
#   subnets               = module.vpc.database_subnets
#   create_security_group = true
#   allowed_cidr_blocks   = module.vpc.private_subnets_cidr_blocks

#   create_monitoring_role = false
#   monitoring_interval    = 0

#   apply_immediately   = true
#   skip_final_snapshot = true

#   db_parameter_group_name         = aws_db_parameter_group.pg14.id
#   db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.pg14.id

#   serverlessv2_scaling_configuration = {
#     min_capacity             = 0.5
#     max_capacity             = 1
#   }

#   instance_class = "db.serverless"
#   instances = {
#     one = {}
#   }
# }

# resource "aws_db_parameter_group" "pg14" {
#   name        = "${local.name}-aurora-db-postgres-parameter-group"
#   family      = "aurora-postgresql14"
#   description = "${local.name}-aurora-db-postgres-parameter-group"
# }

# resource "aws_rds_cluster_parameter_group" "pg14" {
#   name        = "${local.name}-aurora-postgres-cluster-parameter-group"
#   family      = "aurora-postgresql14"
#   description = "${local.name}-aurora-postgres-cluster-parameter-group"
# }