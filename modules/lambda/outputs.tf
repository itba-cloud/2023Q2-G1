output "lambda_functions_invoke_arn" {
  description = "Invoke arn of the corresponding lambda functions"
  value       = { for key, lambda_function in aws_lambda_function.this : key => lambda_function.invoke_arn }
}