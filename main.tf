#Network

module "network" {
  source = "./modules/network"

  vpc_name = var.vpc_name

  vpc_cidr = local.vpc_cidr
  vpc_azs  = local.vpc_azs

  vpc_private_subnet_cidrs = local.vpc_private_subnet_cidrs
  vpc_private_subnet_names = local.vpc.private_subnet_names

  vpc_endpoint_service_name = local.vpc.endpoint_service_name
}

#API Gateway

module "api_gateway" {
  source = "./modules/api_gateway"

  api_gateway_rest_api_info   = local.api_gateway_rest_api_info
  api_gateway_resources       = local.api_gateway_resources
  api_gateway_methods         = local.api_gateway_methods
  lambda_functions_invoke_arn = module.lambda.lambda_functions_invoke_arn
}


#Lambda

module "lambda" {
  source = "./modules/lambda"

  lambda_functions_paths        = var.lambda_functions_paths
  lambda_functions_source_files = local.lambda_functions_source_files
  lambda_functions_attributes   = local.lambda.functions_attributes
  api_gateway_source_arn        = local.api_gateway.source_arn

  vpc_subnets_ids                   = local.lambda.private_subnet_ids
  vpc_id                            = module.network.vpc_id
  lambda_security_group_name        = var.lambda_security_group_name
  lambda_security_group_description = local.lambda_security_group_description

  lambda_security_group_cidr_blocks = module.network.vpc_endpoint.cidr_blocks
}


#Route53
module "dns" {
  source      = "./modules/dns"
  base_domain = var.base_domain
  cdn         = module.cdn.cloudfront_distribution
}

#ACM
# module "acm" {
#   source = "./modules/acm"

#   base_domain = var.base_domain
#   zone_id     = module.dns.route53_zone_id

# }

#CDN
module "cdn" {
  source      = "./modules/cdn"
  bucket_name = module.bucket_s3["website_bucket"].domain_name
  bucket_id   = module.bucket_s3["website_bucket"].s3_bucket_id
  apigw_path  = local.api_gateway_rest_api_info.base_path
  apigw_url   = module.api_gateway.rest_api.invoke_url
  apigw_stage = local.api_gateway.stage_name
  # certificate_arn = module.acm.certificate_arn
}
module "bucket_s3" {
  for_each                 = local.buckets
  source                   = "./modules/buckets_s3"
  vpc_ids                  = try(each.value.vpc_ids, [])
  actions                  = try(each.value.actions, [])
  bucket_name              = each.value.bucket_name
  bucket_access_OAI        = try(each.value.identifiers, [])
  objects                  = try(each.value.objects, [])
  versioning               = try(each.value.versioning, "")
  logs                     = try(each.value.target_log, "")
  redirect_all_requests_to = try(each.value.redirect_all_requests_to, null)
  lifecycle_rule           = try(each.value.lifecycle_rule, [])
  bucket_policy_read       = try(each.value.bucket_policy_read, false)

}

