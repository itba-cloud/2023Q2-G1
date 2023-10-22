#base_domain
base_domain = "moneyorganizer.clouditba.com.ar"

#s3 
bucket_name        = "moneyorganizer"
bucket_budget_name = "itba-cloud-budget-bucket"

#VPC
vpc_name = "example-vpc-name"

#Lambda
lambda_security_group_name = "Lambda Security Group"

#Lambda
lambda_functions_paths = {
  source = "./resources/lambda/"
  output = "./resources/lambda/"
}