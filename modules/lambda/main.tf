##Lambda functions
resource "aws_lambda_function" "this" {
  for_each         = var.lambda_functions_attributes
  function_name    = each.value.function_name
  filename         = each.value.filename
  description      = each.value.description
  source_code_hash = each.value.source_code_hash
  role             = each.value.role
  runtime          = each.value.runtime
  handler          = each.value.handler
  timeout          = each.value.timeout

  vpc_config {
    subnet_ids         = var.vpc_subnets_ids
    security_group_ids = [aws_security_group.lambda_security_group.id]
  }


}

##Permissions to execute lambda functions in API Gateway
resource "aws_lambda_permission" "apigw_lambda" {
  for_each      = var.lambda_functions_attributes
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this[each.key].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.api_gateway_source_arn
}

resource "aws_security_group" "lambda_security_group" {
  name        = var.lambda_security_group_name
  description = var.lambda_security_group_description
  vpc_id      = var.vpc_id
}


resource "aws_security_group_rule" "ingress_rule" {
  security_group_id = aws_security_group.lambda_security_group.id
  type              = "ingress"

  cidr_blocks = var.lambda_security_group_cidr_blocks
  from_port   = 443
  protocol    = "tcp"
  to_port     = 443
}

resource "aws_security_group_rule" "egress_rule" {
  security_group_id = aws_security_group.lambda_security_group.id
  type              = "egress"

  cidr_blocks = var.lambda_security_group_cidr_blocks
  from_port   = 0
  protocol    = "-1"
  to_port     = 0
}