output "vpc_id" {
  description = "VPC id"
  value       = module.vpc.vpc_id
}

output "vpc_private_subnets_ids_by_cidr" {
  description = "Private subnets ids by cidr block"
  value       = { for i in range(length(module.vpc.private_subnets)) : module.vpc.private_subnets_cidr_blocks[i] => module.vpc.private_subnets[i] }
}

output "vpc_endpoint" {
  description = "Networking VPC Endpoint"
  value       = aws_vpc_endpoint.this
}