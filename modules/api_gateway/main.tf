#REST API
resource "aws_api_gateway_rest_api" "this" {
  name        = var.api_gateway_rest_api_info.name
  description = var.api_gateway_rest_api_info.description

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    Name = var.api_gateway_rest_api_info.name
  }
}

#Resources

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "api"
}

resource "aws_api_gateway_resource" "this" {
  for_each    = var.api_gateway_resources
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.root.id
  path_part   = each.value.path_part
}

#Methods
resource "aws_api_gateway_method" "this" {
  for_each      = var.api_gateway_methods
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this[each.value.resource].id
  http_method   = each.value.method
  authorization = each.value.authorization
}

#Integrations
resource "aws_api_gateway_integration" "this" {
  for_each                = var.api_gateway_methods
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.this[each.value.resource].id
  http_method             = aws_api_gateway_method.this[each.key].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_functions_invoke_arn[each.key]
}

#Deployment
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.this,
      aws_api_gateway_method.this,
      aws_api_gateway_integration.this,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}


#Stage
resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.api_gateway_rest_api_info.stage_name

  tags = {
    Name = var.api_gateway_rest_api_info.stage_name
  }

}









