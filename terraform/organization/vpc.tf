module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = local.vpc.name
    cidr = local.vpc.cidr

    azs             = local.vpc.azs
    private_subnets = local.vpc.private_subnets

    enable_nat_gateway = local.vpc.enable_nat_gateway
    enable_vpn_gateway = local.vpc.enable_vpn_gateway
}