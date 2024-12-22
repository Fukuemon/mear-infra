module "network" {
  ## VPC
  source = "../../../infra_modules/network"
  name = local.vpc_name
  cidr = var.cidr

  public_subnets  = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  ## Route53
  domain_name = var.domain_name


  ### Common tag metadata
  azs      = var.azs
  tags     = local.tags
  env      = var.env
  app_name = var.app_name
  region   = var.region
}

module "backend" {
  source = "../../../infra_modules/backend"

  ## ECS
  fargate_capacity_providers = var.fargate_capacity_providers

  ecs_service = var.ecs_service
  ecs_task = var.ecs_task
  app_container_image = var.app_container_image
  enable_cloudwatch_logging = var.enable_cloudwatch_logging

  private_sg_ids = [module.network.private_security_group_id]
  subnet_ids = module.network.private_subnets

  create_cloudwatch_log_group = var.create_cloudwatch_log_group

  create_task_exec_iam_role = var.create_task_exec_iam_role

  alb_target_group_arn = module.network.target_groups[module.network.target_group_key].arn

  ## DB
  db_engine = var.db_engine
  db_engine_version = var.db_engine_version
  db_instance_class = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  db_username = var.db_username
  db_password = var.db_password
  db_port = var.db_port
  db_family = var.db_family
  maintenance_window = var.maintenance_window
  backup_window = var.backup_window

  db_security_group_id = module.network.database_security_group_id
  db_subnet_ids = module.network.database_subnets
  db_subnet_group_name = module.network.database_subnet_group_name

  ## S3
  acl = var.acl

  ### Common tag metadata
  app_name = var.app_name
  env = var.env
  tags = local.tags

  depends_on = [ module.network ]
}