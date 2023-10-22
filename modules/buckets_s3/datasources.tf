
data "aws_iam_policy_document" "allow_read_access" {
  count = var.bucket_policy_read ? 1 : 0

  statement {
    actions = var.actions

    resources = [
      module.aws_bucket.s3_bucket_arn,
      "${module.aws_bucket.s3_bucket_arn}/*",
    ]

    dynamic "principals" {
      for_each = var.bucket_access_OAI
      content {
        type        = "AWS"
        identifiers = [principals.value]
      }
    }

    dynamic "condition" {
      for_each = var.vpc_ids
      content {
        values   = [condition.value]
        test     = "StringEquals"
        variable = "aws:SourceVpce"
      }
    }
  }
}
