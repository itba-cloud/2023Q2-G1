locals {
  #Region
  region = "us-east-1"

  #VPC

  vpc_cidr           = "10.0.0.0/16"
  vpc_azs            = ["us-east-1a", "us-east-1b"]
  vpc_subnets_per_az = 2

  vpc_private_subnet_cidrs = flatten(
    [for k, v in local.vpc_azs : [
      for i in range(local.vpc_subnets_per_az) : cidrsubnet(local.vpc_cidr, 8, 2 * i + k + 1)
      ]
    ]
  )

  vpc = {
    private_subnet_names          = [for k, v in local.vpc_private_subnet_cidrs : "private_subnet_${k}"]
    lambda_private_subnet_cidrs   = [for i in range(length(local.vpc_azs)) : local.vpc_private_subnet_cidrs[i]]
    database_private_subnet_cidrs = [for i in range(length(local.vpc_azs)) : local.vpc_private_subnet_cidrs[i + length(local.vpc_azs)]]
    endpoint_service_name         = "com.amazonaws.${local.region}.s3"
  }
  #Datasources
  account_id = data.aws_caller_identity.current.account_id

  #IAM
  lab_role = "arn:aws:iam::${local.account_id}:role/LabRole"

  lambda_security_group_description = "Default Lambda Security Group"

  lambda_functions_source_files = [for lambda_function_filename in fileset("${var.lambda_functions_paths.source}", "*.py") :
    {
      source_path = "${var.lambda_functions_paths.source}/${lambda_function_filename}"
      output_path = "${var.lambda_functions_paths.output}/${replace(lambda_function_filename, ".py", ".zip")}"
    }
  ]
  lambda = {
    functions_attributes = {
      get_expenses = {
        function_name    = "getExpenses"
        filename         = "${var.lambda_functions_paths.output}/getExpenses.zip"
        description      = "Get all expenses"
        source_code_hash = filebase64sha256("${var.lambda_functions_paths.output}/getExpenses.zip")
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "getExpenses.lambda_handler"
        timeout          = 10
      }
      post_expenses = {
        function_name    = "postExpenses"
        filename         = "${var.lambda_functions_paths.output}/postExpenses.zip"
        description      = "Create a new expense"
        source_code_hash = filebase64sha256("${var.lambda_functions_paths.output}/postExpenses.zip")
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "postExpenses.lambda_handler"
        timeout          = 10
      }
      put_expenses = {
        function_name    = "putExpenses"
        filename         = "${var.lambda_functions_paths.output}/putExpenses.zip"
        description      = "Modify an expense"
        source_code_hash = filebase64sha256("${var.lambda_functions_paths.output}/putExpenses.zip")
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "putExpenses.lambda_handler"
        timeout          = 10
      }
      delete_expenses = {
        function_name    = "deleteExpenses"
        filename         = "${var.lambda_functions_paths.output}/deleteExpenses.zip"
        description      = "Delete an expense"
        source_code_hash = filebase64sha256("${var.lambda_functions_paths.output}/deleteExpenses.zip")
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "deleteExpenses.lambda_handler"
        timeout          = 10
      }
      get_budgets = {
        function_name    = "getBudgets"
        filename         = "${var.lambda_functions_paths.output}/getBudgets.zip"
        description      = "Get all budgets"
        source_code_hash = filebase64sha256("${var.lambda_functions_paths.output}/getBudgets.zip")
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "getBudgets.lambda_handler"
        timeout          = 10
      }
      post_budgets = {
        function_name    = "postBudgets"
        filename         = "${var.lambda_functions_paths.output}/postBudgets.zip"
        description      = "Create a new budget"
        source_code_hash = filebase64sha256("${var.lambda_functions_paths.output}/postBudgets.zip")
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "postBudgets.lambda_handler"
        timeout          = 10
      }
      put_budgets = {
        function_name    = "putBudgets"
        filename         = "${var.lambda_functions_paths.output}/putBudgets.zip"
        description      = "Modify a budget"
        source_code_hash = filebase64sha256("${var.lambda_functions_paths.output}/putBudgets.zip")
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "putBudgets.lambda_handler"
        timeout          = 10
      }
      delete_budgets = {
        function_name    = "deleteBudgets"
        filename         = "${var.lambda_functions_paths.output}/deleteBudgets.zip"
        description      = "Delete a budget"
        source_code_hash = filebase64sha256("${var.lambda_functions_paths.output}/deleteBudgets.zip")
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "deleteBudgets.lambda_handler"
        timeout          = 10
      }
      post_users = {
        function_name    = "postUsers"
        filename         = "${var.lambda_functions_paths.output}/postUsers.zip"
        description      = "Create a new user"
        source_code_hash = filebase64sha256("${var.lambda_functions_paths.output}/postUsers.zip")
        role             = local.lab_role
        runtime          = "python3.9"
        handler          = "postUsers.lambda_handler"
        timeout          = 10
      }
    }
    private_subnet_ids = [for i, private_subnet_cidr in local.vpc.lambda_private_subnet_cidrs : module.network.vpc_private_subnets_ids_by_cidr[private_subnet_cidr]]
  }


  #API Gateway
  api_gateway = {
    source_arn = "${module.api_gateway.rest_api.execution_arn}/*"
    stage_name = "/${local.api_gateway_rest_api_info.stage_name}"
  }
  api_gateway_rest_api_info = {
    name        = "moneyorganizer REST API"
    description = "REST API functions for money management operations"
    stage_name  = "development"
    base_path   = "api"
  }
  api_gateway_resources = {
    expenses = {
      path_part = "expenses"
    }
    budgets = {
      path_part = "budgets"
    }
    users = {
      path_part = "users"
    }
  }
  api_gateway_methods = {
    get_expenses = {
      resource      = "expenses"
      method        = "GET"
      authorization = "NONE"
    }
    post_expenses = {
      resource      = "expenses"
      method        = "POST"
      authorization = "NONE"
    }
    put_expenses = {
      resource      = "expenses"
      method        = "PUT"
      authorization = "NONE"
    }

    delete_expenses = {
      resource      = "expenses"
      method        = "DELETE"
      authorization = "NONE"
    }

    get_budgets = {
      resource      = "budgets"
      method        = "GET"
      authorization = "NONE"
    }

    post_budgets = {
      resource      = "budgets"
      method        = "POST"
      authorization = "NONE"
    }

    put_budgets = {
      resource      = "budgets"
      method        = "PUT"
      authorization = "NONE"
    }

    delete_budgets = {
      resource      = "budgets"
      method        = "DELETE"
      authorization = "NONE"
    }

    post_users = {
      resource      = "users"
      method        = "POST"
      authorization = "NONE"
    }
  }

  #s3 buckets:
  buckets = {
    website_bucket = {
      bucket_name        = var.bucket_name
      bucket_policy_read = true
      identifiers        = [module.cdn.OAI]
      actions            = ["s3:GetObject"]
      objects = [
        {
          key          = "index.html"
          source       = "./frontend/index.html"
          content_type = "text/html"
        }
      ]
    }
    logs_bucket = {
      bucket_name = "${var.bucket_name}-logs"
      logs        = var.bucket_name
      lifecycle_rule = [
        {
          id      = "log-lifecycle"
          enabled = true
          prefix  = "log/"

          tags = {
            rule      = "log"
            autoclean = "true"
          }

          transition = [
            {
              days          = 30
              storage_class = "STANDARD_IA"
            },
            {
              days          = 60
              storage_class = "GLACIER"
            }
          ]

          expiration = {
            days = 90
          }

          noncurrent_version_expiration = {
            days = 30
          }
        }
      ]
    }
    budget_bucket = {
      bucket_name        = var.bucket_budget_name
      bucket_policy_read = true
      versioning         = "Enabled"
      identifiers        = ["*"]
      vpc_ids            = [module.network.vpc_endpoint.id]
      actions            = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
      lifecycle_rule = [
        {
          id      = "budget-lifecycle"
          enabled = true
          prefix  = "budget/"

          transition = [
            {
              days          = 180
              storage_class = "STANDARD_IA"
            },
            {
              days          = 360
              storage_class = "GLACIER"
            }
          ]

          expiration = {
            days = 600
          }
        }
      ]
    }
  }
}