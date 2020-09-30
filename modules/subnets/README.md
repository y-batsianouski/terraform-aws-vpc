# terraform-aws-subnets module

This module manages multiple similar subnets in existing AWS VPC

## resources

List of resources which can be managed by this module:

- One or several subnets
- Network ACL
- Route tables (can be created only one route table for all subnets)
- NAT Gateways, internet Gateway, egress-only internet gateway routes
- VPN gateway route propagation
- VPC Enpoints route association (Only for endpoints of type "Gateway")
- RDS db subnet group
- ElastiCache subnet group
- Redshift subnet group

## Inputs

[See inputs on registry.terraform.io in subnets submodule](https://registry.terraform.io/modules/y-batsianouski/vpc/aws)

## Outputs

[See outpus on registry.terraform.io in subnets submodule](https://registry.terraform.io/modules/y-batsianouski/vpc/aws)
