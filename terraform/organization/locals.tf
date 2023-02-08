locals {
    vpc = {
        name = "main-vpc"
        cidr = "10.0.0.0/16"

        azs             = ["us-east-1a", "us-east-1b"]
        private_subnets = ["10.0.2.0/24", "10.0.3.0/24"]

        enable_nat_gateway = false
        enable_vpn_gateway = false
    }

    lab_role = "arn:aws:iam::139927629559:role/LabRole"
}