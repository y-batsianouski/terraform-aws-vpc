locals {
  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = element(concat(aws_vpc_ipv4_cidr_block_association.this.*.vpc_id, aws_vpc.this.*.id, [""]), 0)

  public_azs        = length(var.public_azs) > 0 ? var.public_azs : length(var.azs) > length(var.public_cidrs) ? slice(var.azs, 0, length(var.public_cidrs)) : var.azs
  private_azs       = length(var.private_azs) > 0 ? var.private_azs : length(var.azs) > length(var.private_cidrs) ? slice(var.azs, 0, length(var.private_cidrs)) : var.azs
  intra_azs         = length(var.intra_azs) > 0 ? var.intra_azs : length(var.azs) > length(var.intra_cidrs) ? slice(var.azs, 0, length(var.intra_cidrs)) : var.azs
  database_azs      = length(var.database_azs) > 0 ? var.database_azs : length(var.azs) > length(var.database_cidrs) ? slice(var.azs, 0, length(var.database_cidrs)) : var.azs
  elasticache_azs   = length(var.elasticache_azs) > 0 ? var.elasticache_azs : length(var.azs) > length(var.elasticache_cidrs) ? slice(var.azs, 0, length(var.elasticache_cidrs)) : var.azs
  redshift_azs      = length(var.redshift_azs) > 0 ? var.redshift_azs : length(var.azs) > length(var.redshift_cidrs) ? slice(var.azs, 0, length(var.redshift_cidrs)) : var.azs
  elasticsearch_azs = length(var.elasticsearch_azs) > 0 ? var.elasticsearch_azs : length(var.azs) > length(var.elasticsearch_cidrs) ? slice(var.azs, 0, length(var.elasticsearch_cidrs)) : var.azs
  custom1_azs       = length(var.custom1_azs) > 0 ? var.custom1_azs : length(var.azs) > length(var.custom1_cidrs) ? slice(var.azs, 0, length(var.custom1_cidrs)) : var.azs
  custom2_azs       = length(var.custom1_azs) > 0 ? var.custom2_azs : length(var.azs) > length(var.custom2_cidrs) ? slice(var.azs, 0, length(var.custom2_cidrs)) : var.azs
  custom3_azs       = length(var.custom1_azs) > 0 ? var.custom3_azs : length(var.azs) > length(var.custom3_cidrs) ? slice(var.azs, 0, length(var.custom3_cidrs)) : var.azs
  vpc_azs = sort(distinct(concat(
    local.public_azs,
    local.private_azs,
    local.intra_azs,
    local.database_azs,
    local.elasticache_azs,
    local.redshift_azs,
    local.elasticsearch_azs,
    local.custom1_azs,
    local.custom2_azs,
    local.custom3_azs,
  )))

  num_of_subnets_with_public_access = length(concat(
    length(var.public_cidrs) > 0 ? var.public_cidrs : [],
    local.database_create && var.database_enable_public_route ? var.database_cidrs : [],
    length(var.elasticache_cidrs) > 0 && var.elasticache_enable_public_route ? var.elasticache_cidrs : [],
    length(var.redshift_cidrs) > 0 && var.redshift_enable_public_route ? var.redshift_cidrs : [],
    length(var.elasticsearch_cidrs) > 0 && var.elasticsearch_enable_public_route ? var.elasticsearch_cidrs : [],
    length(var.custom1_cidrs) > 0 && var.custom1_enable_public_route ? var.custom1_cidrs : [],
    length(var.custom2_cidrs) > 0 && var.custom2_enable_public_route ? var.custom2_cidrs : [],
    length(var.custom3_cidrs) > 0 && var.custom3_enable_public_route ? var.custom3_cidrs : []
  ))

  internet_gateway_create = var.internet_gateway_create && local.num_of_subnets_with_public_access > 0 ? true : false
  egress_only_igw_create  = var.enable_ipv6 && var.egress_only_igw_create && local.num_of_subnets_with_public_access > 0 ? true : false

  vpc_endpoints_subnet_ids_default      = concat(module.public.subnets.*.id, module.private.subnets.*.id, module.intra.subnets.*.id)
  vpc_endpoints_route_table_ids_default = concat(module.public.route_table_ids, module.private.route_table_ids, module.intra.route_table_ids)
  vpc_endpoints_route_table_num_default = local.public_route_table_num + local.private_route_table_num + local.intra_route_table_num

  nat_gateway_required_azs = var.nat_gateway_enable ? length(var.nat_gateway_azs) > 0 ? var.nat_gateway_azs : concat(
    local.private_create ? local.private_azs : [],
    local.database_create && var.database_route_table_create && var.database_enable_nat_gateway_route ? local.database_azs : [],
    local.redshift_create && var.redshift_route_table_create && var.redshift_enable_nat_gateway_route ? local.redshift_azs : [],
    local.elasticache_create && var.elasticache_route_table_create && var.elasticache_enable_nat_gateway_route ? local.elasticache_azs : [],
    local.elasticsearch_create && var.elasticsearch_route_table_create && var.elasticsearch_enable_nat_gateway_route ? local.elasticsearch_azs : [],
    local.custom1_create && var.custom1_route_table_create && var.custom1_enable_nat_gateway_route ? local.custom1_azs : [],
    local.custom2_create && var.custom2_route_table_create && var.custom2_enable_nat_gateway_route ? local.custom2_azs : [],
    local.custom3_create && var.custom3_route_table_create && var.custom3_enable_nat_gateway_route ? local.custom3_azs : [],
  ) : []
  nat_gateway_suitable_public_azs = var.nat_gateway_enable ? matchkeys(local.public_azs, local.public_azs, local.nat_gateway_required_azs) : []
  nat_gateway_selected_azs = length(local.nat_gateway_suitable_public_azs) == length(local.nat_gateway_required_azs) || length(local.nat_gateway_suitable_public_azs) >= 2 ? local.nat_gateway_suitable_public_azs : length(local.public_azs) > 1 ? [
    element(concat(local.nat_gateway_suitable_public_azs, local.public_azs), 0),
    element(concat(local.nat_gateway_suitable_public_azs, local.public_azs), 1)
  ] : [element(concat(local.nat_gateway_suitable_public_azs, local.public_azs), 0)]
  nat_gateway_azs            = length(local.nat_gateway_selected_azs) > 0 ? var.nat_gateway_single ? [element(local.nat_gateway_selected_azs, 0)] : local.nat_gateway_selected_azs : []
  nat_gateway_count          = length(local.nat_gateway_azs)
  nat_gateway_allocation_ids = split(",", length(var.nat_gateway_allocation_ids) == 0 ? join(",", aws_eip.nat.*.id) : join(",", var.nat_gateway_allocation_ids))

  public_route_table_num = var.public_route_table_separate ? length(var.public_cidrs) : 1

  private_create             = length(var.private_cidrs) > 0
  private_route_table_single = var.private_route_table_separate == false && (local.nat_gateway_count == 1 || var.nat_gateway_enable == false) ? true : false
  private_route_table_num    = local.private_route_table_single ? 1 : length(var.private_cidrs)
  private_nat_gateways_ids   = [for az in local.private_azs : element(aws_nat_gateway.this.*.id, contains(local.nat_gateway_azs, az) ? index(local.nat_gateway_azs, az) : index(local.private_azs, az))]

  intra_route_table_num = length(var.intra_cidrs) == 0 ? 0 : var.intra_route_table_separate ? length(var.intra_cidrs) : 1

  database_create                     = length(var.database_cidrs) > 0
  database_route_table_use_public_rt  = var.database_route_table_create == false && var.database_enable_public_route ? true : false
  database_route_table_use_private_rt = var.database_route_table_create || local.database_route_table_use_public_rt ? false : true
  database_route_table_single         = var.database_route_table_separate == false && ((var.database_enable_nat_gateway_route && local.nat_gateway_count == 1) || var.database_enable_public_route || (var.database_enable_nat_gateway_route == false && var.database_enable_public_route == false)) ? true : false
  database_route_table_num            = local.database_route_table_use_public_rt || local.database_route_table_use_private_rt ? 0 : local.database_route_table_single ? 1 : length(var.database_cidrs)
  database_nat_gateways_ids = var.database_route_table_create && var.database_enable_nat_gateway_route && var.database_enable_public_route == false && length(local.nat_gateway_selected_azs) > 0 ? [
    for az in local.database_azs : contains(local.nat_gateway_azs, az) ? element(
      aws_nat_gateway.this.*.id,
      index(local.nat_gateway_azs, az)
      ) : element(
      [
        for i in matchkeys(
          range(length(local.nat_gateway_azs)),
          local.nat_gateway_azs,
          [for az in local.nat_gateway_azs : az if ! contains(local.database_azs, az)]
        ) : element(aws_nat_gateway.this.*.id, i)
      ],
      index(local.database_azs, az)
    )
  ] : []

  elasticache_create                     = length(var.elasticache_cidrs) > 0
  elasticache_route_table_use_public_rt  = var.elasticache_route_table_create == false && var.elasticache_enable_public_route ? true : false
  elasticache_route_table_use_private_rt = var.elasticache_route_table_create || local.elasticache_route_table_use_public_rt ? false : true
  elasticache_route_table_single         = var.elasticache_route_table_separate == false && ((var.elasticache_enable_nat_gateway_route && local.nat_gateway_count == 1) || var.elasticache_enable_public_route || (var.elasticache_enable_nat_gateway_route == false && var.elasticache_enable_public_route == false)) ? true : false
  elasticache_route_table_num            = local.elasticache_route_table_use_public_rt || local.elasticache_route_table_use_private_rt ? 0 : local.elasticache_route_table_single ? 1 : length(var.elasticache_cidrs)
  elasticache_nat_gateways_ids = var.elasticache_route_table_create && var.elasticache_enable_nat_gateway_route && var.elasticache_enable_public_route == false && length(local.nat_gateway_selected_azs) > 0 ? [
    for az in local.elasticache_azs : contains(local.nat_gateway_azs, az) ? element(
      aws_nat_gateway.this.*.id,
      index(local.nat_gateway_azs, az)
      ) : element(
      [
        for i in matchkeys(
          range(length(local.nat_gateway_azs)),
          local.nat_gateway_azs,
          [for az in local.nat_gateway_azs : az if ! contains(local.elasticache_azs, az)]
        ) : element(aws_nat_gateway.this.*.id, i)
      ],
      index(local.elasticache_azs, az)
    )
  ] : []

  redshift_create                     = length(var.redshift_cidrs) > 0
  redshift_route_table_use_public_rt  = var.redshift_route_table_create == false && var.redshift_enable_public_route ? true : false
  redshift_route_table_use_private_rt = var.redshift_route_table_create || local.redshift_route_table_use_public_rt ? false : true
  redshift_route_table_single         = var.redshift_route_table_separate == false && ((var.redshift_enable_nat_gateway_route && local.nat_gateway_count == 1) || var.redshift_enable_public_route || (var.redshift_enable_nat_gateway_route == false && var.redshift_enable_public_route == false)) ? true : false
  redshift_route_table_num            = local.redshift_route_table_use_public_rt || local.redshift_route_table_use_private_rt ? 0 : local.redshift_route_table_single ? 1 : length(var.redshift_cidrs)
  redshift_nat_gateways_ids = var.redshift_route_table_create && var.redshift_enable_nat_gateway_route && var.redshift_enable_public_route == false && length(local.nat_gateway_selected_azs) > 0 ? [
    for az in local.redshift_azs : contains(local.nat_gateway_azs, az) ? element(
      aws_nat_gateway.this.*.id,
      index(local.nat_gateway_azs, az)
      ) : element(
      [
        for i in matchkeys(
          range(length(local.nat_gateway_azs)),
          local.nat_gateway_azs,
          [for az in local.nat_gateway_azs : az if ! contains(local.redshift_azs, az)]
        ) : element(aws_nat_gateway.this.*.id, i)
      ],
      index(local.redshift_azs, az)
    )
  ] : []

  elasticsearch_create                     = length(var.elasticsearch_cidrs) > 0
  elasticsearch_route_table_use_public_rt  = var.elasticsearch_route_table_create == false && var.elasticsearch_enable_public_route ? true : false
  elasticsearch_route_table_use_private_rt = var.elasticsearch_route_table_create || local.elasticsearch_route_table_use_public_rt ? false : true
  elasticsearch_route_table_single         = var.elasticsearch_route_table_separate == false && ((var.elasticsearch_enable_nat_gateway_route && local.nat_gateway_count == 1) || var.elasticsearch_enable_public_route || (var.elasticsearch_enable_nat_gateway_route == false && var.elasticsearch_enable_public_route == false)) ? true : false
  elasticsearch_route_table_num            = local.elasticsearch_route_table_use_public_rt || local.elasticsearch_route_table_use_private_rt ? 0 : local.elasticsearch_route_table_single ? 1 : length(var.elasticsearch_cidrs)
  elasticsearch_nat_gateways_ids = var.elasticsearch_route_table_create && var.elasticsearch_enable_nat_gateway_route && var.elasticsearch_enable_public_route == false && length(local.nat_gateway_selected_azs) > 0 ? [
    for az in local.elasticsearch_azs : contains(local.nat_gateway_azs, az) ? element(
      aws_nat_gateway.this.*.id,
      index(local.nat_gateway_azs, az)
      ) : element(
      [
        for i in matchkeys(
          range(length(local.nat_gateway_azs)),
          local.nat_gateway_azs,
          [for az in local.nat_gateway_azs : az if ! contains(local.elasticsearch_azs, az)]
        ) : element(aws_nat_gateway.this.*.id, i)
      ],
      index(local.elasticsearch_azs, az)
    )
  ] : []

  custom1_create             = length(var.custom1_cidrs) > 0
  custom1_route_table_single = var.custom1_route_table_separate ? false : true
  custom1_route_table_num    = length(var.custom1_route_table_ids) > 0 ? length(var.custom1_route_table_ids) : local.custom1_create ? var.custom1_route_table_separate ? length(var.custom1_cidrs) : 1 : 0
  custom1_nat_gateways_ids = var.custom1_route_table_create && var.custom1_enable_nat_gateway_route && var.custom1_enable_public_route == false && length(local.nat_gateway_selected_azs) > 0 ? [
    for az in local.custom1_azs : contains(local.nat_gateway_azs, az) ? element(
      aws_nat_gateway.this.*.id,
      index(local.nat_gateway_azs, az)
      ) : element(
      [
        for i in matchkeys(
          range(length(local.nat_gateway_azs)),
          local.nat_gateway_azs,
          [for az in local.nat_gateway_azs : az if ! contains(local.custom1_azs, az)]
        ) : element(aws_nat_gateway.this.*.id, i)
      ],
      index(local.custom1_azs, az)
    )
  ] : []

  custom2_create             = length(var.custom2_cidrs) > 0
  custom2_route_table_single = var.custom2_route_table_separate ? false : true
  custom2_route_table_num    = length(var.custom2_route_table_ids) > 0 ? length(var.custom2_route_table_ids) : local.custom2_create ? var.custom2_route_table_separate ? length(var.custom2_cidrs) : 1 : 0
  custom2_nat_gateways_ids = var.custom2_route_table_create && var.custom2_enable_nat_gateway_route && var.custom2_enable_public_route == false && length(local.nat_gateway_selected_azs) > 0 ? [
    for az in local.custom2_azs : contains(local.nat_gateway_azs, az) ? element(
      aws_nat_gateway.this.*.id,
      index(local.nat_gateway_azs, az)
      ) : element(
      [
        for i in matchkeys(
          range(length(local.nat_gateway_azs)),
          local.nat_gateway_azs,
          [for az in local.nat_gateway_azs : az if ! contains(local.custom2_azs, az)]
        ) : element(aws_nat_gateway.this.*.id, i)
      ],
      index(local.custom2_azs, az)
    )
  ] : []

  custom3_create             = length(var.custom3_cidrs) > 0
  custom3_route_table_single = var.custom3_route_table_separate ? false : true
  custom3_route_table_num    = length(var.custom3_route_table_ids) > 0 ? length(var.custom3_route_table_ids) : local.custom3_create ? var.custom3_route_table_separate ? length(var.custom3_cidrs) : 1 : 0
  custom3_nat_gateways_ids = var.custom3_route_table_create && var.custom3_enable_nat_gateway_route && var.custom3_enable_public_route == false && length(local.nat_gateway_selected_azs) > 0 ? [
    for az in local.custom3_azs : contains(local.nat_gateway_azs, az) ? element(
      aws_nat_gateway.this.*.id,
      index(local.nat_gateway_azs, az)
      ) : element(
      [
        for i in matchkeys(
          range(length(local.nat_gateway_azs)),
          local.nat_gateway_azs,
          [for az in local.nat_gateway_azs : az if ! contains(local.custom3_azs, az)]
        ) : element(aws_nat_gateway.this.*.id, i)
      ],
      index(local.custom3_azs, az)
    )
  ] : []

  vpn_gateway_id = var.vpn_gateway_create ? aws_vpn_gateway.this[0].id : var.vpn_gateway_id
}

data "aws_region" "current" {}

#####
# VPC
#####

resource "aws_vpc" "this" {
  cidr_block                       = var.cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = merge(
    {
      Name = format("%s", var.name)
    },
    var.tags,
    var.vpc_tags,
  )
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  count = length(var.secondary_cidr_blocks) > 0 ? length(var.secondary_cidr_blocks) : 0

  vpc_id     = aws_vpc.this.id
  cidr_block = element(var.secondary_cidr_blocks, count.index)
}

##################
# DHCP Options Set
##################

resource "aws_vpc_dhcp_options" "this" {
  count = var.dhcp_options_enable ? 1 : 0

  domain_name          = var.dhcp_options_domain_name
  domain_name_servers  = var.dhcp_options_domain_name_servers
  ntp_servers          = length(var.dhcp_options_ntp_servers) > 0 ? var.dhcp_options_ntp_servers : []
  netbios_name_servers = length(var.dhcp_options_netbios_name_servers) > 0 ? var.dhcp_options_netbios_name_servers : []
  netbios_node_type    = var.dhcp_options_netbios_node_type == "" ? var.dhcp_options_netbios_node_type : ""

  tags = merge(
    { Name = var.dhcp_options_name != "" ? var.dhcp_options_name : format("%s", var.name) },
    var.tags,
    var.dhcp_options_tags,
  )
}

resource "aws_vpc_dhcp_options_association" "this" {
  count = var.dhcp_options_enable ? 1 : 0

  vpc_id          = local.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.this[0].id
}

#####################
# default network ACL
#####################

resource "aws_default_network_acl" "this" {
  count = var.default_network_acl_manage ? 1 : 0

  default_network_acl_id = aws_vpc.this.default_network_acl_id

  dynamic "ingress" {
    for_each = var.default_network_acl_ingress
    content {
      action          = ingress.value.action
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      from_port       = ingress.value.from_port
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = ingress.value.protocol
      rule_no         = ingress.value.rule_no
      to_port         = ingress.value.to_port
    }
  }
  dynamic "egress" {
    for_each = var.default_network_acl_egress
    content {
      action          = egress.value.action
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = egress.value.from_port
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = egress.value.protocol
      rule_no         = egress.value.rule_no
      to_port         = egress.value.to_port
    }
  }

  tags = merge(
    { Name = var.default_network_acl_name != "" ? var.default_network_acl_name : format("%s-default", var.name) },
    var.tags,
    var.default_network_acl_tags,
  )

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

########################
# default security group
########################

resource "aws_default_security_group" "this" {
  count = var.default_security_group_manage ? 1 : 0

  vpc_id = local.vpc_id

  dynamic "ingress" {
    for_each = var.default_security_group_ingress
    content {
      self             = lookup(ingress.value, "self", null)
      cidr_blocks      = compact(split(",", lookup(ingress.value, "cidr_blocks", "")))
      ipv6_cidr_blocks = compact(split(",", lookup(ingress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(ingress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(ingress.value, "security_groups", "")))
      description      = lookup(ingress.value, "description", null)
      from_port        = lookup(ingress.value, "from_port", 0)
      to_port          = lookup(ingress.value, "to_port", 0)
      protocol         = lookup(ingress.value, "protocol", "-1")
    }
  }

  dynamic "egress" {
    for_each = var.default_security_group_egress
    content {
      self             = lookup(egress.value, "self", null)
      cidr_blocks      = compact(split(",", lookup(egress.value, "cidr_blocks", "")))
      ipv6_cidr_blocks = compact(split(",", lookup(egress.value, "ipv6_cidr_blocks", "")))
      prefix_list_ids  = compact(split(",", lookup(egress.value, "prefix_list_ids", "")))
      security_groups  = compact(split(",", lookup(egress.value, "security_groups", "")))
      description      = lookup(egress.value, "description", null)
      from_port        = lookup(egress.value, "from_port", 0)
      to_port          = lookup(egress.value, "to_port", 0)
      protocol         = lookup(egress.value, "protocol", "-1")
    }
  }

  tags = merge(
    { Name = var.default_security_group_name != "" ? var.default_security_group_name : format("%s-default", var.name) },
    var.tags,
    var.default_security_group_tags
  )
}

###################
# Internet gateways
###################

resource "aws_internet_gateway" "this" {
  count = local.internet_gateway_create ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    { Name = var.internet_gateway_name != "" ? var.internet_gateway_name : format("%s", var.name) },
    var.tags,
    var.internet_gateway_tags,
  )
}

resource "aws_egress_only_internet_gateway" "this" {
  count = local.egress_only_igw_create ? 1 : 0

  vpc_id = local.vpc_id

  tags = merge(
    { Name = var.egress_only_igw_name != "" ? var.egress_only_igw_name : format("%s", var.name) },
    var.tags,
    var.egress_only_igw_tags,
  )
}

##############
# NAT Gateways
##############

resource "aws_eip" "nat" {
  count = length(var.nat_gateway_allocation_ids) == 0 && var.nat_gateway_enable ? local.nat_gateway_count : 0

  vpc = true

  tags = merge(
    {
      Name = format(
        "%s%s%s%s%s",
        var.name,
        var.name != "" ? "-" : "",
        var.nat_gateway_eip_name_suffix,
        var.nat_gateway_eip_name_suffix != "" ? "-" : "",
        var.azs_short_name ? replace(
          local.nat_gateway_azs[count.index],
          data.aws_region.current.name,
          ""
        ) : local.nat_gateway_azs[count.index]
      )
    },
    var.tags,
    var.nat_gateway_eip_tags
  )
}

resource "aws_nat_gateway" "this" {
  count = var.nat_gateway_enable ? local.nat_gateway_count : 0

  allocation_id = element(local.nat_gateway_allocation_ids, count.index)
  subnet_id     = matchkeys(module.public.subnets.*.id, module.public.subnets.*.availability_zone, [local.nat_gateway_azs[count.index]])[0]

  tags = merge(
    {
      Name = format(
        "%s%s%s",
        var.name,
        var.name != "" ? "-" : "",
        var.azs_short_name ? replace(
          local.nat_gateway_azs[count.index],
          data.aws_region.current.name,
          ""
        ) : local.nat_gateway_azs[count.index]

      )
    },
    var.tags,
    var.nat_gateway_tags,
  )

  depends_on = [aws_internet_gateway.this]
}

###############
# VPC Endpoints
###############

module "vpc_endpoints" {
  source = "./modules/vpc-endpoint"

  for_each = var.vpc_endpoints

  name               = var.name
  vpc_id             = local.vpc_id
  endpoint           = each.key
  security_group_ids = each.value == true ? [] : lookup(each.value, "security_group_ids", [])
  subnet_ids = each.value == true ? local.vpc_endpoints_subnet_ids_default : concat(
    lookup(each.value, "public", true) ? module.public.subnets.*.id : [],
    lookup(each.value, "private", true) ? module.private.subnets.*.id : [],
    lookup(each.value, "intra", true) ? module.intra.subnets.*.id : [],
    lookup(each.value, "database", false) ? module.database.subnets.*.id : [],
    lookup(each.value, "elasticache", false) ? module.elasticache.subnets.*.id : [],
    lookup(each.value, "redshift", false) ? module.redshift.subnets.*.id : [],
    lookup(each.value, "elasticsearch", false) ? module.elasticsearch.subnets.*.id : [],
    lookup(each.value, "custom1", false) ? module.custom1.subnets.*.id : [],
    lookup(each.value, "custom2", false) ? module.custom2.subnets.*.id : [],
    lookup(each.value, "custom3", false) ? module.custom3.subnets.*.id : []
  )
  route_table_ids = each.value == true ? local.vpc_endpoints_route_table_ids_default : concat(
    lookup(each.value, "public", true) ? module.public.route_table_ids : [],
    lookup(each.value, "private", true) ? module.private.route_table_ids : [],
    lookup(each.value, "intra", true) ? module.intra.route_table_ids : [],
    lookup(each.value, "database", false) ? module.database.route_table_ids : [],
    lookup(each.value, "elasticache", false) ? module.elasticache.route_table_ids : [],
    lookup(each.value, "redshift", false) ? module.redshift.route_table_ids : [],
    lookup(each.value, "elasticsearch", false) ? module.elasticsearch.route_table_ids : [],
    lookup(each.value, "custom1", false) ? module.custom1.route_table_ids : [],
    lookup(each.value, "custom2", false) ? module.custom2.route_table_ids : [],
    lookup(each.value, "custom3", false) ? module.custom3.route_table_ids : []
  )
  route_table_association_num = each.value == true ? local.vpc_endpoints_route_table_num_default : sum([
    lookup(each.value, "public", true) ? local.public_route_table_num : 0,
    lookup(each.value, "private", true) ? local.private_route_table_num : 0,
    lookup(each.value, "intra", true) ? local.intra_route_table_num : 0,
    lookup(each.value, "database", false) ? local.database_route_table_num : 0,
    lookup(each.value, "elasticache", false) ? local.elasticache_route_table_num : 0,
    lookup(each.value, "redshift", false) ? local.redshift_route_table_num : 0,
    lookup(each.value, "elasticsearch", false) ? local.elasticsearch_route_table_num : 0,
    lookup(each.value, "custom1", false) ? local.custom1_route_table_num : 0,
    lookup(each.value, "custom2", false) ? local.custom2_route_table_num : 0,
    lookup(each.value, "custom3", false) ? local.custom3_route_table_num : 0
  ])
  private_dns_enabled = each.value == true ? false : lookup(each.value, "private_dns_enabled", false)

  sagemaker_notebook_endpoint_region = each.value == true ? "" : lookup(each.value, "sagemaker_notebook_endpoint_region", "")
  tags = merge(
    var.tags,
    var.vpc_endpoints_tags,
    each.value == true ? {} : lookup(each.value, "tags", {})
  )
}

#############
# VPN Gateway
#############

resource "aws_vpn_gateway" "this" {
  count = var.vpn_gateway_create ? 1 : 0

  vpc_id            = local.vpc_id
  amazon_side_asn   = var.vpn_gateway_amazon_side_asn
  availability_zone = var.vpn_gateway_availability_zone

  tags = merge(
    { Name = var.vpn_gateway_name != "" ? var.vpn_gateway_name : var.name },
    var.tags,
    var.vpn_gateway_tags
  )
}

resource "aws_vpn_gateway_attachment" "this" {
  count = var.vpn_gateway_id != "" && var.vpn_gateway_create == false ? 1 : 0

  vpc_id         = local.vpc_id
  vpn_gateway_id = var.vpn_gateway_id
}

################
# Public subnets
################

module "public" {
  source = "./modules/subnets"

  name = format(
    "%s%s%s",
    var.name,
    var.name != "" && var.private_name_suffix != "" ? "-" : "",
    var.public_name_suffix
  )

  vpc_id              = local.vpc_id
  azs                 = local.public_azs
  azs_short_name      = var.azs_short_name
  cidrs               = var.public_cidrs
  enable_ipv6         = var.enable_ipv6
  vpc_ipv6_cidr_block = var.enable_ipv6 ? aws_vpc.this.ipv6_cidr_block : null
  ipv6_prefixes       = var.enable_ipv6 ? var.public_ipv6_prefixes : null

  internet_gateway_id                = local.internet_gateway_create ? aws_internet_gateway.this[0].id : null
  egress_only_igw_id                 = local.egress_only_igw_create ? aws_egress_only_internet_gateway.this[0].id : null
  map_public_ip_on_launch            = var.public_map_public_ip_on_launch
  map_public_ip_on_launch_per_subnet = var.public_map_public_ip_on_launch_per_subnet

  assign_ipv6_address_on_creation            = var.enable_ipv6 ? var.public_assign_ipv6_address_on_creation : null
  assign_ipv6_address_on_creation_per_subnet = var.enable_ipv6 ? var.public_assign_ipv6_address_on_creation_per_subnet : null

  route_table_create               = true
  route_table_single               = var.public_route_table_separate == false ? true : false
  route_table_tags                 = var.public_route_table_tags
  route_table_tags_per_route_table = var.public_route_table_tags_per_route_table

  network_acl_create         = var.public_network_acl_enabled
  network_acl_inbound_rules  = var.public_network_acl_inbound_rules
  network_acl_outbound_rules = var.public_network_acl_outbound_rules
  network_acl_tags           = var.public_network_acl_tags

  vpn_gateway_id = var.public_route_table_vgw_propagation ? local.vpn_gateway_id : ""

  tags            = merge(var.tags, var.public_tags)
  tags_per_subnet = var.public_tags_per_subnet
}

#################
# Private subnets
#################

module "private" {
  source = "./modules/subnets"

  name = format(
    "%s%s%s",
    var.name,
    var.name != "" && var.private_name_suffix != "" ? "-" : "",
    var.private_name_suffix
  )

  vpc_id              = local.vpc_id
  azs                 = local.private_azs
  azs_short_name      = var.azs_short_name
  cidrs               = var.private_cidrs
  enable_ipv6         = var.enable_ipv6
  vpc_ipv6_cidr_block = var.enable_ipv6 ? aws_vpc.this.ipv6_cidr_block : null
  ipv6_prefixes       = var.enable_ipv6 ? var.private_ipv6_prefixes : null

  map_public_ip_on_launch = false
  nat_gateways_ids        = local.private_nat_gateways_ids

  assign_ipv6_address_on_creation            = var.enable_ipv6 ? var.private_assign_ipv6_address_on_creation : null
  assign_ipv6_address_on_creation_per_subnet = var.enable_ipv6 ? var.private_assign_ipv6_address_on_creation_per_subnet : null

  route_table_create               = true
  route_table_single               = local.private_route_table_single
  route_table_tags                 = var.private_route_table_tags
  route_table_tags_per_route_table = var.private_route_table_tags_per_route_table

  network_acl_create         = var.private_network_acl_enabled
  network_acl_inbound_rules  = var.private_network_acl_inbound_rules
  network_acl_outbound_rules = var.private_network_acl_outbound_rules
  network_acl_tags           = var.private_network_acl_tags

  db_subnet_group_create = var.private_db_subnet_group_create
  db_subnet_group_name = var.private_db_subnet_group_name != "" ? var.private_db_subnet_group_name : format(
    "%s%s%s",
    var.name,
    var.name != "" && var.private_name_suffix != "" ? "-" : "",
    var.private_name_suffix
  )
  db_subnet_group_description = var.private_db_subnet_group_description != "" ? var.private_db_subnet_group_description : "Database subnet group for ${var.name}"
  db_subnet_group_tags        = var.private_db_subnet_group_tags
  db_subnet_group_azs         = var.private_db_subnet_group_azs

  elasticache_subnet_group_create = var.private_elasticache_subnet_group_create
  elasticache_subnet_group_name = var.private_elasticache_subnet_group_name != "" ? var.private_elasticache_subnet_group_name : format(
    "%s%s%s",
    var.name,
    var.name != "" && var.private_name_suffix != "" ? "-" : "",
    var.private_name_suffix
  )
  elasticache_subnet_group_description = var.private_elasticache_subnet_group_description != "" ? var.private_elasticache_subnet_group_description : "ElastiCache subnet group for ${var.name}"
  elasticache_subnet_group_azs         = var.private_elasticache_subnet_group_azs

  redshift_subnet_group_create = var.private_redshift_subnet_group_create
  redshift_subnet_group_name = var.private_redshift_subnet_group_name != "" ? var.private_redshift_subnet_group_name : format(
    "%s%s%s",
    var.name,
    var.name != "" && var.private_name_suffix != "" ? "-" : "",
    var.private_name_suffix
  )
  redshift_subnet_group_description = var.private_redshift_subnet_group_description != "" ? var.private_redshift_subnet_group_description : "Redshift subnet group for ${var.name}"
  redshift_subnet_group_tags        = var.private_redshift_subnet_group_tags
  redshift_subnet_group_azs         = var.private_redshift_subnet_group_azs

  vpn_gateway_id = var.private_route_table_vgw_propagation ? local.vpn_gateway_id : ""

  tags            = merge(var.tags, var.private_tags)
  tags_per_subnet = var.private_tags_per_subnet
}

#################
# Intra subnets
#################

module "intra" {
  source = "./modules/subnets"

  name = format(
    "%s%s%s",
    var.name,
    var.name != "" && var.intra_name_suffix != "" ? "-" : "",
    var.intra_name_suffix
  )

  vpc_id              = local.vpc_id
  azs                 = local.intra_azs
  azs_short_name      = var.azs_short_name
  cidrs               = var.intra_cidrs
  enable_ipv6         = var.enable_ipv6
  vpc_ipv6_cidr_block = var.enable_ipv6 ? aws_vpc.this.ipv6_cidr_block : null
  ipv6_prefixes       = var.enable_ipv6 ? var.intra_ipv6_prefixes : null

  map_public_ip_on_launch = false
  nat_gateways_ids        = []

  assign_ipv6_address_on_creation = false

  route_table_create               = true
  route_table_single               = var.intra_route_table_separate == false
  route_table_tags                 = var.intra_route_table_tags
  route_table_tags_per_route_table = var.intra_route_table_tags_per_route_table

  network_acl_create         = var.intra_network_acl_enabled
  network_acl_inbound_rules  = var.intra_network_acl_inbound_rules
  network_acl_outbound_rules = var.intra_network_acl_outbound_rules
  network_acl_tags           = var.intra_network_acl_tags

  db_subnet_group_create          = false
  elasticache_subnet_group_create = false
  redshift_subnet_group_create    = false

  tags            = merge(var.tags, var.intra_tags)
  tags_per_subnet = var.intra_tags_per_subnet
}

##################
# Database subnets
##################

module "database" {
  source = "./modules/subnets"

  name = format(
    "%s%s%s",
    var.name,
    var.name != "" && var.database_name_suffix != "" ? "-" : "",
    var.database_name_suffix
  )

  vpc_id              = local.vpc_id
  azs                 = local.database_azs
  azs_short_name      = var.azs_short_name
  cidrs               = var.database_cidrs
  enable_ipv6         = var.enable_ipv6
  vpc_ipv6_cidr_block = var.enable_ipv6 ? aws_vpc.this.ipv6_cidr_block : ""
  ipv6_prefixes       = var.enable_ipv6 ? var.database_ipv6_prefixes : []

  map_public_ip_on_launch            = var.database_map_public_ip_on_launch
  map_public_ip_on_launch_per_subnet = var.database_map_public_ip_on_launch_per_subnet

  nat_gateways_ids    = local.database_nat_gateways_ids
  internet_gateway_id = local.internet_gateway_create && var.database_enable_public_route ? aws_internet_gateway.this[0].id : ""
  egress_only_igw_id  = local.egress_only_igw_create && var.database_enable_public_route ? aws_egress_only_internet_gateway.this[0].id : ""

  assign_ipv6_address_on_creation            = var.enable_ipv6 ? var.database_assign_ipv6_address_on_creation : false
  assign_ipv6_address_on_creation_per_subnet = var.enable_ipv6 ? var.database_assign_ipv6_address_on_creation_per_subnet : []

  route_table_create               = var.database_route_table_create
  route_table_ids                  = local.database_route_table_use_private_rt ? module.private.route_tables.*.id : local.database_route_table_use_public_rt ? module.public.route_tables.*.id : []
  route_table_single               = local.database_route_table_single
  route_table_tags                 = var.database_route_table_tags
  route_table_tags_per_route_table = var.database_route_table_tags_per_route_table

  network_acl_create         = var.database_network_acl_enabled
  network_acl_inbound_rules  = var.database_network_acl_inbound_rules
  network_acl_outbound_rules = var.database_network_acl_outbound_rules
  network_acl_tags           = var.database_network_acl_tags

  db_subnet_group_create      = var.database_db_subnet_group_create
  db_subnet_group_name        = var.database_db_subnet_group_name != "" ? var.database_db_subnet_group_name : var.name
  db_subnet_group_description = var.database_db_subnet_group_description != "" ? var.database_db_subnet_group_description : "Database subnet group for ${var.name}"
  db_subnet_group_tags        = var.database_db_subnet_group_tags
  db_subnet_group_azs         = var.database_db_subnet_group_azs

  vpn_gateway_id = var.database_route_table_vgw_propagation ? local.vpn_gateway_id : ""

  tags            = merge(var.tags, var.database_tags)
  tags_per_subnet = var.database_tags_per_subnet
}

#####################
# Elasticache subnets
#####################

module "elasticache" {
  source = "./modules/subnets"

  name = format(
    "%s%s%s",
    var.name,
    var.name != "" && var.private_name_suffix != "" ? "-" : "",
    var.elasticache_name_suffix
  )

  vpc_id              = local.vpc_id
  azs                 = local.elasticache_azs
  azs_short_name      = var.azs_short_name
  cidrs               = var.elasticache_cidrs
  enable_ipv6         = var.enable_ipv6
  vpc_ipv6_cidr_block = var.enable_ipv6 ? aws_vpc.this.ipv6_cidr_block : ""
  ipv6_prefixes       = var.enable_ipv6 ? var.elasticache_ipv6_prefixes : []

  map_public_ip_on_launch            = var.elasticache_map_public_ip_on_launch
  map_public_ip_on_launch_per_subnet = var.elasticache_map_public_ip_on_launch_per_subnet

  nat_gateways_ids    = local.elasticache_nat_gateways_ids
  internet_gateway_id = local.internet_gateway_create && var.elasticache_enable_public_route ? aws_internet_gateway.this[0].id : ""
  egress_only_igw_id  = local.egress_only_igw_create && var.elasticache_enable_public_route ? aws_egress_only_internet_gateway.this[0].id : ""

  assign_ipv6_address_on_creation            = var.enable_ipv6 ? var.elasticache_assign_ipv6_address_on_creation : false
  assign_ipv6_address_on_creation_per_subnet = var.enable_ipv6 ? var.elasticache_assign_ipv6_address_on_creation_per_subnet : []

  route_table_create               = var.elasticache_route_table_create
  route_table_ids                  = local.elasticache_route_table_use_private_rt ? module.private.route_tables.*.id : local.elasticache_route_table_use_public_rt ? module.public.route_tables.*.id : []
  route_table_single               = local.elasticache_route_table_single
  route_table_tags                 = var.elasticache_route_table_tags
  route_table_tags_per_route_table = var.elasticache_route_table_tags_per_route_table

  network_acl_create         = var.elasticache_network_acl_enabled
  network_acl_inbound_rules  = var.elasticache_network_acl_inbound_rules
  network_acl_outbound_rules = var.elasticache_network_acl_outbound_rules
  network_acl_tags           = var.elasticache_network_acl_tags

  elasticache_subnet_group_create      = var.elasticache_elasticache_subnet_group_create
  elasticache_subnet_group_name        = var.elasticache_elasticache_subnet_group_name != "" ? var.elasticache_elasticache_subnet_group_name : var.name
  elasticache_subnet_group_description = var.elasticache_elasticache_subnet_group_description != "" ? var.elasticache_elasticache_subnet_group_description : "ElastiCache subnet group for ${var.name}"
  elasticache_subnet_group_azs         = var.elasticache_elasticache_subnet_group_azs

  tags            = merge(var.tags, var.elasticache_tags)
  tags_per_subnet = var.elasticache_tags_per_subnet
}

#####################
# Redshift subnets
#####################

module "redshift" {
  source = "./modules/subnets"

  name = format(
    "%s%s%s",
    var.name,
    var.name != "" && var.private_name_suffix != "" ? "-" : "",
    var.redshift_name_suffix
  )

  vpc_id              = local.vpc_id
  azs                 = local.redshift_azs
  azs_short_name      = var.azs_short_name
  cidrs               = var.redshift_cidrs
  enable_ipv6         = var.enable_ipv6
  vpc_ipv6_cidr_block = var.enable_ipv6 ? aws_vpc.this.ipv6_cidr_block : ""
  ipv6_prefixes       = var.enable_ipv6 ? var.redshift_ipv6_prefixes : []

  map_public_ip_on_launch            = var.redshift_map_public_ip_on_launch
  map_public_ip_on_launch_per_subnet = var.redshift_map_public_ip_on_launch_per_subnet

  nat_gateways_ids    = local.redshift_nat_gateways_ids
  internet_gateway_id = local.internet_gateway_create && var.redshift_enable_public_route ? aws_internet_gateway.this[0].id : ""
  egress_only_igw_id  = local.egress_only_igw_create && var.redshift_enable_public_route ? aws_egress_only_internet_gateway.this[0].id : ""

  assign_ipv6_address_on_creation            = var.enable_ipv6 ? var.redshift_assign_ipv6_address_on_creation : false
  assign_ipv6_address_on_creation_per_subnet = var.enable_ipv6 ? var.redshift_assign_ipv6_address_on_creation_per_subnet : []

  route_table_create               = var.redshift_route_table_create
  route_table_ids                  = local.redshift_route_table_use_private_rt ? module.private.route_tables.*.id : local.redshift_route_table_use_public_rt ? module.public.route_tables.*.id : []
  route_table_single               = local.redshift_route_table_single
  route_table_tags                 = var.redshift_route_table_tags
  route_table_tags_per_route_table = var.redshift_route_table_tags_per_route_table

  network_acl_create         = var.redshift_network_acl_enabled
  network_acl_inbound_rules  = var.redshift_network_acl_inbound_rules
  network_acl_outbound_rules = var.redshift_network_acl_outbound_rules
  network_acl_tags           = var.redshift_network_acl_tags

  redshift_subnet_group_create      = var.redshift_redshift_subnet_group_create
  redshift_subnet_group_name        = var.redshift_redshift_subnet_group_name != "" ? var.redshift_redshift_subnet_group_name : var.name
  redshift_subnet_group_description = var.redshift_redshift_subnet_group_description != "" ? var.redshift_redshift_subnet_group_description : "Redshift subnet group for ${var.name}"
  redshift_subnet_group_tags        = var.redshift_redshift_subnet_group_tags
  redshift_subnet_group_azs         = var.redshift_redshift_subnet_group_azs

  vpn_gateway_id = var.redshift_route_table_vgw_propagation ? local.vpn_gateway_id : ""

  tags            = merge(var.tags, var.redshift_tags)
  tags_per_subnet = var.redshift_tags_per_subnet
}

#######################
# ElasticSearch subnets
#######################

module "elasticsearch" {
  source = "./modules/subnets"

  name = format(
    "%s%s%s",
    var.name,
    var.name != "" && var.private_name_suffix != "" ? "-" : "",
    var.elasticsearch_name_suffix
  )

  vpc_id              = local.vpc_id
  azs                 = local.elasticsearch_azs
  azs_short_name      = var.azs_short_name
  cidrs               = var.elasticsearch_cidrs
  enable_ipv6         = var.enable_ipv6
  vpc_ipv6_cidr_block = var.enable_ipv6 ? aws_vpc.this.ipv6_cidr_block : ""
  ipv6_prefixes       = var.enable_ipv6 ? var.elasticsearch_ipv6_prefixes : []

  map_public_ip_on_launch            = var.elasticsearch_map_public_ip_on_launch
  map_public_ip_on_launch_per_subnet = var.elasticsearch_map_public_ip_on_launch_per_subnet

  nat_gateways_ids    = local.elasticsearch_nat_gateways_ids
  internet_gateway_id = local.internet_gateway_create && var.elasticsearch_enable_public_route ? aws_internet_gateway.this[0].id : ""
  egress_only_igw_id  = local.egress_only_igw_create && var.elasticsearch_enable_public_route ? aws_egress_only_internet_gateway.this[0].id : ""

  assign_ipv6_address_on_creation            = var.enable_ipv6 ? var.elasticsearch_assign_ipv6_address_on_creation : false
  assign_ipv6_address_on_creation_per_subnet = var.enable_ipv6 ? var.elasticsearch_assign_ipv6_address_on_creation_per_subnet : []

  route_table_create               = var.elasticsearch_route_table_create
  route_table_ids                  = local.elasticsearch_route_table_use_private_rt ? module.private.route_tables.*.id : local.elasticsearch_route_table_use_public_rt ? module.public.route_tables.*.id : []
  route_table_single               = local.elasticsearch_route_table_single
  route_table_tags                 = var.elasticsearch_route_table_tags
  route_table_tags_per_route_table = var.elasticsearch_route_table_tags_per_route_table

  network_acl_create         = var.elasticsearch_network_acl_enabled
  network_acl_inbound_rules  = var.elasticsearch_network_acl_inbound_rules
  network_acl_outbound_rules = var.elasticsearch_network_acl_outbound_rules
  network_acl_tags           = var.elasticsearch_network_acl_tags

  vpn_gateway_id = var.elasticsearch_route_table_vgw_propagation ? local.vpn_gateway_id : ""

  tags            = merge(var.tags, var.elasticsearch_tags)
  tags_per_subnet = var.elasticsearch_tags_per_subnet
}

#################
# Custom1 subnets
#################

module "custom1" {
  source = "./modules/subnets"

  name = format(
    "%s%s%s",
    var.name,
    var.name != "" && var.custom1_name_suffix != "" ? "-" : "",
    var.custom1_name_suffix
  )

  vpc_id              = local.vpc_id
  azs                 = local.custom1_azs
  azs_short_name      = var.azs_short_name
  cidrs               = var.custom1_cidrs
  enable_ipv6         = var.enable_ipv6
  vpc_ipv6_cidr_block = var.enable_ipv6 ? aws_vpc.this.ipv6_cidr_block : ""
  ipv6_prefixes       = var.enable_ipv6 ? var.custom1_ipv6_prefixes : []

  nat_gateways_ids                   = local.custom1_nat_gateways_ids
  internet_gateway_id                = local.internet_gateway_create && var.custom1_enable_public_route ? aws_internet_gateway.this[0].id : ""
  egress_only_igw_id                 = local.egress_only_igw_create && var.custom1_enable_public_route ? aws_egress_only_internet_gateway.this[0].id : ""
  map_public_ip_on_launch            = var.custom1_map_public_ip_on_launch
  map_public_ip_on_launch_per_subnet = var.custom1_map_public_ip_on_launch_per_subnet

  assign_ipv6_address_on_creation            = var.enable_ipv6 ? var.custom1_assign_ipv6_address_on_creation : false
  assign_ipv6_address_on_creation_per_subnet = var.enable_ipv6 ? var.custom1_assign_ipv6_address_on_creation_per_subnet : []

  route_table_create               = var.custom1_route_table_create
  route_table_ids                  = var.custom1_route_table_ids
  route_table_single               = var.custom1_route_table_separate == false
  route_table_tags                 = var.custom1_route_table_tags
  route_table_tags_per_route_table = var.custom1_route_table_tags_per_route_table

  network_acl_create         = var.custom1_network_acl_enabled
  network_acl_inbound_rules  = var.custom1_network_acl_inbound_rules
  network_acl_outbound_rules = var.custom1_network_acl_outbound_rules
  network_acl_tags           = var.custom1_network_acl_tags

  db_subnet_group_create = var.custom1_db_subnet_group_create
  db_subnet_group_name = var.custom1_db_subnet_group_name != "" ? var.custom1_db_subnet_group_name : format(
    "%s%s%s",
    var.name,
    var.name != "" && var.custom1_name_suffix != "" ? "-" : "",
    var.custom1_name_suffix
  )
  db_subnet_group_description = var.custom1_db_subnet_group_description != "" ? var.custom1_db_subnet_group_description : "Database subnet group for ${var.name}-custom1"
  db_subnet_group_tags        = var.custom1_db_subnet_group_tags
  db_subnet_group_azs         = var.custom1_db_subnet_group_azs

  elasticache_subnet_group_create = var.custom1_elasticache_subnet_group_create
  elasticache_subnet_group_name = var.custom1_elasticache_subnet_group_name != "" ? var.custom1_elasticache_subnet_group_name : format(
    "%s%s%s",
    var.name,
    var.name != "" && var.custom1_name_suffix != "" ? "-" : "",
    var.custom1_name_suffix
  )
  elasticache_subnet_group_description = var.custom1_elasticache_subnet_group_description != "" ? var.custom1_elasticache_subnet_group_description : "Elasticache subnet group for ${var.name}-custom1"
  elasticache_subnet_group_azs         = var.custom1_elasticache_subnet_group_azs

  redshift_subnet_group_create = var.custom1_redshift_subnet_group_create
  redshift_subnet_group_name = var.custom1_redshift_subnet_group_name != "" ? var.custom1_redshift_subnet_group_name : format(
    "%s%s%s",
    var.name,
    var.name != "" && var.custom1_name_suffix != "" ? "-" : "",
    var.custom1_name_suffix
  )
  redshift_subnet_group_description = var.custom1_redshift_subnet_group_description != "" ? var.custom1_redshift_subnet_group_description : "Redshift subnet group for ${var.name}-custom1"
  redshift_subnet_group_tags        = var.custom1_redshift_subnet_group_tags
  redshift_subnet_group_azs         = var.custom1_redshift_subnet_group_azs

  vpn_gateway_id = var.custom1_route_table_vgw_propagation ? local.vpn_gateway_id : ""

  tags            = merge(var.tags, var.custom1_tags)
  tags_per_subnet = var.custom1_tags_per_subnet
}

#################
# Custom2 subnets
#################

module "custom2" {
  source = "./modules/subnets"

  name = format(
    "%s%s%s",
    var.name,
    var.name != "" && var.custom2_name_suffix != "" ? "-" : "",
    var.custom2_name_suffix
  )

  vpc_id              = local.vpc_id
  azs                 = local.custom2_azs
  azs_short_name      = var.azs_short_name
  cidrs               = var.custom2_cidrs
  enable_ipv6         = var.enable_ipv6
  vpc_ipv6_cidr_block = var.enable_ipv6 ? aws_vpc.this.ipv6_cidr_block : ""
  ipv6_prefixes       = var.enable_ipv6 ? var.custom2_ipv6_prefixes : []

  nat_gateways_ids                   = local.custom2_nat_gateways_ids
  internet_gateway_id                = local.internet_gateway_create && var.custom2_enable_public_route ? aws_internet_gateway.this[0].id : ""
  egress_only_igw_id                 = local.egress_only_igw_create && var.custom2_enable_public_route ? aws_egress_only_internet_gateway.this[0].id : ""
  map_public_ip_on_launch            = var.custom2_map_public_ip_on_launch
  map_public_ip_on_launch_per_subnet = var.custom2_map_public_ip_on_launch_per_subnet

  assign_ipv6_address_on_creation            = var.enable_ipv6 ? var.custom2_assign_ipv6_address_on_creation : false
  assign_ipv6_address_on_creation_per_subnet = var.enable_ipv6 ? var.custom2_assign_ipv6_address_on_creation_per_subnet : []

  route_table_create               = var.custom2_route_table_create
  route_table_ids                  = var.custom2_route_table_ids
  route_table_single               = var.custom2_route_table_separate == false
  route_table_tags                 = var.custom2_route_table_tags
  route_table_tags_per_route_table = var.custom2_route_table_tags_per_route_table

  network_acl_create         = var.custom2_network_acl_enabled
  network_acl_inbound_rules  = var.custom2_network_acl_inbound_rules
  network_acl_outbound_rules = var.custom2_network_acl_outbound_rules
  network_acl_tags           = var.custom2_network_acl_tags

  db_subnet_group_create = var.custom2_db_subnet_group_create
  db_subnet_group_name = var.custom2_db_subnet_group_name != "" ? var.custom2_db_subnet_group_name : format(
    "%s%s%s",
    var.name,
    var.name != "" && var.custom2_name_suffix != "" ? "-" : "",
    var.custom2_name_suffix
  )
  db_subnet_group_description = var.custom2_db_subnet_group_description != "" ? var.custom2_db_subnet_group_description : "Database subnet group for ${var.name}-custom2"
  db_subnet_group_tags        = var.custom2_db_subnet_group_tags
  db_subnet_group_azs         = var.custom2_db_subnet_group_azs

  elasticache_subnet_group_create = var.custom2_elasticache_subnet_group_create
  elasticache_subnet_group_name = var.custom2_elasticache_subnet_group_name != "" ? var.custom2_elasticache_subnet_group_name : format(
    "%s%s%s",
    var.name,
    var.name != "" && var.custom2_name_suffix != "" ? "-" : "",
    var.custom2_name_suffix
  )
  elasticache_subnet_group_description = var.custom2_elasticache_subnet_group_description != "" ? var.custom2_elasticache_subnet_group_description : "Elasticache subnet group for ${var.name}-custom2"
  elasticache_subnet_group_azs         = var.custom2_elasticache_subnet_group_azs

  redshift_subnet_group_create = var.custom2_redshift_subnet_group_create
  redshift_subnet_group_name = var.custom2_redshift_subnet_group_name != "" ? var.custom2_redshift_subnet_group_name : format(
    "%s%s%s",
    var.name,
    var.name != "" && var.custom2_name_suffix != "" ? "-" : "",
    var.custom2_name_suffix
  )
  redshift_subnet_group_description = var.custom2_redshift_subnet_group_description != "" ? var.custom2_redshift_subnet_group_description : "Redshift subnet group for ${var.name}-custom2"
  redshift_subnet_group_tags        = var.custom2_redshift_subnet_group_tags
  redshift_subnet_group_azs         = var.custom2_redshift_subnet_group_azs

  vpn_gateway_id = var.custom2_route_table_vgw_propagation ? local.vpn_gateway_id : ""

  tags            = merge(var.tags, var.custom2_tags)
  tags_per_subnet = var.custom2_tags_per_subnet
}

#################
# Custom3 subnets
#################

module "custom3" {
  source = "./modules/subnets"

  name = format(
    "%s%s%s",
    var.name,
    var.name != "" && var.custom3_name_suffix != "" ? "-" : "",
    var.custom3_name_suffix
  )

  vpc_id              = local.vpc_id
  azs                 = local.custom3_azs
  azs_short_name      = var.azs_short_name
  cidrs               = var.custom3_cidrs
  enable_ipv6         = var.enable_ipv6
  vpc_ipv6_cidr_block = var.enable_ipv6 ? aws_vpc.this.ipv6_cidr_block : ""
  ipv6_prefixes       = var.enable_ipv6 ? var.custom3_ipv6_prefixes : []

  nat_gateways_ids                   = local.custom3_nat_gateways_ids
  internet_gateway_id                = local.internet_gateway_create && var.custom3_enable_public_route ? aws_internet_gateway.this[0].id : ""
  egress_only_igw_id                 = local.egress_only_igw_create && var.custom3_enable_public_route ? aws_egress_only_internet_gateway.this[0].id : ""
  map_public_ip_on_launch            = var.custom3_map_public_ip_on_launch
  map_public_ip_on_launch_per_subnet = var.custom3_map_public_ip_on_launch_per_subnet

  assign_ipv6_address_on_creation            = var.enable_ipv6 ? var.custom3_assign_ipv6_address_on_creation : false
  assign_ipv6_address_on_creation_per_subnet = var.enable_ipv6 ? var.custom3_assign_ipv6_address_on_creation_per_subnet : []

  route_table_create               = var.custom3_route_table_create
  route_table_ids                  = var.custom3_route_table_ids
  route_table_single               = var.custom3_route_table_separate == false
  route_table_tags                 = var.custom3_route_table_tags
  route_table_tags_per_route_table = var.custom3_route_table_tags_per_route_table

  network_acl_create         = var.custom3_network_acl_enabled
  network_acl_inbound_rules  = var.custom3_network_acl_inbound_rules
  network_acl_outbound_rules = var.custom3_network_acl_outbound_rules
  network_acl_tags           = var.custom3_network_acl_tags

  db_subnet_group_create = var.custom3_db_subnet_group_create
  db_subnet_group_name = var.custom3_db_subnet_group_name != "" ? var.custom3_db_subnet_group_name : format(
    "%s%s%s",
    var.name,
    var.name != "" && var.custom3_name_suffix != "" ? "-" : "",
    var.custom3_name_suffix
  )
  db_subnet_group_description = var.custom3_db_subnet_group_description != "" ? var.custom3_db_subnet_group_description : "Database subnet group for ${var.name}-custom3"
  db_subnet_group_tags        = var.custom3_db_subnet_group_tags
  db_subnet_group_azs         = var.custom3_db_subnet_group_azs

  elasticache_subnet_group_create = var.custom3_elasticache_subnet_group_create
  elasticache_subnet_group_name = var.custom3_elasticache_subnet_group_name != "" ? var.custom3_elasticache_subnet_group_name : format(
    "%s%s%s",
    var.name,
    var.name != "" && var.custom3_name_suffix != "" ? "-" : "",
    var.custom3_name_suffix
  )
  elasticache_subnet_group_description = var.custom3_elasticache_subnet_group_description != "" ? var.custom3_elasticache_subnet_group_description : "Elasticache subnet group for ${var.name}-custom3"
  elasticache_subnet_group_azs         = var.custom3_elasticache_subnet_group_azs

  redshift_subnet_group_create = var.custom3_redshift_subnet_group_create
  redshift_subnet_group_name = var.custom3_redshift_subnet_group_name != "" ? var.custom3_redshift_subnet_group_name : format(
    "%s%s%s",
    var.name,
    var.name != "" && var.custom3_name_suffix != "" ? "-" : "",
    var.custom3_name_suffix
  )
  redshift_subnet_group_description = var.custom3_redshift_subnet_group_description != "" ? var.custom3_redshift_subnet_group_description : "Redshift subnet group for ${var.name}-custom3"
  redshift_subnet_group_tags        = var.custom3_redshift_subnet_group_tags
  redshift_subnet_group_azs         = var.custom3_redshift_subnet_group_azs

  vpn_gateway_id = var.custom3_route_table_vgw_propagation ? local.vpn_gateway_id : ""

  tags            = merge(var.tags, var.custom3_tags)
  tags_per_subnet = var.custom3_tags_per_subnet
}
