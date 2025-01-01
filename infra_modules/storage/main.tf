###########################################
# S3
############################################
module "s3" {
  source = "../../resource_modules/storage/s3"

  # バケット名の設定
  bucket = local.bucket_name

  # バケット作成の有効化
  create_bucket = true

  # ACLの無効化とオブジェクト所有権の管理
  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  # パブリックアクセス制限の解除
  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false

  # バケットポリシーの設定
  attach_policy = true
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowPublicReadAccess",
        Effect    = "Allow",
        Principal = "*", # public
        Action    = [
          "s3:GetObject" # オブジェクトの閲覧を許可
        ],
        Resource = [
          "arn:aws:s3:::${local.bucket_name}/*" # バケット内の全オブジェクトを指定
        ]
      }
    ]
  })

  cors_rule = [
    {
      allowed_headers = ["*"]
      allowed_methods = [
        "HEAD",
        "GET",
        "PUT",
        "POST",
        "DELETE"
      ]
      allowed_origins = ["*"]
      max_age_seconds = 3000
    }
  ]

  # タグの設定
  tags = local.s3_bucket_tags
}