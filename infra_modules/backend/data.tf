locals {
  ## Cluster ##
  cluster_name = "cluster-${var.app_name}-${var.env}"

  ## Service ##
  service_name = "service-${var.app_name}-${var.env}"

  ## Task ##
  container_name = "container-${var.app_name}-${var.env}"

  ecs_tags = merge(var.tags, tomap({
    "Name" = local.cluster_name
  }))

  // DB
  db_identifier = "db-${var.app_name}-${var.env}"
  db_name = "${var.app_name}"

  db_tags = merge(var.tags, tomap({
    "Name" = local.db_identifier
  }))

  // DB Subnet Group
  db_subnet_group_name = "dbsg-${var.app_name}-${var.env}"

  // S3 Bucket
  s3_bucket_tags = merge(var.tags, tomap({
    "Name" = "s3-bucket"
  }))

  bucket_name = "${var.app_name}-${var.env}-${random_string.suffix.result}"

  // KMS Key
  kms_key_tags = merge(var.tags, tomap({
    "Name" = "kms-key"
  }))

  // SSM Parameter
  ssm_parameter_tags = merge(var.tags, tomap({
    "Name" = "ssm-parameter"
  }))

  db_password_name = "/${var.app_name}/${var.env}/db/password"
  db_username_name = "/${var.app_name}/${var.env}/db/username"
  db_name_name = "/${var.app_name}/${var.env}/db/name"
  db_port_name = "/${var.app_name}/${var.env}/db/port"
  db_host_name = "/${var.app_name}/${var.env}/db/host"
  s3_bucket_name = "/${var.app_name}/${var.env}/s3/bucket"

  // IAM
  iam_tags = merge(var.tags, tomap({
    "Name" = "iam"
  }))
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}