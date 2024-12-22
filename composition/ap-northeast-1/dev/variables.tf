############################################
# Metadata
############################################
variable "env" {
  description = "開発環境"
  type        = string
}

variable "app_name" {
  description = "アプリケーション名"
  type        = string
}

variable "region" {
  description = "リージョン"
  type        = string
}

variable "region_tag" {
  type = map(string)

  default = {
    "us-east-1"      = "ue1"
    "us-west-1"      = "uw1"
    "eu-west-1"      = "ew1"
    "eu-central-1"   = "ec1"
    "ap-northeast-1" = "apne1"
  }
}

############################################
# VPC
############################################
variable "cidr" {
  description = "The CIDR block for the  Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = ""
}

variable "azs" {
  description = "Number of availability zones to use in the region"
  type        = list(string)
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  default     = []
}

variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  default     = []
}

variable "enable_dns_hostnames" {
  description = "value to enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "value to enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}
variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

############################################
# Route53
############################################
variable "domain_name" {
  description = "The domain name for the Route 53 Hosted Zone"
  type        = string
  default     = ""
}

############################################
# ALB
############################################

################################################################################
# ECS Cluster
################################################################################


################################################################################
# Capacity Providers
################################################################################

variable "default_capacity_provider_use_fargate" {
  description = "Determines whether to use Fargate or autoscaling for default capacity provider strategy"
  type        = bool
  default     = true
}

variable "fargate_capacity_providers" {
  description = "ECS Cluster"
  type = object({
    fargate_weight      = number
    fargate_spot_weight = number
  })
  default = {
    fargate_weight      = 1
    fargate_spot_weight = 1
  }
}

################################################################################
# ECS Service
################################################################################

variable "alb_target_group_arn" {
  description = "ARN of the target group to associate with the ECS service"
  type        = string
  default     = ""
}

variable "ecs_service" {
  description = "ECS Service"
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 256
    memory = 512
  }
}


################################################################################
# ECS Task Definition
################################################################################

variable "ecs_task" {
  description = "ECS Task Definition"
  type = object({
    cpu    = number
    memory = number
    port   = number
  })
  default = {
    cpu    = 256
    memory = 512
    port   = 8000
  }
}

variable "app_container_image" {
  description = "Container image"
  type        = string
}

variable "enable_cloudwatch_logging" {
  description = "Enable CloudWatch logging"
  type        = bool
  default     = false
}

################################################################################
# ECS Service - Network Configuration
################################################################################


################################################################################
# CloudWatch Log Group
################################################################################

variable "create_cloudwatch_log_group" {
  description = "Determines whether a log group is created by this module for the cluster logs. If not, AWS will automatically create one if logging is enabled"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_name" {
  description = "Custom name of CloudWatch Log Group for ECS cluster"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events"
  type        = number
  default     = 90
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "If a KMS Key ARN is set, this key will be used to encrypt the corresponding log group. Please be sure that the KMS Key has an appropriate key policy (https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html)"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_tags" {
  description = "A map of additional tags to add to the log group created"
  type        = map(string)
  default     = {}
}

################################################################################
# Task Execution - IAM Role
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
################################################################################

variable "create_task_exec_iam_role" {
  description = "Determines whether the ECS task definition IAM role should be created"
  type        = bool
  default     = false
}


variable "create_task_exec_policy" {
  description = "Determines whether the ECS task definition IAM policy should be created. This includes permissions included in AmazonECSTaskExecutionRolePolicy as well as access to secrets and SSM parameters"
  type        = bool
  default     = true
}

variable "task_exec_iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}

variable "task_exec_iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name (`task_exec_iam_role_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "task_exec_iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "task_exec_iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "task_exec_iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "task_exec_iam_role_tags" {
  description = "A map of additional tags to add to the IAM role created"
  type        = map(string)
  default     = {}
}

variable "task_exec_iam_role_policies" {
  description = "Map of IAM role policy ARNs to attach to the IAM role"
  type        = map(string)
  default     = {}
}


################################################################################
# Database
################################################################################

variable "db_engine" {
  description = "Database engine type"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "12.5"
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Database allocated storage"
  type        = number
  default     = 20
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = ""
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "db_family" {
  description = "Database family"
  type        = string
  default     = "postgres12"
}

variable "iam_database_authentication_enabled" {
  description = "Determines whether IAM database authentication should be enabled"
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
  default     = "Mon:00:00-Mon:01:00"
}

variable "backup_window" {
  description = "The window to perform backups in"
  type        = string
  default     = "03:00-04:00"
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch"
  type        = list(string)
  default     = ["error", "general", "slowquery"]
}

variable "db_create_cloudwatch_log_group" {
  description = "Determines whether a log group is created by this module for the database logs. If not, AWS will automatically create one if logging is enabled"
  type        = bool
  default     = true
}

################################################################################
# S3 Bucket
################################################################################
variable "acl" {
  description = "The canned ACL to apply. Defaults to 'private'"
  type        = string
  default     = "public"
}