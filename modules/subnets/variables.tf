variable "name" {
  description = "Identified which will be used on all created resources in the Nmae tag"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "vpc id where create subnets"
  type        = string
}

variable "azs" {
  description = "List of availability zones names or ids in the region to create subnets"
  type        = list(string)
  default     = []
}

variable "azs_short_name" {
  description = "Use only AZ letter in tags instead of full AZ name"
  type        = bool
  default     = false
}

variable "cidrs" {
  description = "List of subnet's cidrs"
  type        = list(string)
}

variable "enable_ipv6" {
  description = "Does IPv6 enable for the VPC where subnets will be created"
  type        = bool
  default     = false
}

variable "vpc_ipv6_cidr_block" {
  description = "VPC ipv6_cidr_block"
  type        = string
  default     = ""
}

variable "ipv6_prefixes" {
  description = "Assigns IPv6 public subnet id based on the Amazon provided /56 prefix base 10 integer (0-256). Must be of equal length to IPv4 public subnets cidrs list"
  type        = list(string)
  default     = []
}

variable "nat_gateways_ids" {
  description = "List of NAT gateways IDs to create route in route tables (requires create_route_tables = true)"
  type        = list(string)
  default     = []
}

variable "internet_gateway_id" {
  description = "Internet gateway ID to create route in route tables. Takes precedence over nat_gateway_ids (requires create_route_tables = true)"
  type        = string
  default     = ""
}

variable "egress_only_igw_id" {
  description = "Egress-only internet gateway ID to create route in route tables. (requires create_route_tables = true)"
  type        = string
  default     = ""
}

variable "map_public_ip_on_launch" {
  description = "Auto-assign public ip on instance launch"
  type        = bool
  default     = false
}

variable "map_public_ip_on_launch_per_subnet" {
  description = "Specify map_public_ip_on_launch per subnet"
  type        = list(bool)
  default     = []
}

variable "assign_ipv6_address_on_creation" {
  description = "Auto-assign public ip on instance launch"
  type        = bool
  default     = false
}

variable "assign_ipv6_address_on_creation_per_subnet" {
  description = "Specify assign_ipv6_address_on_creation per subnet"
  type        = list(bool)
  default     = []
}

variable "route_table_create" {
  description = "Create route tables for subnets and attach them"
  type        = bool
  default     = true
}

variable "route_table_ids" {
  description = "List of route tables ids to associate with networks. Requires route_table_create = false. If route_table_create = false and no route tables ids are passes, default VPC route table will be associated by AWS automatically"
  type        = list(string)
  default     = []
}

variable "route_table_single" {
  description = "Create single route table for all subnets. Requires route_table_create = true"
  type        = bool
  default     = false
}

variable "route_table_tags" {
  description = "Tags to add to created route tables"
  type        = map(string)
  default     = {}
}

variable "route_table_tags_per_route_table" {
  description = "List of maps with additional tags for each route table"
  type        = list(map(string))
  default     = [{}]
}

variable "network_acl_create" {
  description = "Create dedicated network ACL and attach it to the subnets"
  type        = bool
  default     = false
}

variable "network_acl_inbound_rules" {
  description = "Dedicated network ACL inbound rules"
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

variable "network_acl_outbound_rules" {
  description = "Dedicated network ACL outbound rules"
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

variable "network_acl_tags" {
  description = "Additional tags to add to the network ACL"
  type        = map(string)
  default     = {}
}

variable "db_subnet_group_create" {
  description = "Create RDS DB subnet group for private subnets"
  type        = bool
  default     = false
}

variable "db_subnet_group_name" {
  description = "Override auto-generated RDS DB subnet group name"
  type        = string
  default     = ""
}

variable "db_subnet_group_description" {
  description = "Override auto-generated RDS DB subnet group description"
  type        = string
  default     = ""
}

variable "db_subnet_group_azs" {
  description = "Limit db subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "db_subnet_group_tags" {
  description = "Map of additional tags to add to RDS DB subnet group"
  type        = map(string)
  default     = {}
}

variable "elasticache_subnet_group_create" {
  description = "Create ElastiCache subnet group for private subnets"
  type        = bool
  default     = false
}

variable "elasticache_subnet_group_name" {
  description = "Override auto-generated ElastiCache subnet group name"
  type        = string
  default     = ""
}

variable "elasticache_subnet_group_description" {
  description = "Override auto-generated ElastiCache subnet group description"
  type        = string
  default     = ""
}

variable "elasticache_subnet_group_azs" {
  description = "Limit elasticache subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "redshift_subnet_group_create" {
  description = "Create ElastiCache subnet group for private subnets"
  type        = bool
  default     = false
}

variable "redshift_subnet_group_name" {
  description = "Override auto-generated ElastiCache subnet group name"
  type        = string
  default     = ""
}

variable "redshift_subnet_group_description" {
  description = "Override auto-generated ElastiCache subnet group description"
  type        = string
  default     = ""
}

variable "redshift_subnet_group_azs" {
  description = "Limit redshift subnet group only to specific availability zones"
  type        = list(string)
  default     = []
}

variable "redshift_subnet_group_tags" {
  description = "Map of additional tags to add to Redshift subnet group"
  type        = map(string)
  default     = {}
}

variable "vpn_gateway_id" {
  description = "ID of existed VPN Gateway to enable route propagation"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Map of tags to add to all created resources"
  type        = map(string)
  default     = {}
}

variable "tags_per_subnet" {
  description = "List of maps with additional tags for each subnet"
  type        = list(map(string))
  default     = [{}]
}
