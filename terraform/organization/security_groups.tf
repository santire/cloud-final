module "lambdas_security_group_id" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "lambdas-security-group"
  vpc_id      = module.vpc.vpc_id

  egress_with_cidr_blocks = [
    {
      from_port = 0
      to_port   = 65356
      protocol  = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}