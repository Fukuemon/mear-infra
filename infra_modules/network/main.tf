module "vpc" {
  source = "../../resource_modules/network/vpc/"

  name = var.name
  cidr = var.cidr

  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets = var.private_subnets
  database_subnets = var.database_subnets

  tags = var.tags

  # DMS
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  // Nat Gateway
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  create_igw = true
}

module "vpc_endpoints" {
  source = "../../resource_modules/network/vpc/modules/vpc-endpoints/"

  vpc_id = module.vpc.vpc_id

  create_security_group      = true
  security_group_name_prefix = local.vpc_endpoint_security_group_name_prefix
  security_group_rules = {
    ingress_https = {
      description = "HTTPS from VPC"
      cidr_blocks = [module.vpc.vpc_cidr_block]
    }
  }

  # VPCエンドポイントの設定
  endpoints = {
    s3 = {
      service             = "s3"
      service_type        = "Gateway"  # Gateway型に変更
      route_table_ids     = module.vpc.private_route_table_ids  # ルートテーブルIDを指定
      tags                = { Name = "s3-vpc-endpoint" }
    },
    ecs = {
      service             = "ecs"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "ecs-vpc-endpoint" }
    },
    ecs_telemetry = {
      service             = "ecs-telemetry"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "ecs-telemetry-vpc-endpoint" }
    },
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "ecr-api-vpc-endpoint" }
    },
    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "ecr-dkr-vpc-endpoint" }
    },
    ssmmessages = {
      service             = "ssmmessages"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "ssmmessages-vpc-endpoint" }
    },
    logs = {
      service             = "logs"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "logs-vpc-endpoint" }
    },
    ssm = {
      service             = "ssm"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "ssm-vpc-endpoint" }
    },
    kms = {
      service             = "kms"
      private_dns_enabled = true
      subnet_ids          = module.vpc.private_subnets
      tags                = { Name = "kms-vpc-endpoint" }
    }
  }

  tags = local.vpc_endpoint_tags
}

module "public_security_group" {
  source = "../../resource_modules/security/security_group"

  name        = local.public_security_group_name
  description = local.public_security_group_description
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["http-80-tcp", "https-443-tcp"] # ref: https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/examples/complete/main.tf#L44
  ingress_cidr_blocks = ["0.0.0.0/0"]

  # allow all egress
  egress_rules = ["all-all"]
  tags         = local.public_security_group_tags
}

module "private_security_group" {
  source = "../../resource_modules/security/security_group"

  name        = local.private_security_group_name
  description = local.private_security_group_description
  vpc_id      = module.vpc.vpc_id

  // セキュリティグループ内部からの特定プロトコル/ポートを許可
  ingress_with_self = [
    {
      rule        = "http-80-tcp"
      description = "Allow HTTP traffic within the same security group"
    },
    {
      rule        = "https-443-tcp"
      description = "Allow HTTPS traffic within the same security group"
    }
  ]

  // 外部通信は必要なサービスやCIDRに限定
  egress_rules = ["https-443-tcp"]

  tags = local.private_security_group_tags
}


module "database_security_group" {
  source = "../../resource_modules/security/security_group"

  name        = local.db_security_group_name
  description = local.db_security_group_description
  vpc_id      = module.vpc.vpc_id

  # Open for self (rule or from_port+to_port+protocol+description)
  ingress_with_self = [
    {
      rule        = "all-all"
      description = "Self"
    },
  ]

  egress_rules = ["all-all"]
  tags         = local.db_security_group_tags
}

module "alb" {
  source = "../../resource_modules/network/alb"

  name    = var.name
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets
  tags    = var.tags

  security_group_ingress_rules = {
    all_http = {
      description = "Allow all HTTP traffic"
      from_port   = 80
      to_port     = 80
      ip_protocol    = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      description = "Allow all HTTPS traffic"
      from_port   = 443
      to_port     = 443
      ip_protocol    = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }

  listeners = {
    ex-http-https-redirect = {
      port = 80
      protocol = "HTTP"
      redirect = {
        port = 443
        protocol = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    ex-https = {
      port = 443
      protocol = "HTTPS"
      certificate_arn = module.acm.acm_certificate_arn

      forward = {
        target_group_key = local.target_group_key
      }
    }
  }

  target_groups = {
    (local.target_group_key) = {
      protocol = "HTTP"
      port = 8000
      target_type = "ip"
      vpc_id = module.vpc.vpc_id
      health_check = {
        path = "/"
        port = "traffic-port"
        protocol = "HTTP"
        timeout = 5
        interval = 30
      }
      create_attachment = false
    }
  }

  route53_records = {
    A = {
      name = local.route53_record_name_a
      type = "A"
      zone_id = data.aws_route53_zone.this.id
      alias = {
        name = local.route53_record_name_a
        type = "A"
        zone_id = data.aws_route53_zone.this.id
      }
    }
  }
}

module "acm" {
  source = "../../resource_modules/security/acm"

  domain_name = var.domain_name
  zone_id     = data.aws_route53_zone.this.id
  validation_method = "DNS"

  tags        = var.tags
}