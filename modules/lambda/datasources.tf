data "archive_file" "lambda_package" {
  count       = length(var.lambda_functions_source_files)
  type        = "zip"
  source_file = var.lambda_functions_source_files[count.index].source_path
  output_path = var.lambda_functions_source_files[count.index].output_path
}