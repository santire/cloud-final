module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = local.vpc.name
    cidr = local.vpc.cidr

    azs             = local.vpc.azs
    public_subnets  = local.vpc.public_subnets
    private_subnets = local.vpc.private_subnets

    enable_nat_gateway = local.vpc.enable_nat_gateway
    enable_vpn_gateway = local.vpc.enable_vpn_gateway

    enable_dns_hostnames = true
    enable_dns_support   = true
}