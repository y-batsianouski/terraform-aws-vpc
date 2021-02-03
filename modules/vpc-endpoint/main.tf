locals {
  endpoints = {
    "access-analyzer" = {
      service           = "access-analyzer",
      name_suffix       = "access-analyzer",
      vpc_endpoint_type = "Interface"
    }
    "acm-pca" = {
      service           = "acm-pca",
      name_suffix       = "acm-pca",
      vpc_endpoint_type = "Interface"
    }
    "appmesh-envoy-management" = {
      service           = "appmesh-envoy-management",
      name_suffix       = "appmesh-envoy-management",
      vpc_endpoint_type = "Interface"
    }
    "appstream" = {
      service           = "appstream",
      name_suffix       = "appstream",
      vpc_endpoint_type = "Interface"
    }
    "athena" = {
      service           = "athena",
      name_suffix       = "athena",
      vpc_endpoint_type = "Interface"
    }
    "autoscaling-plans" = {
      service           = "autoscaling-plans",
      name_suffix       = "autoscaling-plans",
      vpc_endpoint_type = "Interface"
    }
    "autoscaling" = {
      service           = "autoscaling",
      name_suffix       = "autoscaling",
      vpc_endpoint_type = "Interface"
    }
    "clouddirectory" = {
      service           = "clouddirectory",
      name_suffix       = "clouddirectory",
      vpc_endpoint_type = "Interface"
    }
    "cloudformation" = {
      service           = "cloudformation",
      name_suffix       = "cloudformation",
      vpc_endpoint_type = "Interface"
    }
    "cloudtrail" = {
      service           = "cloudtrail",
      name_suffix       = "cloudtrail",
      vpc_endpoint_type = "Interface"
    }
    "codebuild" = {
      service           = "codebuild",
      name_suffix       = "codebuild",
      vpc_endpoint_type = "Interface"
    }
    "codecommit" = {
      service           = "codecommit",
      name_suffix       = "codecommit",
      vpc_endpoint_type = "Interface"
    }
    "codepipeline" = {
      service           = "codepipeline",
      name_suffix       = "codepipeline",
      vpc_endpoint_type = "Interface"
    }
    "config" = {
      service           = "config",
      name_suffix       = "config",
      vpc_endpoint_type = "Interface"
    }
    "datasync" = {
      service           = "datasync",
      name_suffix       = "datasync",
      vpc_endpoint_type = "Interface"
    }
    "dynamodb" = {
      service           = "dynamodb",
      name_suffix       = "dynamodb",
      vpc_endpoint_type = "Gateway"
    }
    "ebs" = {
      service           = "ebs",
      name_suffix       = "ebs",
      vpc_endpoint_type = "Interface"
    }
    "ec2" = {
      service           = "ec2",
      name_suffix       = "ec2",
      vpc_endpoint_type = "Interface"
    }
    "ec2messages" = {
      service           = "ec2messages",
      name_suffix       = "ec2messages",
      vpc_endpoint_type = "Interface"
    }
    "ecr_api" = {
      service           = "ecr.api",
      name_suffix       = "ecr-api",
      vpc_endpoint_type = "Interface"
    }
    "ecr_dkr" = {
      service           = "ecr.dkr",
      name_suffix       = "ecr-dkr",
      vpc_endpoint_type = "Interface"
    }
    "ecs-agent" = {
      service           = "ecs-agent",
      name_suffix       = "ecs-agent",
      vpc_endpoint_type = "Interface"
    }
    "ecs-telemetry" = {
      service           = "ecs-telemetry",
      name_suffix       = "ecs-telemetry",
      vpc_endpoint_type = "Interface"
    }
    "ecs" = {
      service           = "ecs",
      name_suffix       = "ecs",
      vpc_endpoint_type = "Interface"
    }
    "elastic-inference_runtime" = {
      service           = "elastic-inference.runtime",
      name_suffix       = "elastic-inference-runtime",
      vpc_endpoint_type = "Interface"
    }
    "elasticbeanstalk-health" = {
      service           = "elasticbeanstalk-health",
      name_suffix       = "elasticbeanstalk-health",
      vpc_endpoint_type = "Interface"
    }
    "elasticbeanstalk" = {
      service           = "elasticbeanstalk",
      name_suffix       = "elasticbeanstalk",
      vpc_endpoint_type = "Interface"
    }
    "elasticfilesystem" = {
      service           = "elasticfilesystem",
      name_suffix       = "elasticfilesystem",
      vpc_endpoint_type = "Interface"
    }
    "elasticloadbalancing" = {
      service           = "elasticloadbalancing",
      name_suffix       = "elasticloadbalancing",
      vpc_endpoint_type = "Interface"
    }
    "elasticmapreduce" = {
      service           = "elasticmapreduce",
      name_suffix       = "elasticmapreduce",
      vpc_endpoint_type = "Interface"
    }
    "email-smtp" = {
      service           = "email-smtp",
      name_suffix       = "email-smtp",
      vpc_endpoint_type = "Interface"
    }
    "events" = {
      service           = "events",
      name_suffix       = "events",
      vpc_endpoint_type = "Interface"
    }
    "api_gwateway" = {
      service           = "execute-api",
      name_suffix       = "api-gateway",
      vpc_endpoint_type = "Interface"
    }
    "git-codecommit" = {
      service           = "git-codecommit",
      name_suffix       = "git-codecommit",
      vpc_endpoint_type = "Interface"
    }
    "glue" = {
      service           = "glue",
      name_suffix       = "glue",
      vpc_endpoint_type = "Interface"
    }
    "kinesis-firehose" = {
      service           = "kinesis-firehose",
      name_suffix       = "kinesis-firehose",
      vpc_endpoint_type = "Interface"
    }
    "kinesis-streams" = {
      service           = "kinesis-streams",
      name_suffix       = "kinesis-streams",
      vpc_endpoint_type = "Interface"
    }
    "kms" = {
      service           = "lms",
      name_suffix       = "lms",
      vpc_endpoint_type = "Interface"
    }
    "logs" = {
      service           = "logs",
      name_suffix       = "logs",
      vpc_endpoint_type = "Interface"
    }
    "monitoring" = {
      service           = "monitoring",
      name_suffix       = "monitoring",
      vpc_endpoint_type = "Interface"
    }
    "qldb_session" = {
      service           = "qldb.session",
      name_suffix       = "qldb-session",
      vpc_endpoint_type = "Interface"
    }
    "rekognition" = {
      service           = "rekognition",
      name_suffix       = "rekognition",
      vpc_endpoint_type = "Interface"
    }
    "s3" = {
      service           = "s3",
      name_suffix       = "s3",
      vpc_endpoint_type = "Gateway"
    }
    "sagemaker_api" = {
      service           = "sagemaker.api",
      name_suffix       = "sagemaker-api",
      vpc_endpoint_type = "Interface"
    }
    "sagemaker_notebook" = {
      service           = "sagemaker_notebook",
      name_suffix       = "aws.sagemaker.${var.sagemaker_notebook_endpoint_region}.notebook",
      vpc_endpoint_type = "Interface"
    }
    "secretsmanager" = {
      service           = "secretsmanager",
      name_suffix       = "secretsmanager",
      vpc_endpoint_type = "Interface"
    }
    "servicecatalog" = {
      service           = "servicecatalog",
      name_suffix       = "servicecatalog",
      vpc_endpoint_type = "Interface"
    }
    "sms" = {
      service           = "sms",
      name_suffix       = "sms",
      vpc_endpoint_type = "Interface"
    }
    "sns" = {
      service           = "sns",
      name_suffix       = "sns",
      vpc_endpoint_type = "Interface"
    }
    "sqs" = {
      service           = "sqs",
      name_suffix       = "sqs",
      vpc_endpoint_type = "Interface"
    }
    "ssm" = {
      service           = "ssm",
      name_suffix       = "ssm",
      vpc_endpoint_type = "Interface"
    }
    "ssmmessages" = {
      service           = "ssmmessages",
      name_suffix       = "ssmmessages",
      vpc_endpoint_type = "Interface"
    }
    "states" = {
      service           = "states",
      name_suffix       = "states",
      vpc_endpoint_type = "Interface"
    }
    "storagegateway" = {
      service           = "storagegateway",
      name_suffix       = "storagegateway",
      vpc_endpoint_type = "Interface"
    }
    "sts" = {
      service           = "sts",
      name_suffix       = "sts",
      vpc_endpoint_type = "Interface"
    }
    "transfer_server" = {
      service           = "transfer.server",
      name_suffix       = "transfer-server",
      vpc_endpoint_type = "Interface"
    }
    "transfer" = {
      service           = "transfer",
      name_suffix       = "transfer",
      vpc_endpoint_type = "Interface"
    }
    "workspaces" = {
      service           = "workspaces",
      name_suffix       = "workspaces",
      vpc_endpoint_type = "Interface"
    }
  }
}

data "aws_vpc_endpoint_service" "this" {
  service      = local.endpoints[var.endpoint].service
  service_type = local.endpoints[var.endpoint].vpc_endpoint_type
}

resource "aws_vpc_endpoint" "this" {
  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.this.service_name
  vpc_endpoint_type = local.endpoints[var.endpoint].vpc_endpoint_type

  security_group_ids  = local.endpoints[var.endpoint].vpc_endpoint_type == "Interface" ? var.security_group_ids : null
  subnet_ids          = local.endpoints[var.endpoint].vpc_endpoint_type == "Interface" ? var.subnet_ids : null
  private_dns_enabled = var.private_dns_enabled

  tags = merge(
    {
      Name = format(
        "%s%s%s",
        var.name,
        var.name != "" && (var.name_suffix != null && var.name_suffix != "") ? "" : "-",
        var.name_suffix != null ? var.name_suffix : local.endpoints[var.endpoint].name_suffix
      )
    },
    var.tags
  )
}

########################################
# VPC Endpoints route table associations
########################################

resource "aws_vpc_endpoint_route_table_association" "this" {
  count = local.endpoints[var.endpoint].vpc_endpoint_type == "Gateway" ? var.route_table_association_num : 0

  vpc_endpoint_id = aws_vpc_endpoint.this.id
  route_table_id  = element(var.route_table_ids, count.index)
}
