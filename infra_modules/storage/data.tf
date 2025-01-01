locals {
  s3_bucket_tags = merge(var.tags, tomap({
      "Name" = "s3-bucket"
    }))

  bucket_name = "${var.app_name}-${var.env}-media"
}
