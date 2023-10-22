module "aws_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws" #external module
  bucket_prefix = var.bucket_name

  tags = {
    Name : var.bucket_name
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule = var.lifecycle_rule

}

resource "aws_s3_bucket_logging" "this" {
  count         = var.logs == "" ? 0 : 1
  bucket        = var.logs
  target_bucket = module.aws_bucket.s3_bucket_id
  target_prefix = "log/"
}

resource "aws_s3_object" "this" {
  count        = length(var.objects)
  bucket       = module.aws_bucket.s3_bucket_id
  key          = var.objects[count.index].key
  source       = var.objects[count.index].source
  content_type = var.objects[count.index].content_type
}
resource "aws_s3_bucket_policy" "read_access_policy" {
  count = var.bucket_policy_read ? 1 : 0

  bucket = module.aws_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.allow_read_access[count.index].json
}
resource "aws_s3_bucket_versioning" "this" {
  count  = var.versioning == "" ? 0 : 1
  bucket = module.aws_bucket.s3_bucket_id
  versioning_configuration {
    status = var.versioning
  }
}
resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.redirect_all_requests_to == null ? 0 : 1
  bucket = module.aws_bucket.s3_bucket_id

  redirect_all_requests_to {
    host_name = var.bucket_name
    protocol  = var.redirect_all_requests_to.protocol
  }
}




