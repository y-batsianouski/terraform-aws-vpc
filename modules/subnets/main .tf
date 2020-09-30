########
# subnet
########

locals {
  create = length(var.cidrs) > 0 ? true : false
}

resource "aws_subnet" "this" {
  count = local.create ? length(var.cidrs) : 0

  vpc_id = var.vpc_id

  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null


  cidr_block              = var.cidrs[count.index]
  map_public_ip_on_launch = length(var.map_public_ip_on_launch_per_subnet) == 0 ? var.map_public_ip_on_launch : var.map_public_ip_on_launch_per_subnet[count.index]

  ipv6_cidr_block                 = var.enable_ipv6 ? cidrsubnet(var.vpc_ipv6_cidr_block, 8, var.ipv6_prefixes[count.index]) : null
  assign_ipv6_address_on_creation = var.enable_ipv6 ? length(var.assign_ipv6_address_on_creation_per_subnet) == 0 ? var.assign_ipv6_address_on_creation : var.assign_ipv6_address_on_creation_per_subnet[count.index] : null

  tags = merge(
    {
      Name = format(
        "%s%s%s",
        var.name,
        var.name != "" ? "-" : "",
        element(var.azs, count.index),
      )
    },
    var.tags,
    element(var.tags_per_subnet, count.index)
  )
}

##############
# Route tables
##############

locals {
  route_table_number_to_create = var.route_table_create && length(var.route_table_ids) == 0 ? var.route_table_single ? 1 : length(var.cidrs) : 0
}

resource "aws_route_table" "this" {
  count = local.create ? local.route_table_number_to_create : 0

  vpc_id = var.vpc_id

  tags = merge(
    {
      Name = var.route_table_single ? var.name : format(
        "%s%s%s",
        var.name,
        var.name != "" ? "-" : "",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.route_table_tags,
    element(var.route_table_tags_per_route_table, count.index)
  )
}

resource "aws_route" "internet_gateway" {
  count = local.create && var.internet_gateway_id != "" ? local.route_table_number_to_create : 0

  route_table_id         = element(aws_route_table.this.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "nat_gateway" {
  count = local.create && var.internet_gateway_id == "" && length(var.nat_gateways_ids) > 0 ? local.route_table_number_to_create : 0

  route_table_id         = element(aws_route_table.this.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(var.nat_gateways_ids, count.index)

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "ipv6_egress" {
  count = local.create && var.enable_ipv6 && var.egress_only_igw_id != "" ? local.route_table_number_to_create : 0

  route_table_id              = element(aws_route_table.this.*.id, count.index)
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id      = var.egress_only_igw_id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "this" {
  count = local.create && var.route_table_create && length(var.route_table_ids) == 0 ? length(var.cidrs) : 0

  subnet_id      = element(aws_subnet.this.*.id, count.index)
  route_table_id = element(aws_route_table.this.*.id, count.index)
}

resource "aws_route_table_association" "external" {
  count = local.create && length(var.route_table_ids) > 0 ? length(var.cidrs) : 0

  subnet_id      = element(aws_subnet.this.*.id, count.index)
  route_table_id = element(var.route_table_ids, count.index)
}

#############
# Network ACL
#############

resource "aws_network_acl" "this" {
  count = local.create && var.network_acl_create ? 1 : 0

  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.this.*.id

  tags = merge(
    { Name = var.name },
    var.tags,
    var.network_acl_tags,
  )
}

resource "aws_network_acl_rule" "inbound" {
  count = local.create && var.network_acl_create ? length(var.network_acl_inbound_rules) : 0

  network_acl_id = aws_network_acl.this[0].id

  egress          = false
  rule_number     = var.network_acl_inbound_rules[count.index]["rule_number"]
  rule_action     = var.network_acl_inbound_rules[count.index]["rule_action"]
  from_port       = lookup(var.network_acl_inbound_rules[count.index], "from_port", null)
  to_port         = lookup(var.network_acl_inbound_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.network_acl_inbound_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.network_acl_inbound_rules[count.index], "icmp_type", null)
  protocol        = var.network_acl_inbound_rules[count.index]["protocol"]
  cidr_block      = lookup(var.network_acl_inbound_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.network_acl_inbound_rules[count.index], "ipv6_cidr_block", null)
}

resource "aws_network_acl_rule" "outbound" {
  count = local.create && var.network_acl_create ? length(var.network_acl_outbound_rules) : 0

  network_acl_id = aws_network_acl.this[0].id

  egress          = true
  rule_number     = var.network_acl_outbound_rules[count.index]["rule_number"]
  rule_action     = var.network_acl_outbound_rules[count.index]["rule_action"]
  from_port       = lookup(var.network_acl_outbound_rules[count.index], "from_port", null)
  to_port         = lookup(var.network_acl_outbound_rules[count.index], "to_port", null)
  icmp_code       = lookup(var.network_acl_outbound_rules[count.index], "icmp_code", null)
  icmp_type       = lookup(var.network_acl_outbound_rules[count.index], "icmp_type", null)
  protocol        = var.network_acl_outbound_rules[count.index]["protocol"]
  cidr_block      = lookup(var.network_acl_outbound_rules[count.index], "cidr_block", null)
  ipv6_cidr_block = lookup(var.network_acl_outbound_rules[count.index], "ipv6_cidr_block", null)
}

###############
# subnet groups
###############

resource "aws_db_subnet_group" "database" {
  count = local.create && var.db_subnet_group_create ? 1 : 0

  name        = var.db_subnet_group_name != "" ? var.db_subnet_group_name : var.name
  description = var.db_subnet_group_description != "" ? var.db_subnet_group_description : "Database subnet group for ${var.name}"
  subnet_ids  = aws_subnet.this.*.id

  tags = merge(
    { Name = var.name },
    var.tags,
    var.db_subnet_group_tags,
  )
}

resource "aws_elasticache_subnet_group" "elasticache" {
  count = local.create && var.elasticache_subnet_group_create ? 1 : 0

  name        = var.elasticache_subnet_group_name != "" ? var.elasticache_subnet_group_name : var.name
  description = var.elasticache_subnet_group_description != "" ? var.elasticache_subnet_group_description : "ElastiCache subnet group for ${var.name}"
  subnet_ids  = aws_subnet.this.*.id
}

resource "aws_redshift_subnet_group" "redshift" {
  count = local.create && var.redshift_subnet_group_create ? 1 : 0

  name        = var.redshift_subnet_group_name != "" ? var.redshift_subnet_group_name : var.name
  description = var.redshift_subnet_group_description != "" ? var.redshift_subnet_group_description : "Redshift subnet group for ${var.name}"
  subnet_ids  = aws_subnet.this.*.id

  tags = merge(
    { Name = var.name },
    var.tags,
    var.redshift_subnet_group_tags,
  )
}

###############################
# VPN Gateway route propagation
###############################

resource "aws_vpn_gateway_route_propagation" "this" {
  count = local.create && var.vpn_gateway_id != "" ? local.route_table_number_to_create : 0

  route_table_id = element(aws_route_table.this.*.id, count.index)
  vpn_gateway_id = var.vpn_gateway_id
}
