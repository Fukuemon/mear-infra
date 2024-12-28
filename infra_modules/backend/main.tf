############################################
# ECS（Cluster, Service, Task）
############################################
module "ecs" {
  source = "../../resource_modules/compute/ecs"

  cluster_name = local.cluster_name

  // cloudwatch log groupを作成するかどうか
  create_cloudwatch_log_group = var.create_cloudwatch_log_group

  // fargate capacity providers
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = var.fargate_capacity_providers.fargate_weight
      }
      FARGATE_SPOT = {
        default_capacity_provider_strategy = {
          weight = var.fargate_capacity_providers.fargate_spot_weight
        }
      }
    }
  }

  // services
  services = {
    (local.service_name) = {
      cpu    = var.ecs_service.cpu
      memory = var.ecs_service.memory

      // タスク定義
      container_definitions = {
        (local.container_name) = {
          cpu    = var.app_task.cpu
          memory = var.app_task.memory
          image  = var.app_container_image
          readonly_root_filesystem = false
          port_mappings = [
            {
              name          = local.container_name
              containerPort = var.app_task.port
              hostPort      = var.app_task.port
              protocol      = "tcp"
            }
          ]
          enable_cloudwatch_logging = var.enable_cloudwatch_logging

          // 環境変数
          environment = [
            {
              name = "PORT"
              value = var.app_task.port
            },
            {
              name = "DEBUG"
              value = "false"
            },
            {
              name = "AWS_S3_REGION_NAME"
              value = data.aws_region.current.name
            }
          ]
          secrets = [
            {
              name = "CORS_ALLOWED_ORIGINS"
              valueFrom = aws_ssm_parameter.cors_allowed_origins.name
            },
            {
              name = "DJANGO_SUPERUSER_EMAIL"
              valueFrom = aws_ssm_parameter.app_admin_email.name
            },
            {
              name = "DJANGO_SUPERUSER_PASSWORD"
              valueFrom = aws_ssm_parameter.app_admin_password.name
            },
            {
              name = "DB_ENGINE"
              valueFrom = aws_ssm_parameter.db_engine.name
            },
            {
              name = "DB_HOST"
              valueFrom = aws_ssm_parameter.db_host.name
            },
            {
              name = "DB_PORT"
              valueFrom = aws_ssm_parameter.db_port.name
            },
            {
              name = "DB_NAME"
              valueFrom = aws_ssm_parameter.db_name.name
            },
            {
              name = "DB_USER"
              valueFrom = aws_ssm_parameter.db_username.name
            },
            {
              name = "DB_PASSWORD"
              valueFrom = aws_ssm_parameter.db_password.name
            },
            {
              name = "AWS_STORAGE_BUCKET_NAME"
              valueFrom = aws_ssm_parameter.s3_bucket_name.name
            },
            {
              name = "AWS_ACCESS_KEY_ID"
              valueFrom = aws_ssm_parameter.access_key_id.name
            },
            {
              name = "AWS_SECRET_ACCESS_KEY"
              valueFrom = aws_ssm_parameter.secret_access_key.name
            },
          ]
        }
        nginx = {
          cpu    = var.nginx_task.cpu
          memory = var.nginx_task.memory
          image  = var.nginx_container_image
          readonly_root_filesystem = false
          port_mappings = [
            {
              name          = "nginx"
              containerPort = var.nginx_task.port
              hostPort      = var.nginx_task.port
              protocol      = "tcp"
            }
          ]
          environment = [
            {
              name = "APP_PORT"
              value = var.app_task.port
            },
            {
              name = "APP_HOST"
              value = "127.0.0.1"
            }
          ]
          enable_cloudwatch_logging = var.enable_cloudwatch_logging
        }
      }

      load_balancer = {
        service = {
          target_group_arn = var.alb_target_group_arn
          container_name    = "nginx"
          container_port    = var.nginx_task.port
        }
      }

      network_configuration = {
        security_groups  = var.private_sg_ids
        subnets          = var.subnet_ids
      }
      subnet_ids = var.subnet_ids

      // タスク実行ロール
      create_task_exec_iam_role = var.create_task_exec_iam_role
      create_task_exec_policy = var.create_task_exec_policy
      task_exec_iam_role_name        = "${var.app_name}-task-exec"
      task_exec_ssm_param_arns = [
        aws_ssm_parameter.db_host.arn,
        aws_ssm_parameter.db_port.arn,
        aws_ssm_parameter.db_name.arn,
        aws_ssm_parameter.db_username.arn,
        aws_ssm_parameter.db_password.arn,
        aws_ssm_parameter.s3_bucket_name.arn,
        aws_ssm_parameter.access_key_id.arn,
        aws_ssm_parameter.secret_access_key.arn,
        aws_ssm_parameter.app_admin_email.arn,
        aws_ssm_parameter.app_admin_password.arn,
        aws_ssm_parameter.db_engine.arn,
        aws_ssm_parameter.cors_allowed_origins.arn
      ]

      task_exec_iam_role_policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
      // タスクロール
      tasks_iam_role_name        = "${var.app_name}-tasks"
      tasks_iam_role_description = "tasks IAM role for ${var.app_name}"
      tasks_iam_role_arn        = module.ecs.task_exec_iam_role_arn
      tasks_iam_role_policies = {
        ReadOnlyAccess = "arn:aws:iam::aws:policy/ReadOnlyAccess"
      }
      tasks_iam_role_statements = [
        {
          actions   = ["s3:List*"]
          resources = ["arn:aws:s3:::*"]
        }
      ]
      create_security_group = false
      security_group_ids = var.private_sg_ids
    }
  }

  create_task_exec_iam_role = var.create_task_exec_iam_role
  task_exec_ssm_param_arns = [
    aws_ssm_parameter.db_host.arn,
    aws_ssm_parameter.db_port.arn,
    aws_ssm_parameter.db_name.arn,
    aws_ssm_parameter.db_username.arn,
    aws_ssm_parameter.db_password.arn,
    aws_ssm_parameter.s3_bucket_name.arn,
    aws_ssm_parameter.access_key_id.arn,
    aws_ssm_parameter.secret_access_key.arn,
    aws_ssm_parameter.app_admin_email.arn,
    aws_ssm_parameter.app_admin_password.arn,
    aws_ssm_parameter.db_engine.arn,
    aws_ssm_parameter.cors_allowed_origins.arn
  ]
  task_exec_iam_role_policies = {
    execution_policy     = aws_iam_policy.ecs_task_execution_policy.arn
  }
  tags = local.ecs_tags
}

############################################
# RDS
############################################
module "db" {
  source = "../../resource_modules/database/rds"

  identifier = local.db_identifier

  engine = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  allocated_storage = var.db_allocated_storage

  manage_master_user_password = false
  db_name = local.db_name
  username = var.db_username
  password = var.db_password
  port = var.db_port

  family = var.db_family

  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  maintenance_window              = var.maintenance_window
  backup_window                   = var.backup_window
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  create_cloudwatch_log_group     = var.db_create_cloudwatch_log_group

  db_subnet_ids = var.db_subnet_ids
  vpc_security_group_ids = [var.db_security_group_id]
  db_subnet_group_name = var.db_subnet_group_name
  tags = local.db_tags
}

###########################################
# KMS
###########################################

resource "aws_kms_key" "this" {
  description             = "KMS key for SSM Parameter Store encryption"
  deletion_window_in_days = 10

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-default-1",
    Statement = [
      # IAM User Permissions (Root User)
      {
        Sid    = "EnableIAMUserPermissions",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*",
        Resource = ["*"]
      },
      # Developer Access
      {
        Sid    = "DeveloperAccess",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.app_name}_developer"
        },
        Action = [
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext"
        ],
        Resource = ["*"]
      },
      # ECS Task Role Access
      {
        Sid    = "EcsTaskAccess",
        Effect = "Allow",
        Principal = {
          AWS = module.ecs.task_exec_iam_role_arn
        },
        Action = [
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext"
        ],
        Resource = ["*"]
      }
    ]
  })

  tags = local.kms_key_tags
}


resource "aws_iam_policy" "ecs_task_execution_policy" {
  name        = "ecs-task-execution-policy"
  description = "Policy to allow ECS Task to access necessary resources"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # KMS & SSMアクセス
      {
        Effect   = "Allow",
        Action   = [
          "kms:Decrypt",
        ],
        Resource = "*"
      },
      # ECRアクセス
      {
        Effect   = "Allow",
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ],
        Resource = "*"
      },
      # CloudWatch Logsアクセス
      {
        Effect   = "Allow",
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      # SSMアクセス
      {
        Effect   = "Allow",
        Action   = [
        "ssm:GetParameters",
        ],
        Resource = "*"
      }
    ]
  })
}

############################################
# SSM Parameter - DB
############################################

resource "aws_ssm_parameter" "cors_allowed_origins" {
  name  = local.cors_allowed_origins_name
  type  = "SecureString"
  value =  var.cors_allowed_origins
  key_id = aws_kms_key.this.key_id
  tags = local.ssm_parameter_tags
}

resource "aws_ssm_parameter" "db_engine" {
  name  = local.db_engine_name
  type  = "String"
  value = var.app_db_engine
  key_id = aws_kms_key.this.key_id
  tags = local.ssm_parameter_tags
}
resource "aws_ssm_parameter" "db_password" {
  name  = local.db_password_name
  type  = "SecureString"
  value = var.db_password
  key_id = aws_kms_key.this.key_id
  tags = local.ssm_parameter_tags
}

resource "aws_ssm_parameter" "db_host" {
  name  = local.db_host_name
  type  = "String"
  value = split(":", module.db.db_instance_endpoint)[0]
  key_id = aws_kms_key.this.key_id
  tags = local.ssm_parameter_tags
}

resource "aws_ssm_parameter" "db_port" {
  name  = local.db_port_name
  type  = "String"
  value = module.db.db_instance_port
  key_id = aws_kms_key.this.key_id
  tags = local.ssm_parameter_tags
}

resource "aws_ssm_parameter" "db_name" {
  name  = local.db_name_name
  type  = "String"
  value = module.db.db_instance_name
  key_id = aws_kms_key.this.key_id
  tags = local.ssm_parameter_tags
}

resource "aws_ssm_parameter" "db_username" {
  name  = local.db_username_name
  type  = "String"
  value = module.db.db_instance_username
  key_id = aws_kms_key.this.key_id
  tags = local.ssm_parameter_tags
}

resource "aws_ssm_parameter" "app_admin_email" {
  name  = local.app_admin_email_name
  type  = "String"
  value = var.app_admin_email
  key_id = aws_kms_key.this.key_id
  tags = local.ssm_parameter_tags
}

resource "aws_ssm_parameter" "app_admin_password" {
  name  = local.app_admin_password_name
  type  = "SecureString"
  value = var.app_admin_password
  key_id = aws_kms_key.this.key_id
  tags = local.ssm_parameter_tags
}

############################################
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

############################################
# SSM Parameter - S3
############################################
resource "aws_ssm_parameter" "s3_bucket_name" {
  name  = local.s3_bucket_name
  type  = "String"
  value = local.bucket_name
  tags = local.ssm_parameter_tags
}

############################################
# IAM
############################################
resource "aws_iam_user" "s3_user" {
  name = "s3_access_user"
  tags = local.iam_tags
}

# ポリシーをアタッチ
resource "aws_iam_user_policy" "s3_access_policy" {
  name = "s3_access_policy"
  user = aws_iam_user.s3_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = [
          "arn:aws:s3:::${local.bucket_name}",
          "arn:aws:s3:::${local.bucket_name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_access_key" "s3_access_key" {
  user    = aws_iam_user.s3_user.name
  depends_on = [aws_iam_user_policy.s3_access_policy]
}

############################################
# SSM Parameter - IAM
############################################
resource "aws_ssm_parameter" "access_key_id" {
  name  = "/application/s3_access_key_id"
  type  = "SecureString"
  value = aws_iam_access_key.s3_access_key.id
  key_id = aws_kms_key.this.key_id
  tags = local.ssm_parameter_tags
}

resource "aws_ssm_parameter" "secret_access_key" {
  name  = "/application/s3_secret_access_key"
  type  = "SecureString"
  value = aws_iam_access_key.s3_access_key.secret
  key_id = aws_kms_key.this.key_id
  tags = local.ssm_parameter_tags
}
