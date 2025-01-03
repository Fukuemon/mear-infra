############################################
## VPC
############################################
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}

output "vpc_enable_dns_support" {
  value = module.vpc.vpc_enable_dns_support
}

output "vpc_enable_dns_hostnames" {
  value = module.vpc.vpc_enable_dns_hostnames
}

output "vpc_main_route_table_id" {
  value = module.vpc.vpc_main_route_table_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "private_subnets_cidr_blocks" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "public_route_table_ids" {
  value = module.vpc.public_route_table_ids
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "database_subnet_arns" {
  value = module.vpc.database_subnet_arns
}

output "database_subnets_cidr_blocks" {
  value = module.vpc.database_subnets_cidr_blocks
}

output "database_route_table_ids" {
  value = module.vpc.database_route_table_ids
}

output "database_subnet_group" {
  value = module.vpc.database_subnet_group
}

output "database_subnet_group_name" {
  value = module.vpc.database_subnet_group_name
}

## Private Security Group ##
output "private_security_group_id" {
  value = module.private_security_group.security_group_id
}

output "private_security_group_vpc_id" {
  value = module.private_security_group.security_group_vpc_id
}

output "private_security_group_owner_id" {
  value = module.private_security_group.security_group_owner_id
}

output "private_security_group_name" {
  value = module.private_security_group.security_group_name
}

## Database Security Group ##
output "database_security_group_id" {
  value = module.database_security_group.security_group_id
}

output "database_security_group_name" {
  value = module.database_security_group.security_group_name
}

output "database_security_group_vpc_id" {
  value = module.database_security_group.security_group_vpc_id
}

output "database_security_group_owner_id" {
  value = module.database_security_group.security_group_owner_id
}
################################################################################
# Load Balancer
################################################################################

output "lb_id" {
  description = "The ID and ARN of the load balancer we created"
  value       = try(module.alb.id, null)
}

output "lb_arn" {
  description = "The ID and ARN of the load balancer we created"
  value       = try(module.alb.arn, null)
}

output "lb_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch"
  value       = try(module.alb.arn_suffix, null)
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = try(module.alb.dns_name, null)
}

output "lb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records"
  value       = try(module.alb.zone_id, null)
}

################################################################################
# Listener(s)
################################################################################

output "listeners" {
  description = "Map of listeners created and their attributes"
  value       = module.alb.listeners
}

output "listener_rules" {
  description = "Map of listeners rules created and their attributes"
  value       = module.alb.listener_rules
}

################################################################################
# Target Group(s)
################################################################################

output "target_groups" {
  description = "Map of target groups created and their attributes"
  value       = module.alb.target_groups
}

output "target_group_key" {
  description = "The key of the target group to use in the ECS service"
  value       = local.target_group_key
}

################################################################################
# Security Group
################################################################################

output "security_group_arn" {
  description = "Amazon Resource Name (ARN) of the security group"
  value       = try(module.alb.security_group_arn, null)
}

output "security_group_id" {
  description = "ID of the security group"
  value       = try(module.alb.security_group_id, null)
}

################################################################################
# Route53 Record(s)
################################################################################

output "route53_records" {
  description = "The Route53 records created and attached to the load balancer"
  value       = module.alb.route53_records
}

################################################################################
# ACM
################################################################################
output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = try(module.acm.acm_certificate_arn, "")
}

output "acm_certificate_domain_validation_options" {
  description = "A list of attributes to feed into other resources to complete certificate validation. Can have more than one element, e.g. if SANs are defined. Only set if DNS-validation was used."
  value       = flatten(module.acm.acm_certificate_domain_validation_options)
}

output "acm_certificate_status" {
  description = "Status of the certificate."
  value       = try(module.acm.acm_certificate_status, "")
}

output "acm_certificate_validation_emails" {
  description = "A list of addresses that received a validation E-Mail. Only set if EMAIL-validation was used."
  value       = flatten(module.acm.acm_certificate_validation_emails)
}

output "validation_route53_record_fqdns" {
  description = "List of FQDNs built using the zone domain and name."
  value       = module.acm.validation_route53_record_fqdns
}
