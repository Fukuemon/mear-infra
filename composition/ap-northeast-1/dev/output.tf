############################################
## VPC
############################################
output "vpc_id" {
  value = module.network.vpc_id
}

output "vpc_cidr_block" {
  value = module.network.vpc_cidr_block
}

output "vpc_enable_dns_support" {
  value = module.network.vpc_enable_dns_support
}

output "vpc_enable_dns_hostnames" {
  value = module.network.vpc_enable_dns_hostnames
}

output "vpc_main_route_table_id" {
  value = module.network.vpc_main_route_table_id
}

output "private_subnets" {
  value = module.network.private_subnets
}

output "private_subnets_cidr_blocks" {
  value = module.network.private_subnets_cidr_blocks
}

output "public_subnets" {
  value = module.network.public_subnets
}

output "public_route_table_ids" {
  value = module.network.public_route_table_ids
}

output "database_subnets" {
  value = module.network.database_subnets
}

output "database_subnet_arns" {
  value = module.network.database_subnet_arns
}

output "database_subnets_cidr_blocks" {
  value = module.network.database_subnets_cidr_blocks
}

output "database_route_table_ids" {
  value = module.network.database_route_table_ids
}

output "database_subnet_group" {
  value = module.network.database_subnet_group
}

## Private Security Group ##
output "private_security_group_id" {
  value = module.network.private_security_group_id
}

output "private_security_group_vpc_id" {
  value = module.network.private_security_group_vpc_id
}

output "private_security_group_owner_id" {
  value = module.network.private_security_group_owner_id
}

output "private_security_group_name" {
  value = module.network.private_security_group_name
}

## Database Security Group ##
output "database_security_group_id" {
  value = module.network.database_security_group_id
}

output "database_security_group_vpc_id" {
  value = module.network.database_security_group_vpc_id
}

output "database_security_group_owner_id" {
  value = module.network.database_security_group_owner_id
}


################################################################################
# Load Balancer
################################################################################

output "lb_id" {
  description = "The ID and ARN of the load balancer we created"
  value       = try(module.network.lb_id, null)
}

output "lb_arn" {
  description = "The ID and ARN of the load balancer we created"
  value       = try(module.network.lb_arn, null)
}

output "lb_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch"
  value       = try(module.network.lb_arn_suffix, null)
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = try(module.network.lb_dns_name, null)
}

output "lb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = try(module.network.lb_zone_id, null)
}

################################################################################
# Listener(s)
################################################################################

output "listeners" {
  description = "Map of listeners created and their attributes"
  value       = module.network.listeners
}

output "listener_rules" {
  description = "Map of listeners rules created and their attributes"
  value       = module.network.listener_rules
}

################################################################################
# Target Group(s)
################################################################################

output "target_groups" {
  description = "Map of target groups created and their attributes"
  value       = module.network.target_groups
}

################################################################################
# Security Group
################################################################################

output "security_group_arn" {
  description = "Amazon Resource Name (ARN) of the security group"
  value       = try(module.network.security_group_arn, null)
}

output "security_group_id" {
  description = "ID of the security group"
  value       = try(module.network.security_group_id, null)
}

################################################################################
# Route53 Record(s)
################################################################################

output "route53_records" {
  description = "The Route53 records created and attached to the load balancer"
  value       = module.network.route53_records
}

################################################################################
# ACM
################################################################################
output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = try(module.network.acm_certificate_arn, "")
}

output "acm_certificate_domain_validation_options" {
  description = "A list of attributes to feed into other resources to complete certificate validation. Can have more than one element, e.g. if SANs are defined. Only set if DNS-validation was used."
  value       = flatten(module.network.acm_certificate_domain_validation_options)
}

output "acm_certificate_status" {
  description = "Status of the certificate."
  value       = try(module.network.acm_certificate_status, "")
}

output "acm_certificate_validation_emails" {
  description = "A list of addresses that received a validation E-Mail. Only set if EMAIL-validation was used."
  value       = flatten(module.network.acm_certificate_validation_emails)
}

output "validation_route53_record_fqdns" {
  description = "List of FQDNs built using the zone domain and name."
  value       = module.network.validation_route53_record_fqdns
}


################################################################################
# Cluster
################################################################################

output "cluster_arn" {
  description = "ARN that identifies the cluster"
  value       = module.backend.cluster_arn
}

output "cluster_id" {
  description = "ID that identifies the cluster"
  value       = module.backend.cluster_id
}

output "cluster_name" {
  description = "Name that identifies the cluster"
  value       = module.backend.cluster_name
}

output "cluster_cloudwatch_log_group_name" {
  description = "Name of CloudWatch log group created"
  value       = module.backend.cluster_cloudwatch_log_group_name
}

output "cluster_cloudwatch_log_group_arn" {
  description = "ARN of CloudWatch log group created"
  value       = module.backend.cluster_cloudwatch_log_group_arn
}

output "cluster_capacity_providers" {
  description = "Map of cluster capacity providers attributes"
  value       = module.backend.cluster_capacity_providers
}

output "autoscaling_capacity_providers" {
  description = "Map of autoscaling capacity providers created and their attributes"
  value       = module.backend.autoscaling_capacity_providers
}

output "task_exec_iam_role_name" {
  description = "Task execution IAM role name"
  value       = module.backend.task_exec_iam_role_name
}

output "task_exec_iam_role_arn" {
  description = "Task execution IAM role ARN"
  value       = module.backend.task_exec_iam_role_arn
}

output "task_exec_iam_role_unique_id" {
  description = "Stable and unique string identifying the task execution IAM role"
  value       = module.backend.task_exec_iam_role_unique_id
}

################################################################################
# Service(s)
################################################################################

output "services" {
  description = "Map of services created and their attributes"
  value       = module.backend.services
}

################################################################################
# Database
################################################################################

output "enhanced_monitoring_iam_role_name" {
  description = "The name of the monitoring role"
  value       = module.backend.enhanced_monitoring_iam_role_name
}

output "enhanced_monitoring_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the monitoring role"
  value       = module.backend.enhanced_monitoring_iam_role_arn
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.backend.db_instance_address
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.backend.db_instance_arn
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.backend.db_instance_availability_zone
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.backend.db_instance_endpoint
}

output "db_listener_endpoint" {
  description = "Specifies the listener connection endpoint for SQL Server Always On"
  value       = module.backend.db_listener_endpoint
}

output "db_instance_engine" {
  description = "The database engine"
  value       = module.backend.db_instance_engine
}

output "db_instance_engine_version_actual" {
  description = "The running version of the database"
  value       = module.backend.db_instance_engine_version_actual
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.backend.db_instance_hosted_zone_id
}

output "db_instance_identifier" {
  description = "The RDS instance identifier"
  value       = module.backend.db_instance_identifier
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.backend.db_instance_resource_id
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = module.backend.db_instance_status
}

output "db_instance_name" {
  description = "The database name"
  value       = module.backend.db_instance_name
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = module.backend.db_instance_username
  sensitive   = true
}

output "db_instance_domain" {
  description = "The ID of the Directory Service Active Directory domain the instance is joined to"
  value       = module.backend.db_instance_domain
}

output "db_instance_domain_auth_secret_arn" {
  description = "The ARN for the Secrets Manager secret with the self managed Active Directory credentials for the user joining the domain"
  value       = module.backend.db_instance_domain_auth_secret_arn
}

output "db_instance_domain_dns_ips" {
  description = "The IPv4 DNS IP addresses of your primary and secondary self managed Active Directory domain controllers"
  value       = module.backend.db_instance_domain_dns_ips
}

output "db_instance_domain_fqdn" {
  description = "The fully qualified domain name (FQDN) of an self managed Active Directory domain"
  value       = module.backend.db_instance_domain_fqdn
}

output "db_instance_domain_iam_role_name" {
  description = "The name of the IAM role to be used when making API calls to the Directory Service"
  value       = module.backend.db_instance_domain_iam_role_name
}

output "db_instance_domain_ou" {
  description = "The self managed Active Directory organizational unit for your DB instance to join"
  value       = module.backend.db_instance_domain_ou
}

output "db_instance_port" {
  description = "The database port"
  value       = module.backend.db_instance_port
}

output "db_instance_ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  value       = module.backend.db_instance_ca_cert_identifier
}

output "db_instance_master_user_secret_arn" {
  description = "The ARN of the master user secret (Only available when manage_master_user_password is set to true)"
  value       = module.backend.db_instance_master_user_secret_arn
}

output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = module.backend.db_subnet_group_id
}

output "db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = module.backend.db_subnet_group_arn
}

output "db_parameter_group_id" {
  description = "The db parameter group id"
  value       = module.backend.db_parameter_group_id
}

output "db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.backend.db_parameter_group_arn
}

# DB option group
output "db_option_group_id" {
  description = "The db option group id"
  value       = module.backend.db_option_group_id
}

output "db_option_group_arn" {
  description = "The ARN of the db option group"
  value       = module.backend.db_option_group_arn
}

################################################################################
# CloudWatch Log Group
################################################################################

output "db_instance_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = module.backend.db_instance_cloudwatch_log_groups
}

################################################################################
# DB Instance Role Association
################################################################################

output "db_instance_role_associations" {
  description = "A map of DB Instance Identifiers and IAM Role ARNs separated by a comma"
  value       = module.backend.db_instance_role_associations
}

################################################################################
# Managed Secret Rotation
################################################################################

output "db_instance_secretsmanager_secret_rotation_enabled" {
  description = "Specifies whether automatic rotation is enabled for the secret"
  value       = module.backend.db_instance_secretsmanager_secret_rotation_enabled
}

################################################################################
# KMS
################################################################################
output "ssm_kms_key_id" {
  description = "The ID of the KMS key"
  value       = module.backend.ssm_kms_key_id
}

output "ssm_kms_key_arn" {
  description = "The ARN of the KMS key"
  value       = module.backend.ssm_kms_key_arn
}


################################################################################
# S3
################################################################################
output "s3_bucket_id" {
  description = "The ID of the S3 bucket"
  value       = module.backend.s3_bucket_id
}

output "s3_bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = module.backend.s3_bucket_arn
}

output "s3_bucket_domain_name" {
  description = "The bucket domain name"
  value       = module.backend.s3_bucket_domain_name
}

