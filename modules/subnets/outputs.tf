output "name" { value = var.name }
output "azs" { value = var.azs }
output "vpc_id" { value = var.vpc_id }

output "subnets" {
  value = [for s in aws_subnet.this : { for k, v in s : k => v if contains(["tags", "timeouts", "vpc_id"], k) == false }]
}

output "route_tables" {
  value = [for s in aws_route_table.this : { for k, v in s : k => v if contains(["tags", "timeouts", "route", "vpc_id"], k) == false }]
}
output "route_table_ids" { value = var.route_table_create ? aws_route_table.this.*.id : var.route_table_ids }

output "network_acl" { value = concat(aws_network_acl.this, [{}])[0] }

output "db_subnet_group" { value = { for k, v in concat(aws_db_subnet_group.database, [{}])[0] : k => v if contains(["tags", "timeouts"], k) == false } }
output "elasticache_subnet_group" { value = concat(aws_elasticache_subnet_group.elasticache, [{}])[0] }
output "redshift_subnet_group" { value = { for k, v in concat(aws_redshift_subnet_group.redshift, [{}])[0] : k => v if contains(["tags", "timeouts"], k) == false } }

output "vpn_gateway_id" { value = var.vpn_gateway_id }
