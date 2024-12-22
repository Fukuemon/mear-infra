locals {
  public_subnet_tags = {
    "Tier" = "public"
  }

  private_subnet_tags = {
    "Tier" = "private"
  }

  database_subnet_tags = {
    "Tier" = "database"
  }

  ## VPC Endpoint Tags
  vpc_endpoint_security_group_name_prefix = "scg-${var.region_tag[var.region]}-${var.env}-vpc-endpoint"
  vpc_endpoint_tags = merge(var.tags, tomap({
    "Name" = "vpc-endpoint"
  }))

  ## Public SG ##
  public_security_group_name        = "scg-${var.region_tag[var.region]}-${var.app_name}-${var.env}-public"
  public_security_group_description = "Security group for public subnets"
  public_security_group_tags = merge(
    var.tags,
    tomap({
      "Name" = local.public_security_group_name
    }),
    tomap({
      "Tier" = "public"
    }),
  )

  ## Private SG ##
  private_security_group_name        = "scg-${var.region_tag[var.region]}-${var.app_name}-${var.env}-private"
  private_security_group_description = "Security group for private subnets"
  private_security_group_tags = merge(
    var.tags,
    tomap({
      "Name" = local.private_security_group_name
    }),
    tomap({
      "Tier" = "private"
    }),
  )


  ## DB SG ##
  db_security_group_name        = "scg-${var.region_tag[var.region]}-${var.app_name}-${var.env}-database"
  db_security_group_description = "Security group for database subnets"
  db_security_group_tags = merge(
    var.tags,
    tomap({
      "Name" = local.db_security_group_name
    }),
    tomap({
      "Tier" = "database"
    }),
  )

  ## ALB ##
  target_group_key = "alb-${var.region_tag[var.region]}-${var.env}-${var.app_name}"

  ## Route53 Record ##
  route53_record_name_a = "api.${var.domain_name}"
}

data "aws_route53_zone" "this" {
  name = var.domain_name
}
