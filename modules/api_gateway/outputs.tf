output "rest_api" {
  description = "REST API info"
  value = {
    id            = aws_api_gateway_rest_api.this.id
    arn           = aws_api_gateway_rest_api.this.arn
    invoke_url    = aws_api_gateway_stage.this.invoke_url
    execution_arn = aws_api_gateway_rest_api.this.execution_arn
  }
}
