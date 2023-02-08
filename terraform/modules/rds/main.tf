resource "aws_db_subnet_group" "db" {
  name       = "${var.name}-db"
  subnet_ids = var.subnet_ids
}

module "replica_backend_db_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.name}-db"
  description = "Open access to PG instance."
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 5432
      protocol    = "tcp"
      description = "psql into the DB"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  ingress_with_source_security_group_id = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      source_security_group_id = var.lambdas_security_group_id
    }
  ]
}

module "cloud_db" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = "${var.name}"

  engine            = "postgres"
  engine_version    = "13.8"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name  = var.pg_database
  username = var.pg_username
  password = var.pg_password
  port     = var.pg_port

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  family = "postgres13"

  publicly_accessible     = true
  db_subnet_group_name    = aws_db_subnet_group.db.id
  vpc_security_group_ids  = [module.replica_backend_db_security_group.security_group_id]


  # Database Deletion Protection
  deletion_protection = true
}
