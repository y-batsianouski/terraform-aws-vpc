# terraform-aws-vpc module

This module manages AWS VPC.

Requires:

- terraform: `>= 0.13.0, < 0.14.0`
- provider aws: `>= 2.68, < 4.0`

[terraform registry](https://registry.terraform.io/modules/y-batsianouski/vpc/aws)

## resources

List of resources which can be managed by this module:

- vpc resource:
  - VPC
  - DHCP Options
  - default network ACL
  - default security group
  - internet gateway
  - egress-only internet gateway
  - NAT gateways
  - NAT gateways EIPs
  - VPN Gateway
  - VPC Endpoints
- multiple subnet types:
  - public
  - private
  - intra - private subnets without NAT gateway route
  - database
  - elasticache
  - redshift
  - elasticsearch
  - custom1, custom2, custom3 - subnets with custom configuration
- per-subnet additional resources
  - dedicated network ACL (all subnets)
  - RDS db subnet group (private, database and custom subnets)
  - ElastiCache subnet group (private, elasticache and custom subnets)
  - Redshift subnet group (private, redshift and custom subnets)
  - VPN Gateway route propagation (all subnets type except intra)

## NAT Gateways

This module always tries to identify how many NAT Gateways are really required and creates only minimal required number of NAT Gateways for costs savings

### Default behavior (nat_gateway_single = false)

- **Case 1**: public and private subnets are located in the same AZs. One NAT Gateway will be created once in each AZ.
- **Case 2**: public and private subnets are located in different AZs:
  - Module tries to find all AZs which contains both private and public subnet. Will create NAT Gateways in each such AZ. private subnets from other AZs will be pointed to some available NAT Gateway.
  - If less than 2 AZ contains both public and private subnets, at least 2 NAT gateways will be created in different AZs with public subnets
  - If there is only one public subnet, only one NAT Gateway will be created in this public subnet

### Single NAT Gateway

If `nat_gateway_single = true` one NAT Gateway will be created in first available AZ with both private and public subnets. Otherwise first public subnet will be choosen to create NAT Gateway. In this case Only one private route table will be created

### Complex configuration

If you want to take full control over NAT Gateways, you need to specify `nat_gateways_azs = []` variable. In this case module will create one NAT Gateway in each of this AZs which contains public subntes independent how many subnets with nat gateway route enabled you have. All subnets with dedicated route tables and enabled nat gateway route will be pointed to the right NAT Gateway from it's AZ or to some NAT from the other AZ.

## VPC Endpoints

You can enable VPC endpoints using `vpc_endpoints` variable:

```terraform
module "vpc" {
  ...
  vpc_endpoints = {
    s3      = true,
    ecr_dkr = true
  }
}
```

By default, VPC endpoints are automatically attached to the public, private and intra subnets. If you need more control over created VPC endpoints or pass additional arguments, you need to pass map instead of simple `true` value:

```terraform
module "vpc" {
  ...
  vpc_endpoints = {
    s3 = {
      public              = bool, # enable or disable endpoint for public subnets
      private             = bool, # enable or disable endpoint for private subnets
      intra               = bool, # enable or disable endpoint for intra subnets
      database            = bool, # enable or disable endpoint for database subnets
      elasticache         = bool, # enable or disable endpoint for elasticache subnets
      redshift            = bool, # enable or disable endpoint for redshift subnets
      elasticsearch       = bool, # enable or disable endpoint for elasticsearch subnets
      custom1             = bool, # enable or disable endpoint for custom1 subnets
      custom2             = bool, # enable or disable endpoint for custom2 subnets
      custom3             = bool, # enable or disable endpoint for custom3 subnets
      security_group_ids  = [],   # pass list of security_group_ids argument to aws_vpc_endpoint resource
      private_dns_enabled = bool, # pass list of private_dns_enabled argument to aws_vpc_endpoint resource
      sagemaker_notebook_endpoint_region = string, # Only required for sagemaker_notebook VPC Endpoint
      tags                = map(string) # Pass additional tags for specific endpoint
    }
  }
}
```

## Inputs

[See inputs on registry.terraform.io](https://registry.terraform.io/modules/y-batsianouski/vpc/aws?tab=inputs)

## Outputs

[See outpus on registry.terraform.io](https://registry.terraform.io/modules/y-batsianouski/vpc/aws?tab=outputs)
