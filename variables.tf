##################
# global variables
##################

variable "name" {
  description = "Identified which will be used on all created resources in the Nmae tag"
  type        = string
  default     = ""
}

variable "azs" {
  description = "List of availability zones names or ids in the region"
  type        = list(string)
}

variable "azs_short_name" {
  description = "Use only AZ letter in tags instead of full AZ name in per-az resources"
  type        = bool
  default     = false
}

variable "tags" {
  description = "List of tags to be added to all created resources"
  type        = map(string)
  default     = {}
}

###############
# vpc variables
###############

variable "cidr" {
  description = "The CIDR block for the vpc"
  type        = string
}

variable "secondary_cidr_blocks" {
  description = "The list of secondary CIDR blocks to be associated to the VPC"
  type        = list(string)
  default     = []
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  type        = string
  default     = "default"
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  type        = bool
  default     = false
}

variable "enable_classiclink" {
  description = "A boolean flag to enable/disable ClassicLink for the VPC. Only valid in regions and accounts that support EC2 Classic"
  type        = bool
  default     = false
}

variable "enable_classiclink_dns_support" {
  description = "A boolean flag to enable/disable ClassicLink DNS Support for the VPC. Only valid in regions and accounts that support EC2 Classic"
  type        = bool
  default     = false
}

variable "enable_ipv6" {
  description = "Enable IPv6 support for the VPC"
  type        = bool
  default     = false
}

variable "vpc_tags" {
  description = "The list of additional tags to be added to the created vpc"
  type        = map(string)
  default     = {}
}

variable "enable_flow_log" {
  description = "Whether or not to enable VPC Flow Logs"
  type        = bool
  default     = false
}

############################
# DHCP options set variables
############################

variable "dhcp_options_enable" {
  description = "Should be true uf you want to manage DHCP options set for the created VPC"
  type        = bool
  default     = false
}

variable "dhcp_options_name" {
  description = "Override Name tag for DHCP options set"
  type        = string
  default     = ""
}

variable "dhcp_options_domain_name" {
  description = "DNS name for DHCP options set (requires dhcp_options_enable = true)"
  type        = string
  default     = ""
}

variable "dhcp_options_domain_name_servers" {
  description = "The list of custom DNS server addresses for DHCP options set (requires dhcp_options_enable = true)"
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}

variable "dhcp_options_ntp_servers" {
  description = "The list of NTP servers for DHCP options set (requires dhcp_options_enable = true)"
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_name_servers" {
  description = "The list of netbios servers for DHCP options set (requires dhcp_options_enable = true)"
  type        = list(string)
  default     = []
}

variable "dhcp_options_netbios_node_type" {
  description = "netbios node_type for DHCP options set (requires dhcp_options_enable = true)"
  type        = string
  default     = ""
}

variable "dhcp_options_tags" {
  description = "Additional tags to add to the DHCP options sset"
  type        = map(string)
  default     = {}
}

###############################
# default network ACL variables
###############################

variable "default_network_acl_manage" {
  description = "Should be true to adopt and manage default network ACL for the created VPC"
  type        = bool
  default     = false
}

variable "default_network_acl_name" {
  description = "Override automatically generated default network ACL name"
  type        = string
  default     = ""
}

variable "default_network_acl_ingress" {
  description = "List of maps of ingress rules to set on the default network ACL"
  type        = list(map(string))
  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    # {
    #   rule_no         = 101
    #   action          = "allow"
    #   from_port       = 0
    #   to_port         = 0
    #   protocol        = "-1"
    #   ipv6_cidr_block = "::/0"
    # },
  ]
}

variable "default_network_acl_egress" {
  description = "List of maps of egress rules to set on the default network ACL"
  type        = list(map(string))
  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    # {
    #   rule_no         = 101
    #   action          = "allow"
    #   from_port       = 0
    #   to_port         = 0
    #   protocol        = "-1"
    #   ipv6_cidr_block = "::/0"
    # },
  ]
}

variable "default_network_acl_tags" {
  description = "Additional tags to add to the default network ACL"
  type        = map(string)
  default     = {}
}

##################################
# default security group variables
##################################

variable "default_security_group_manage" {
  description = "Should be true to adopt and manage default security group for the created VPC"
  type        = bool
  default     = false
}

variable "default_security_group_name" {
  description = "Override automatically generated default security group name"
  type        = string
  default     = ""
}

variable "default_security_group_ingress" {
  description = "List of maps of ingress rules to set on the default security group. You may specify multiple values separated by comma for cidr_blocks, ipv6_cidr_blocks, prefix_list_ids and security_groups"
  type        = list(map(string))
  default     = []
}

variable "default_security_group_egress" {
  description = "List of maps of egress rules to set on the default security group. You may specify multiple values separated by comma for cidr_blocks, ipv6_cidr_blocks, prefix_list_ids and security_groups"
  type        = list(map(string))
  default     = []
}

variable "default_security_group_tags" {
  description = "Additional tags to add to the default security group"
  type        = map(string)
  default     = {}
}

#############################
# internet gateway variables
#############################

variable "internet_gateway_create" {
  description = "Should internet gateway and related routes to be created"
  type        = bool
  default     = true
}

variable "internet_gateway_name" {
  description = "Override auto-generated Name tag for internet gateway"
  type        = string
  default     = ""
}

variable "internet_gateway_tags" {
  description = "Map of additional tags to add to the internet gateway"
  type        = map(string)
  default     = {}
}

########################################
# egress-only internet gateway variables
########################################

variable "egress_only_igw_create" {
  description = "Should egress-only internet gateway and related routes to be created"
  type        = bool
  default     = false
}

variable "egress_only_igw_name" {
  description = "Override auto-generated Name tag for egress-only internet gateway"
  type        = string
  default     = ""
}

variable "egress_only_igw_tags" {
  description = "Map of additional tags to add to the egress-only internet gateway"
  type        = map(string)
  default     = {}
}

#############################
# NAT gateway variables
#############################

variable "nat_gateway_enable" {
  description = "Should NAT gateways and related routes to be created"
  type        = bool
  default     = true
}

variable "nat_gateway_single" {
  description = "Create only one NAT gateway"
  type        = bool
  default     = false
}

variable "nat_gateway_azs" {
  description = "Override NAT gateway availability zones. If specified, NAT gateways will be created only in AZs from this list. Also AZs from this list without public or without private subnets will be skipped. Generally you don't need to use this variable"
  type        = list(string)
  default     = []
}

variable "nat_gateway_allocation_ids" {
  description = "Pass EIP IDs created outside of this module for NAT gateways"
  type        = list(string)
  default     = []
}

variable "nat_gateway_eip_name_suffix" {
  description = "Name suffix for NAT gateways EIPs"
  type        = string
  default     = "nat"
}

variable "nat_gateway_tags" {
  description = "Map with additional tags added to the NAT gateways"
  type        = map(string)
  default     = {}
}

variable "nat_gateway_eip_tags" {
  description = "Map with additional tags added to the EIP for NAT gateways"
  type        = map(string)
  default     = {}
}

variable "nat_gateway_tags_per_nat_gateway" {
  description = "List of maps with tags for each NAT gateway."
  type        = list(map(string))
  default     = [{}]
}

#######################
# VPN Gateway variables
#######################

variable "vpn_gateway_create" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  type        = bool
  default     = false
}

variable "vpn_gateway_name" {
  description = "Override auto-generated VPN Gateway Name"
  type        = string
  default     = ""
}

variable "vpn_gateway_amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the virtual private gateway is created with the current default Amazon ASN."
  default     = "64512"
}

variable "vpn_gateway_availability_zone" {
  description = "The Availability Zone for the VPN Gateway"
  type        = string
  default     = ""
}

variable "vpn_gateway_tags" {
  description = "Additional tags to add to the created VPN Gateway"
  type        = map(string)
  default     = {}
}

variable "vpn_gateway_id" {
  description = "ID of existed VPN Gateway to attach to the VPC. Requires vpn_gateway_create = false"
  type        = string
  default     = ""
}

#########################
# vpc endpoints variables
#########################

variable "vpc_endpoints" {
  description = "List of vpc_endpoints. You can specify just true to enable vpc endpoint in all subnets (except public) as well as map with true/false to enable vpc endpoint for each subnet type"
  type        = map(any)
  default     = {}
}

variable "vpc_endpoints_tags" {
  description = "List of tags to be added to all created VPC Edpoints"
  type        = map(string)
  default     = {}
}

##########################
# public subnets variables
##########################

variable "public_name_suffix" {
  description = "Name suffix for NAT gateways"
  type        = string
  default     = "public"
}

variable "public_azs" {
  description = "Override AZs for the public subnets. Generally you don't need to use this variable"
  type        = list(string)
  default     = []
}

variable "public_cidrs" {
  description = "List of cidrs for public subnets"
  type        = list(string)
  default     = []
}

variable "public_ipv6_prefixes" {
  description = "Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to IPv4 public subnets cidrs list"
  type        = list(string)
  default     = []
}

variable "public_route_table_separate" {
  description = "Create separate route table for each public subnet"
  type        = bool
  default     = false
}

variable "public_route_table_vgw_propagation" {
  description = "VPN Gateway route propagation. Requires vpn_gateway_create = true or vpn_gateway_id to be set"
  type        = bool
  default     = false
}

variable "public_route_table_tags" {
  description = "Map with additional tags to add to public subnets route table"
  type        = map(string)
  default     = {}
}

variable "public_route_table_tags_per_route_table" {
  description = "Map with additional tags to add to each public subnet route table (makes sense only with public_separate_route_tables = true)"
  type        = list(map(string))
  default     = [{}]
}

variable "public_map_public_ip_on_launch" {
  description = "Auto-assign public IPs on instance launch"
  type        = bool
  default     = false
}

variable "public_map_public_ip_on_launch_per_subnet" {
  description = "Override map_public_ip_on_launch property for each public subnet. Must be equal length to public subnets number"
  type        = list(bool)
  default     = []
}

variable "public_assign_ipv6_address_on_creation" {
  description = "Assign ipv6 address on creation"
  type        = bool
  default     = false
}

variable "public_assign_ipv6_address_on_creation_per_subnet" {
  description = "Define assign_ipv6_address_on_creation for each subnet separately. Must be equal length to public subnets number"
  type        = list(bool)
  default     = []
}

variable "public_network_acl_enabled" {
  description = "Create dedicated network ACL for public subnets"
  type        = bool
  default     = false
}

variable "public_network_acl_inbound_rules" {
  description = "Public subnets dedicated network ACL inbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "public_network_acl_outbound_rules" {
  description = "Public subnets dedicated network ACL outbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "public_network_acl_tags" {
  description = "Map with additional tags to add to public subnets Network ACL"
  type        = map(string)
  default     = {}
}

variable "public_tags" {
  description = "Map with additional tags to add to public subnets"
  type        = map(string)
  default     = {}
}

variable "public_tags_per_subnet" {
  description = "List of maps with additional tags for each public subnet"
  type        = list(map(string))
  default     = [{}]
}

##########################
# private subnets variables
##########################

variable "private_name_suffix" {
  description = "Name suffix for NAT gateways"
  type        = string
  default     = "private"
}

variable "private_azs" {
  description = "Override AZs for the private subnets. Generally you don't need to use this variable"
  type        = list(string)
  default     = []
}

variable "private_cidrs" {
  description = "List of cidrs for private subnets"
  type        = list(string)
  default     = []
}

variable "private_ipv6_prefixes" {
  description = "Assigns IPv6 private subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to IPv4 private subnets cidrs list"
  type        = list(string)
  default     = []
}

variable "private_route_table_separate" {
  description = "Create separate route table for each private subnet even when nat_gateway_single = true"
  type        = bool
  default     = false
}

variable "private_route_table_vgw_propagation" {
  description = "VPN Gateway route propagation. Requires vpn_gateway_create = true or vpn_gateway_id to be set"
  type        = bool
  default     = false
}

variable "private_route_table_tags" {
  description = "Map with additional tags to add to private subnets route table"
  type        = map(string)
  default     = {}
}

variable "private_route_table_tags_per_route_table" {
  description = "Map with additional tags to add to each private subnet route table (makes sense only with private_separate_route_tables = true)"
  type        = list(map(string))
  default     = [{}]
}

variable "private_assign_ipv6_address_on_creation" {
  description = "Assign ipv6 address on creation"
  type        = bool
  default     = false
}

variable "private_assign_ipv6_address_on_creation_per_subnet" {
  description = "Define assign_ipv6_address_on_creation for each subnet separately. Must be equal length to private subnets number"
  type        = list(bool)
  default     = []
}

variable "private_network_acl_enabled" {
  description = "Create dedicated network ACL for private subnets"
  type        = bool
  default     = false
}

variable "private_network_acl_inbound_rules" {
  description = "Public subnets dedicated network ACL inbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "private_network_acl_outbound_rules" {
  description = "Public subnets dedicated network ACL outbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "private_network_acl_tags" {
  description = "Map with additional tags to add to private subnets Network ACL"
  type        = map(string)
  default     = {}
}

variable "private_db_subnet_group_create" {
  description = "Create RDS DB subnet group for private subnets"
  type        = bool
  default     = false
}

variable "private_db_subnet_group_name" {
  description = "Override auto-generated RDS DB subnet group name"
  type        = string
  default     = ""
}

variable "private_db_subnet_group_description" {
  description = "Override auto-generated RDS DB subnet group description"
  type        = string
  default     = ""
}

variable "private_db_subnet_group_azs" {
  description = "Limit db subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "private_db_subnet_group_tags" {
  description = "Map of additional tags to add to RDS DB subnet group"
  type        = map(string)
  default     = {}
}

variable "private_elasticache_subnet_group_create" {
  description = "Create ElastiCache subnet group for private subnets"
  type        = bool
  default     = false
}

variable "private_elasticache_subnet_group_name" {
  description = "Override auto-generated ElastiCache subnet group name"
  type        = string
  default     = ""
}

variable "private_elasticache_subnet_group_description" {
  description = "Override auto-generated ElastiCache subnet group description"
  type        = string
  default     = ""
}

variable "private_elasticache_subnet_group_azs" {
  description = "Limit elasticache subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "private_redshift_subnet_group_create" {
  description = "Create ElastiCache subnet group for private subnets"
  type        = bool
  default     = false
}

variable "private_redshift_subnet_group_name" {
  description = "Override auto-generated ElastiCache subnet group name"
  type        = string
  default     = ""
}

variable "private_redshift_subnet_group_description" {
  description = "Override auto-generated ElastiCache subnet group description"
  type        = string
  default     = ""
}

variable "private_redshift_subnet_group_azs" {
  description = "Limit redshift subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "private_redshift_subnet_group_tags" {
  description = "Map of additional tags to add to Redshift subnet group"
  type        = map(string)
  default     = {}
}

variable "private_tags" {
  description = "Map with additional tags to add to private subnets"
  type        = map(string)
  default     = {}
}

variable "private_tags_per_subnet" {
  description = "List of maps with additional tags for each private subnet"
  type        = list(map(string))
  default     = [{}]
}

##########################
# intra subnets variables
##########################

variable "intra_name_suffix" {
  description = "Name suffix for NAT gateways"
  type        = string
  default     = "intra"
}

variable "intra_azs" {
  description = "Override AZs for the intra subnets. Generally you don't need to use this variable"
  type        = list(string)
  default     = []
}

variable "intra_cidrs" {
  description = "List of cidrs for intra subnets"
  type        = list(string)
  default     = []
}

variable "intra_ipv6_prefixes" {
  description = "Assigns IPv6 intra subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to IPv4 intra subnets cidrs list"
  type        = list(string)
  default     = []
}

variable "intra_route_table_separate" {
  description = "Create separate route table for each intra subnet even when nat_gateway_single = true"
  type        = bool
  default     = false
}

variable "intra_route_table_tags" {
  description = "Map with additional tags to add to intra subnets route table"
  type        = map(string)
  default     = {}
}

variable "intra_route_table_tags_per_route_table" {
  description = "Map with additional tags to add to each intra subnet route table (makes sense only with intra_separate_route_tables = true)"
  type        = list(map(string))
  default     = [{}]
}

variable "intra_network_acl_enabled" {
  description = "Create dedicated network ACL for intra subnets"
  type        = bool
  default     = false
}

variable "intra_network_acl_inbound_rules" {
  description = "Public subnets dedicated network ACL inbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "intra_network_acl_outbound_rules" {
  description = "Public subnets dedicated network ACL outbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "intra_network_acl_tags" {
  description = "Map with additional tags to add to intra subnets Network ACL"
  type        = map(string)
  default     = {}
}

variable "intra_tags" {
  description = "Map with additional tags to add to intra subnets"
  type        = map(string)
  default     = {}
}

variable "intra_tags_per_subnet" {
  description = "List of maps with additional tags for each intra subnet"
  type        = list(map(string))
  default     = [{}]
}

##########################
# database subnets variables
##########################

variable "database_name_suffix" {
  description = "Name suffix for NAT gateways"
  type        = string
  default     = "database"
}

variable "database_azs" {
  description = "Override AZs for the database subnets. Generally you don't need to use this variable"
  type        = list(string)
  default     = []
}

variable "database_cidrs" {
  description = "List of cidrs for database subnets"
  type        = list(string)
  default     = []
}

variable "database_ipv6_prefixes" {
  description = "Assigns IPv6 database subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to IPv4 database subnets cidrs list"
  type        = list(string)
  default     = []
}

variable "database_route_table_create" {
  description = "Create dedicated route tables for database subnets. Otherwise private subnet's route tables will be used"
  type        = bool
  default     = false
}

variable "database_route_table_separate" {
  description = "Create separate route table for each database subnet even when nat_gateway_single and database_enable_nat_gateway_route == true or database_enable_public_route == true"
  type        = bool
  default     = false
}

variable "database_route_table_vgw_propagation" {
  description = "VPN Gateway route propagation. Requires vpn_gateway_create = true or vpn_gateway_id to be set"
  type        = bool
  default     = false
}

variable "database_route_table_tags" {
  description = "Map with additional tags to add to database subnets route table"
  type        = map(string)
  default     = {}
}

variable "database_route_table_tags_per_route_table" {
  description = "Map with additional tags to add to each database subnet route table (makes sense only with database_separate_route_tables = true)"
  type        = list(map(string))
  default     = [{}]
}

variable "database_enable_nat_gateway_route" {
  description = "Enable access to the internet via NAT gateways"
  type        = bool
  default     = false
}

variable "database_enable_public_route" {
  description = "Enable access to the internet via internet gateway and/or egress-only internet gateway. Takes precedence over database_enable_nat_gateway_route"
  type        = bool
  default     = false
}

variable "database_map_public_ip_on_launch" {
  description = "Auto-assign public IPs on instance launch. Requires database_enable_public_route = true"
  type        = bool
  default     = false
}

variable "database_map_public_ip_on_launch_per_subnet" {
  description = "Override map_public_ip_on_launch property for each subnet. Must be equal length to subnets number. Requires database_enable_public_route = true"
  type        = list(bool)
  default     = []
}

variable "database_assign_ipv6_address_on_creation" {
  description = "Assign ipv6 address on creation"
  type        = bool
  default     = false
}

variable "database_assign_ipv6_address_on_creation_per_subnet" {
  description = "Define assign_ipv6_address_on_creation for each subnet separately. Must be equal length to database subnets number"
  type        = list(bool)
  default     = []
}

variable "database_network_acl_enabled" {
  description = "Create dedicated network ACL for database subnets"
  type        = bool
  default     = false
}

variable "database_network_acl_inbound_rules" {
  description = "Public subnets dedicated network ACL inbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "database_network_acl_outbound_rules" {
  description = "Public subnets dedicated network ACL outbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "database_network_acl_tags" {
  description = "Map with additional tags to add to database subnets Network ACL"
  type        = map(string)
  default     = {}
}

variable "database_db_subnet_group_create" {
  description = "Create RDS DB subnet group for database subnets"
  type        = bool
  default     = false
}

variable "database_db_subnet_group_name" {
  description = "Override auto-generated RDS DB subnet group name"
  type        = string
  default     = ""
}

variable "database_db_subnet_group_description" {
  description = "Override auto-generated RDS DB subnet group description"
  type        = string
  default     = ""
}

variable "database_db_subnet_group_azs" {
  description = "Limit db subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "database_db_subnet_group_tags" {
  description = "Map of additional tags to add to RDS DB subnet group"
  type        = map(string)
  default     = {}
}

variable "database_tags" {
  description = "Map with additional tags to add to database subnets"
  type        = map(string)
  default     = {}
}

variable "database_tags_per_subnet" {
  description = "List of maps with additional tags for each database subnet"
  type        = list(map(string))
  default     = [{}]
}

###############################
# elasticache subnets variables
###############################

variable "elasticache_name_suffix" {
  description = "Name suffix for NAT gateways"
  type        = string
  default     = "elasticache"
}

variable "elasticache_azs" {
  description = "Override AZs for the elasticache subnets. Generally you don't need to use this variable"
  type        = list(string)
  default     = []
}

variable "elasticache_cidrs" {
  description = "List of cidrs for elasticache subnets"
  type        = list(string)
  default     = []
}

variable "elasticache_ipv6_prefixes" {
  description = "Assigns IPv6 elasticache subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to IPv4 elasticache subnets cidrs list"
  type        = list(string)
  default     = []
}

variable "elasticache_route_table_create" {
  description = "Create dedicated route tables for elasticache subnets. Otherwise private subnet's route tables will be used"
  type        = bool
  default     = false
}

variable "elasticache_route_table_separate" {
  description = "Create separate route table for each elasticache subnet even when nat_gateway_single and elasticache_enable_nat_gateway_route == true or elasticache_enable_public_route == true"
  type        = bool
  default     = false
}

variable "elasticache_route_table_vgw_propagation" {
  description = "VPN Gateway route propagation. Requires vpn_gateway_create = true or vpn_gateway_id to be set"
  type        = bool
  default     = false
}

variable "elasticache_route_table_tags" {
  description = "Map with additional tags to add to elasticache subnets route table"
  type        = map(string)
  default     = {}
}

variable "elasticache_route_table_tags_per_route_table" {
  description = "Map with additional tags to add to each elasticache subnet route table (makes sense only with elasticache_separate_route_tables = true)"
  type        = list(map(string))
  default     = [{}]
}

variable "elasticache_enable_nat_gateway_route" {
  description = "Enable access to the internet via NAT gateways"
  type        = bool
  default     = false
}

variable "elasticache_enable_public_route" {
  description = "Enable access to the internet via internet gateway and/or egress-only internet gateway. Takes precedence over elasticache_enable_nat_gateway_route"
  type        = bool
  default     = false
}

variable "elasticache_map_public_ip_on_launch" {
  description = "Auto-assign public IPs on instance launch. Requires elasticache_enable_public_route = true"
  type        = bool
  default     = false
}

variable "elasticache_map_public_ip_on_launch_per_subnet" {
  description = "Override map_public_ip_on_launch property for each subnet. Must be equal length to subnets number. Requires elasticache_enable_public_route = true"
  type        = list(bool)
  default     = []
}

variable "elasticache_assign_ipv6_address_on_creation" {
  description = "Assign ipv6 address on creation"
  type        = bool
  default     = false
}

variable "elasticache_assign_ipv6_address_on_creation_per_subnet" {
  description = "Define assign_ipv6_address_on_creation for each subnet separately. Must be equal length to elasticache subnets number"
  type        = list(bool)
  default     = []
}

variable "elasticache_network_acl_enabled" {
  description = "Create dedicated network ACL for elasticache subnets"
  type        = bool
  default     = false
}

variable "elasticache_network_acl_inbound_rules" {
  description = "Public subnets dedicated network ACL inbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "elasticache_network_acl_outbound_rules" {
  description = "Public subnets dedicated network ACL outbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "elasticache_network_acl_tags" {
  description = "Map with additional tags to add to elasticache subnets Network ACL"
  type        = map(string)
  default     = {}
}

variable "elasticache_elasticache_subnet_group_create" {
  description = "Create ElastiCache subnet group for private subnets"
  type        = bool
  default     = false
}

variable "elasticache_elasticache_subnet_group_name" {
  description = "Override auto-generated ElastiCache subnet group name"
  type        = string
  default     = ""
}

variable "elasticache_elasticache_subnet_group_description" {
  description = "Override auto-generated ElastiCache subnet group description"
  type        = string
  default     = ""
}

variable "elasticache_elasticache_subnet_group_azs" {
  description = "Limit elasticache subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "elasticache_tags" {
  description = "Map with additional tags to add to elasticache subnets"
  type        = map(string)
  default     = {}
}

variable "elasticache_tags_per_subnet" {
  description = "List of maps with additional tags for each elasticache subnet"
  type        = list(map(string))
  default     = [{}]
}

###############################
# redshift subnets variables
###############################

variable "redshift_name_suffix" {
  description = "Name suffix for NAT gateways"
  type        = string
  default     = "redshift"
}

variable "redshift_azs" {
  description = "Override AZs for the redshift subnets. Generally you don't need to use this variable"
  type        = list(string)
  default     = []
}

variable "redshift_cidrs" {
  description = "List of cidrs for redshift subnets"
  type        = list(string)
  default     = []
}

variable "redshift_ipv6_prefixes" {
  description = "Assigns IPv6 redshift subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to IPv4 redshift subnets cidrs list"
  type        = list(string)
  default     = []
}

variable "redshift_route_table_create" {
  description = "Create dedicated route tables for redshift subnets. Otherwise private subnet's route tables will be used"
  type        = bool
  default     = false
}

variable "redshift_route_table_separate" {
  description = "Create separate route table for each redshift subnet even when nat_gateway_single and redshift_enable_nat_gateway_route == true or redshift_enable_public_route == true"
  type        = bool
  default     = false
}

variable "redshift_route_table_vgw_propagation" {
  description = "VPN Gateway route propagation. Requires vpn_gateway_create = true or vpn_gateway_id to be set"
  type        = bool
  default     = false
}

variable "redshift_route_table_tags" {
  description = "Map with additional tags to add to redshift subnets route table"
  type        = map(string)
  default     = {}
}

variable "redshift_route_table_tags_per_route_table" {
  description = "Map with additional tags to add to each redshift subnet route table (makes sense only with redshift_separate_route_tables = true)"
  type        = list(map(string))
  default     = [{}]
}

variable "redshift_enable_nat_gateway_route" {
  description = "Enable access to the internet via NAT gateways"
  type        = bool
  default     = false
}

variable "redshift_enable_public_route" {
  description = "Enable access to the internet via internet gateway and/or egress-only internet gateway. Takes precedence over redshift_enable_nat_gateway_route"
  type        = bool
  default     = false
}

variable "redshift_map_public_ip_on_launch" {
  description = "Auto-assign public IPs on instance launch. Requires redshift_enable_public_route = true"
  type        = bool
  default     = false
}

variable "redshift_map_public_ip_on_launch_per_subnet" {
  description = "Override map_public_ip_on_launch property for each subnet. Must be equal length to subnets number. Requires redshift_enable_public_route = true"
  type        = list(bool)
  default     = []
}

variable "redshift_assign_ipv6_address_on_creation" {
  description = "Assign ipv6 address on creation"
  type        = bool
  default     = false
}

variable "redshift_assign_ipv6_address_on_creation_per_subnet" {
  description = "Define assign_ipv6_address_on_creation for each subnet separately. Must be equal length to redshift subnets number"
  type        = list(bool)
  default     = []
}

variable "redshift_network_acl_enabled" {
  description = "Create dedicated network ACL for redshift subnets"
  type        = bool
  default     = false
}

variable "redshift_network_acl_inbound_rules" {
  description = "Public subnets dedicated network ACL inbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "redshift_network_acl_outbound_rules" {
  description = "Public subnets dedicated network ACL outbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "redshift_network_acl_tags" {
  description = "Map with additional tags to add to redshift subnets Network ACL"
  type        = map(string)
  default     = {}
}

variable "redshift_redshift_subnet_group_create" {
  description = "Create Redshift subnet group for private subnets"
  type        = bool
  default     = false
}

variable "redshift_redshift_subnet_group_name" {
  description = "Override auto-generated Redshift subnet group name"
  type        = string
  default     = ""
}

variable "redshift_redshift_subnet_group_description" {
  description = "Override auto-generated Redshift subnet group description"
  type        = string
  default     = ""
}

variable "redshift_redshift_subnet_group_azs" {
  description = "Limit redshift subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "redshift_redshift_subnet_group_tags" {
  description = "Map of additional tags to add to Redshift subnet group"
  type        = map(string)
  default     = {}
}

variable "redshift_tags" {
  description = "Map with additional tags to add to redshift subnets"
  type        = map(string)
  default     = {}
}

variable "redshift_tags_per_subnet" {
  description = "List of maps with additional tags for each redshift subnet"
  type        = list(map(string))
  default     = [{}]
}

#################################
# elasticsearch subnets variables
#################################

variable "elasticsearch_name_suffix" {
  description = "Name suffix for NAT gateways"
  type        = string
  default     = "elasticsearch"
}

variable "elasticsearch_azs" {
  description = "Override AZs for the elasticsearch subnets. Generally you don't need to use this variable"
  type        = list(string)
  default     = []
}

variable "elasticsearch_cidrs" {
  description = "List of cidrs for elasticsearch subnets"
  type        = list(string)
  default     = []
}

variable "elasticsearch_ipv6_prefixes" {
  description = "Assigns IPv6 elasticsearch subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to IPv4 elasticsearch subnets cidrs list"
  type        = list(string)
  default     = []
}

variable "elasticsearch_route_table_create" {
  description = "Create dedicated route tables for elasticsearch subnets. Otherwise private subnet's route tables will be used"
  type        = bool
  default     = false
}

variable "elasticsearch_route_table_separate" {
  description = "Create separate route table for each elasticsearch subnet even when nat_gateway_single and elasticsearch_enable_nat_gateway_route == true or elasticsearch_enable_public_route == true"
  type        = bool
  default     = false
}

variable "elasticsearch_route_table_vgw_propagation" {
  description = "VPN Gateway route propagation. Requires vpn_gateway_create = true or vpn_gateway_id to be set"
  type        = bool
  default     = false
}

variable "elasticsearch_route_table_tags" {
  description = "Map with additional tags to add to elasticsearch subnets route table"
  type        = map(string)
  default     = {}
}

variable "elasticsearch_route_table_tags_per_route_table" {
  description = "Map with additional tags to add to each elasticsearch subnet route table (makes sense only with elasticsearch_separate_route_tables = true)"
  type        = list(map(string))
  default     = [{}]
}

variable "elasticsearch_enable_nat_gateway_route" {
  description = "Enable access to the internet via NAT gateways"
  type        = bool
  default     = false
}

variable "elasticsearch_enable_public_route" {
  description = "Enable access to the internet via internet gateway and/or egress-only internet gateway. Takes precedence over elasticsearch_enable_nat_gateway_route"
  type        = bool
  default     = false
}

variable "elasticsearch_map_public_ip_on_launch" {
  description = "Auto-assign public IPs on instance launch. Requires elasticsearch_enable_public_route = true"
  type        = bool
  default     = false
}

variable "elasticsearch_map_public_ip_on_launch_per_subnet" {
  description = "Override map_public_ip_on_launch property for each subnet. Must be equal length to subnets number. Requires elasticsearch_enable_public_route = true"
  type        = list(bool)
  default     = []
}

variable "elasticsearch_assign_ipv6_address_on_creation" {
  description = "Assign ipv6 address on creation"
  type        = bool
  default     = false
}

variable "elasticsearch_assign_ipv6_address_on_creation_per_subnet" {
  description = "Define assign_ipv6_address_on_creation for each subnet separately. Must be equal length to elasticsearch subnets number"
  type        = list(bool)
  default     = []
}

variable "elasticsearch_network_acl_enabled" {
  description = "Create dedicated network ACL for elasticsearch subnets"
  type        = bool
  default     = false
}

variable "elasticsearch_network_acl_inbound_rules" {
  description = "Public subnets dedicated network ACL inbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "elasticsearch_network_acl_outbound_rules" {
  description = "Public subnets dedicated network ACL outbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "elasticsearch_network_acl_tags" {
  description = "Map with additional tags to add to elasticsearch subnets Network ACL"
  type        = map(string)
  default     = {}
}

variable "elasticsearch_tags" {
  description = "Map with additional tags to add to elasticsearch subnets"
  type        = map(string)
  default     = {}
}

variable "elasticsearch_tags_per_subnet" {
  description = "List of maps with additional tags for each elasticsearch subnet"
  type        = list(map(string))
  default     = [{}]
}

##########################
# custom1 subnets variables
##########################

variable "custom1_name_suffix" {
  description = "Name suffix for NAT gateways"
  type        = string
  default     = "custom1"
}

variable "custom1_azs" {
  description = "Override AZs for the custom1 subnets. Generally you don't need to use this variable"
  type        = list(string)
  default     = []
}

variable "custom1_cidrs" {
  description = "List of cidrs for custom1 subnets"
  type        = list(string)
  default     = []
}

variable "custom1_ipv6_prefixes" {
  description = "Assigns IPv6 custom1 subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to IPv4 custom1 subnets cidrs list"
  type        = list(string)
  default     = []
}

variable "custom1_route_table_create" {
  description = "Create dedicated route tables for custom1 subnets."
  type        = bool
  default     = true
}

variable "custom1_route_table_ids" {
  description = "List of route tables IDs to assign to custom1 subnets. Requires custom1_route_table_create = false"
  type        = list(string)
  default     = []
}

variable "custom1_route_table_separate" {
  description = "Create separate route table for each custom1 subnet"
  type        = bool
  default     = true
}

variable "custom1_route_table_vgw_propagation" {
  description = "VPN Gateway route propagation. Requires vpn_gateway_create = true or vpn_gateway_id to be set"
  type        = bool
  default     = false
}

variable "custom1_route_table_tags" {
  description = "Map with additional tags to add to custom1 subnets route table"
  type        = map(string)
  default     = {}
}

variable "custom1_route_table_tags_per_route_table" {
  description = "Map with additional tags to add to each custom1 subnet route table (makes sense only with custom1_separate_route_tables = true)"
  type        = list(map(string))
  default     = [{}]
}

variable "custom1_enable_nat_gateway_route" {
  description = "Enable access to the internet via NAT gateways"
  type        = bool
  default     = false
}

variable "custom1_enable_public_route" {
  description = "Enable access to the internet via internet gateway and/or egress-only internet gateway. Takes precedence over custom1_enable_nat_gateway_route"
  type        = bool
  default     = false
}

variable "custom1_map_public_ip_on_launch" {
  description = "Auto-assign public IPs on instance launch. Requires custom1_enable_public_route = true"
  type        = bool
  default     = false
}

variable "custom1_map_public_ip_on_launch_per_subnet" {
  description = "Override map_public_ip_on_launch property for each subnet. Must be equal length to subnets number. Requires custom1_enable_public_route = true"
  type        = list(bool)
  default     = []
}

variable "custom1_assign_ipv6_address_on_creation" {
  description = "Assign ipv6 address on creation"
  type        = bool
  default     = false
}

variable "custom1_assign_ipv6_address_on_creation_per_subnet" {
  description = "Define assign_ipv6_address_on_creation for each subnet separately. Must be equal length to custom1 subnets number"
  type        = list(bool)
  default     = []
}

variable "custom1_network_acl_enabled" {
  description = "Create dedicated network ACL for custom1 subnets"
  type        = bool
  default     = false
}

variable "custom1_network_acl_inbound_rules" {
  description = "Public subnets dedicated network ACL inbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "custom1_network_acl_outbound_rules" {
  description = "Public subnets dedicated network ACL outbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "custom1_network_acl_tags" {
  description = "Map with additional tags to add to custom1 subnets Network ACL"
  type        = map(string)
  default     = {}
}

variable "custom1_db_subnet_group_create" {
  description = "Create RDS DB subnet group for custom1 subnets"
  type        = bool
  default     = false
}

variable "custom1_db_subnet_group_name" {
  description = "Override auto-generated RDS DB subnet group name"
  type        = string
  default     = ""
}

variable "custom1_db_subnet_group_description" {
  description = "Override auto-generated RDS DB subnet group description"
  type        = string
  default     = ""
}

variable "custom1_db_subnet_group_azs" {
  description = "Limit db subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "custom1_db_subnet_group_tags" {
  description = "Map of additional tags to add to RDS DB subnet group"
  type        = map(string)
  default     = {}
}

variable "custom1_elasticache_subnet_group_create" {
  description = "Create ElastiCache subnet group for custom1 subnets"
  type        = bool
  default     = false
}

variable "custom1_elasticache_subnet_group_name" {
  description = "Override auto-generated ElastiCache subnet group name"
  type        = string
  default     = ""
}

variable "custom1_elasticache_subnet_group_description" {
  description = "Override auto-generated ElastiCache subnet group description"
  type        = string
  default     = ""
}

variable "custom1_elasticache_subnet_group_azs" {
  description = "Limit elasticache subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "custom1_redshift_subnet_group_create" {
  description = "Create ElastiCache subnet group for custom1 subnets"
  type        = bool
  default     = false
}

variable "custom1_redshift_subnet_group_name" {
  description = "Override auto-generated ElastiCache subnet group name"
  type        = string
  default     = ""
}

variable "custom1_redshift_subnet_group_description" {
  description = "Override auto-generated ElastiCache subnet group description"
  type        = string
  default     = ""
}

variable "custom1_redshift_subnet_group_azs" {
  description = "Limit redshift subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "custom1_redshift_subnet_group_tags" {
  description = "Map of additional tags to add to Redshift subnet group"
  type        = map(string)
  default     = {}
}

variable "custom1_tags" {
  description = "Map with additional tags to add to custom1 subnets"
  type        = map(string)
  default     = {}
}

variable "custom1_tags_per_subnet" {
  description = "List of maps with additional tags for each custom1 subnet"
  type        = list(map(string))
  default     = [{}]
}

##########################
# custom2 subnets variables
##########################

variable "custom2_name_suffix" {
  description = "Name suffix for NAT gateways"
  type        = string
  default     = "custom2"
}

variable "custom2_azs" {
  description = "Override AZs for the custom2 subnets. Generally you don't need to use this variable"
  type        = list(string)
  default     = []
}

variable "custom2_cidrs" {
  description = "List of cidrs for custom2 subnets"
  type        = list(string)
  default     = []
}

variable "custom2_ipv6_prefixes" {
  description = "Assigns IPv6 custom2 subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to IPv4 custom2 subnets cidrs list"
  type        = list(string)
  default     = []
}

variable "custom2_route_table_create" {
  description = "Create dedicated route tables for custom2 subnets."
  type        = bool
  default     = true
}

variable "custom2_route_table_ids" {
  description = "List of route tables IDs to assign to custom2 subnets. Requires custom2_route_table_create = false"
  type        = list(string)
  default     = []
}

variable "custom2_route_table_separate" {
  description = "Create separate route table for each custom2 subnet"
  type        = bool
  default     = true
}

variable "custom2_route_table_vgw_propagation" {
  description = "VPN Gateway route propagation. Requires vpn_gateway_create = true or vpn_gateway_id to be set"
  type        = bool
  default     = false
}

variable "custom2_route_table_tags" {
  description = "Map with additional tags to add to custom2 subnets route table"
  type        = map(string)
  default     = {}
}

variable "custom2_route_table_tags_per_route_table" {
  description = "Map with additional tags to add to each custom2 subnet route table (makes sense only with custom2_separate_route_tables = true)"
  type        = list(map(string))
  default     = [{}]
}

variable "custom2_enable_nat_gateway_route" {
  description = "Enable access to the internet via NAT gateways"
  type        = bool
  default     = false
}

variable "custom2_enable_public_route" {
  description = "Enable access to the internet via internet gateway and/or egress-only internet gateway. Takes precedence over custom2_enable_nat_gateway_route"
  type        = bool
  default     = false
}

variable "custom2_map_public_ip_on_launch" {
  description = "Auto-assign public IPs on instance launch. Requires custom2_enable_public_route = true"
  type        = bool
  default     = false
}

variable "custom2_map_public_ip_on_launch_per_subnet" {
  description = "Override map_public_ip_on_launch property for each subnet. Must be equal length to subnets number. Requires custom2_enable_public_route = true"
  type        = list(bool)
  default     = []
}

variable "custom2_assign_ipv6_address_on_creation" {
  description = "Assign ipv6 address on creation"
  type        = bool
  default     = false
}

variable "custom2_assign_ipv6_address_on_creation_per_subnet" {
  description = "Define assign_ipv6_address_on_creation for each subnet separately. Must be equal length to custom2 subnets number"
  type        = list(bool)
  default     = []
}

variable "custom2_network_acl_enabled" {
  description = "Create dedicated network ACL for custom2 subnets"
  type        = bool
  default     = false
}

variable "custom2_network_acl_inbound_rules" {
  description = "Public subnets dedicated network ACL inbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "custom2_network_acl_outbound_rules" {
  description = "Public subnets dedicated network ACL outbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "custom2_network_acl_tags" {
  description = "Map with additional tags to add to custom2 subnets Network ACL"
  type        = map(string)
  default     = {}
}

variable "custom2_db_subnet_group_create" {
  description = "Create RDS DB subnet group for custom2 subnets"
  type        = bool
  default     = false
}

variable "custom2_db_subnet_group_name" {
  description = "Override auto-generated RDS DB subnet group name"
  type        = string
  default     = ""
}

variable "custom2_db_subnet_group_description" {
  description = "Override auto-generated RDS DB subnet group description"
  type        = string
  default     = ""
}

variable "custom2_db_subnet_group_azs" {
  description = "Limit db subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "custom2_db_subnet_group_tags" {
  description = "Map of additional tags to add to RDS DB subnet group"
  type        = map(string)
  default     = {}
}

variable "custom2_elasticache_subnet_group_create" {
  description = "Create ElastiCache subnet group for custom2 subnets"
  type        = bool
  default     = false
}

variable "custom2_elasticache_subnet_group_name" {
  description = "Override auto-generated ElastiCache subnet group name"
  type        = string
  default     = ""
}

variable "custom2_elasticache_subnet_group_description" {
  description = "Override auto-generated ElastiCache subnet group description"
  type        = string
  default     = ""
}

variable "custom2_elasticache_subnet_group_azs" {
  description = "Limit elasticache subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "custom2_redshift_subnet_group_create" {
  description = "Create ElastiCache subnet group for custom2 subnets"
  type        = bool
  default     = false
}

variable "custom2_redshift_subnet_group_name" {
  description = "Override auto-generated ElastiCache subnet group name"
  type        = string
  default     = ""
}

variable "custom2_redshift_subnet_group_description" {
  description = "Override auto-generated ElastiCache subnet group description"
  type        = string
  default     = ""
}

variable "custom2_redshift_subnet_group_azs" {
  description = "Limit redshift subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "custom2_redshift_subnet_group_tags" {
  description = "Map of additional tags to add to Redshift subnet group"
  type        = map(string)
  default     = {}
}

variable "custom2_tags" {
  description = "Map with additional tags to add to custom2 subnets"
  type        = map(string)
  default     = {}
}

variable "custom2_tags_per_subnet" {
  description = "List of maps with additional tags for each custom2 subnet"
  type        = list(map(string))
  default     = [{}]
}

##########################
# custom3 subnets variables
##########################

variable "custom3_name_suffix" {
  description = "Name suffix for NAT gateways"
  type        = string
  default     = "custom3"
}

variable "custom3_azs" {
  description = "Override AZs for the custom3 subnets. Generally you don't need to use this variable"
  type        = list(string)
  default     = []
}

variable "custom3_cidrs" {
  description = "List of cidrs for custom3 subnets"
  type        = list(string)
  default     = []
}

variable "custom3_ipv6_prefixes" {
  description = "Assigns IPv6 custom3 subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to IPv4 custom3 subnets cidrs list"
  type        = list(string)
  default     = []
}

variable "custom3_route_table_create" {
  description = "Create dedicated route tables for custom3 subnets."
  type        = bool
  default     = true
}

variable "custom3_route_table_ids" {
  description = "List of route tables IDs to assign to custom3 subnets. Requires custom3_route_table_create = false"
  type        = list(string)
  default     = []
}

variable "custom3_route_table_separate" {
  description = "Create separate route table for each custom3 subnet"
  type        = bool
  default     = true
}

variable "custom3_route_table_vgw_propagation" {
  description = "VPN Gateway route propagation. Requires vpn_gateway_create = true or vpn_gateway_id to be set"
  type        = bool
  default     = false
}

variable "custom3_route_table_tags" {
  description = "Map with additional tags to add to custom3 subnets route table"
  type        = map(string)
  default     = {}
}

variable "custom3_route_table_tags_per_route_table" {
  description = "Map with additional tags to add to each custom3 subnet route table (makes sense only with custom3_separate_route_tables = true)"
  type        = list(map(string))
  default     = [{}]
}

variable "custom3_enable_nat_gateway_route" {
  description = "Enable access to the internet via NAT gateways"
  type        = bool
  default     = false
}

variable "custom3_enable_public_route" {
  description = "Enable access to the internet via internet gateway and/or egress-only internet gateway. Takes precedence over custom3_enable_nat_gateway_route"
  type        = bool
  default     = false
}

variable "custom3_map_public_ip_on_launch" {
  description = "Auto-assign public IPs on instance launch. Requires custom3_enable_public_route = true"
  type        = bool
  default     = false
}

variable "custom3_map_public_ip_on_launch_per_subnet" {
  description = "Override map_public_ip_on_launch property for each subnet. Must be equal length to subnets number. Requires custom3_enable_public_route = true"
  type        = list(bool)
  default     = []
}

variable "custom3_assign_ipv6_address_on_creation" {
  description = "Assign ipv6 address on creation"
  type        = bool
  default     = false
}

variable "custom3_assign_ipv6_address_on_creation_per_subnet" {
  description = "Define assign_ipv6_address_on_creation for each subnet separately. Must be equal length to custom3 subnets number"
  type        = list(bool)
  default     = []
}

variable "custom3_network_acl_enabled" {
  description = "Create dedicated network ACL for custom3 subnets"
  type        = bool
  default     = false
}

variable "custom3_network_acl_inbound_rules" {
  description = "Public subnets dedicated network ACL inbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "custom3_network_acl_outbound_rules" {
  description = "Public subnets dedicated network ACL outbound rules"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "custom3_network_acl_tags" {
  description = "Map with additional tags to add to custom3 subnets Network ACL"
  type        = map(string)
  default     = {}
}

variable "custom3_db_subnet_group_create" {
  description = "Create RDS DB subnet group for custom3 subnets"
  type        = bool
  default     = false
}

variable "custom3_db_subnet_group_name" {
  description = "Override auto-generated RDS DB subnet group name"
  type        = string
  default     = ""
}

variable "custom3_db_subnet_group_description" {
  description = "Override auto-generated RDS DB subnet group description"
  type        = string
  default     = ""
}

variable "custom3_db_subnet_group_azs" {
  description = "Limit db subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "custom3_db_subnet_group_tags" {
  description = "Map of additional tags to add to RDS DB subnet group"
  type        = map(string)
  default     = {}
}

variable "custom3_elasticache_subnet_group_create" {
  description = "Create ElastiCache subnet group for custom3 subnets"
  type        = bool
  default     = false
}

variable "custom3_elasticache_subnet_group_name" {
  description = "Override auto-generated ElastiCache subnet group name"
  type        = string
  default     = ""
}

variable "custom3_elasticache_subnet_group_description" {
  description = "Override auto-generated ElastiCache subnet group description"
  type        = string
  default     = ""
}

variable "custom3_elasticache_subnet_group_azs" {
  description = "Limit elasticache subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "custom3_redshift_subnet_group_create" {
  description = "Create ElastiCache subnet group for custom3 subnets"
  type        = bool
  default     = false
}

variable "custom3_redshift_subnet_group_name" {
  description = "Override auto-generated ElastiCache subnet group name"
  type        = string
  default     = ""
}

variable "custom3_redshift_subnet_group_description" {
  description = "Override auto-generated ElastiCache subnet group description"
  type        = string
  default     = ""
}

variable "custom3_redshift_subnet_group_azs" {
  description = "Limit redshift subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "custom3_redshift_subnet_group_tags" {
  description = "Map of additional tags to add to Redshift subnet group"
  type        = map(string)
  default     = {}
}

variable "custom3_tags" {
  description = "Map with additional tags to add to custom3 subnets"
  type        = map(string)
  default     = {}
}

variable "custom3_tags_per_subnet" {
  description = "List of maps with additional tags for each custom3 subnet"
  type        = list(map(string))
  default     = [{}]
}
