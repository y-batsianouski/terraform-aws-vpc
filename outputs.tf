output "name" {
  description = "The name of the vpc"
  value       = var.name
}
output "azs" {
  description = "list of availability zone which spans this subnet"
  value       = local.vpc_azs
}
output "vpc" {
  description = "Map of the VPC attributes"
  value       = { for k, v in aws_vpc.this : k => v if contains(["tags"], k) == false }
}

output "dhcp_options" {
  description = "Map of the DHCP Options attributes"
  value       = concat(aws_vpc_dhcp_options.this, [{}])[0]
}

output "default_network_acl" {
  description = "Map of the default network ACL attributes"
  value       = { for k, v in concat(aws_default_network_acl.this, [{}])[0] : k => v if contains(["tags", "egress", "ingress", "tags", "owner_id"], k) == false }
}
output "default_security_group" {
  description = "Map of the default security group attributes"
  value       = { for k, v in concat(aws_default_security_group.this, [{}])[0] : k => v if contains(["tags", "egress", "ingress", "tags", "owner_id"], k) == false }
}

output "internet_gateway" {
  description = "Map of the Internet gateway attributes"
  value       = concat(aws_internet_gateway.this, [{}])[0]
}
output "egress_only_igw" {
  description = "Map of the egress-only internet gateway attributes"
  value       = concat(aws_egress_only_internet_gateway.this, [{}])[0]
}
output "nat_eips" {
  description = "List of NAT EIPs attributes"
  value       = [for s in aws_eip.nat : { for k, v in s : k => v if contains(["tags", "timeouts"], k) == false }]
}
output "nat_allocation_ids" {
  description = "List of nat eip allocation IDs"
  value       = var.nat_gateway_enable ? length(var.nat_gateway_allocation_ids) == 0 ? aws_eip.nat.*.id : var.nat_gateway_allocation_ids : []
}
output "nat_gateways" {
  description = "List of NAT gateways attributes"
  value       = [for s in aws_nat_gateway.this : { for k, v in s : k => v if contains(["tags", "timeouts"], k) == false }]
}
output "vpc_endpoints" {
  description = "List of VPC Endpoints attributes"
  value       = module.vpc_endpoints
}

output "vpn_gateway" {
  description = "Map of the VPN gateway attributes"
  value       = concat(aws_vpn_gateway.this, [{}])[0]
}
output "vpn_gateway_id" {
  description = "VPN gateway ID"
  value       = var.vpn_gateway_create ? aws_vpn_gateway.this[0].id : var.vpn_gateway_id != "" ? var.vpn_gateway_id : ""
}

output "public" {
  description = "public subnets"
  value       = length(var.public_cidrs) > 0 ? module.public : null
}
output "public_name_suffix" {
  description = "public subnets suffix"
  value       = length(var.public_cidrs) > 0 ? var.public_name_suffix : ""
}

output "private" {
  description = "private subnets"
  value       = length(var.private_cidrs) > 0 ? module.private : null
}
output "private_name_suffix" {
  description = "private subnets suffix"
  value       = length(var.private_cidrs) > 0 ? var.private_name_suffix : ""
}

output "database" {
  description = "database subnets"
  value       = length(var.database_cidrs) > 0 ? module.database : null
}
output "database_name_suffix" {
  description = "database subnets suffix"
  value       = length(var.database_cidrs) > 0 ? var.database_name_suffix : ""
}

output "elasticache" {
  description = "elasticache subnets"
  value       = length(var.elasticache_cidrs) > 0 ? module.elasticache : null
}
output "elasticache_name_suffix" {
  description = "elasticache subnets suffix"
  value       = length(var.elasticache_cidrs) > 0 ? var.elasticache_name_suffix : ""
}

output "redshift" {
  description = "redshift subnets"
  value       = length(var.redshift_cidrs) > 0 ? module.redshift : null
}
output "redshift_name_suffix" {
  description = "redshift subnets suffix"
  value       = length(var.redshift_cidrs) > 0 ? var.redshift_name_suffix : ""
}

output "elasticsearch" {
  description = "elasticsearch subnets"
  value       = length(var.elasticsearch_cidrs) > 0 ? module.elasticsearch : null
}
output "elasticsearch_name_suffix" {
  description = "elasticsearch subnets suffix"
  value       = length(var.elasticsearch_cidrs) > 0 ? var.elasticsearch_name_suffix : ""
}

output "custom1" {
  description = "custom1 subnets"
  value       = length(var.custom1_cidrs) > 0 ? module.custom1 : null
}
output "custom1_name_suffix" {
  description = "custom1 subnets suffix"
  value       = length(var.custom1_cidrs) > 0 ? var.custom1_name_suffix : ""
}

output "custom2" {
  description = "custom2 subnets"
  value       = length(var.custom2_cidrs) > 0 ? module.custom2 : null
}
output "custom2_name_suffix" {
  description = "custom2 subnets suffix"
  value       = length(var.custom2_cidrs) > 0 ? var.custom2_name_suffix : ""
}

output "custom3" {
  description = "custom3 subnets"
  value       = length(var.custom3_cidrs) > 0 ? module.custom3 : null
}
output "custom3_name_suffix" {
  description = "custom3 subnets suffix"
  value       = length(var.custom3_cidrs) > 0 ? var.custom3_name_suffix : ""
}
