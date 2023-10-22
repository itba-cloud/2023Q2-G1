module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnet_cidrs

  private_subnet_names = var.vpc_private_subnet_names
}

resource "aws_vpc_endpoint" "this" {
  vpc_id       = module.vpc.vpc_id
  service_name = var.vpc_endpoint_service_name

  route_table_ids = [module.vpc.default_route_table_id]
}
