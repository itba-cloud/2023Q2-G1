locals {
  apigw_id   = "${var.apigw_stage}_${var.apigw_path}"
  apigw_name = replace(var.apigw_url, "/^https?://([^/]*).*/", "$1")
}