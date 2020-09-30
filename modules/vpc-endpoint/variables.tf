variable "name" {
  description = "Name for the VPC Endpoint"
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Override default name_suffix for VPC Endpoint"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID where VPC Endpoint will be created"
  type        = string
}

variable "endpoint" {
  description = "VPC Endpoint name. Please refer README.md for all available VPC Endpoints names"
  type        = string
}

variable "security_group_ids" {
  description = "List of security groups ids to attach to VPC Endpoint"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "List of subnets ids attach VPC Endpoint to. Only applicaple for VPC Endpoints with type Interface"
  type        = list(string)
  default     = []
}

variable "route_table_ids" {
  description = "List of route table ids to associate VPC Endpoint to. Only applicaple for VPC Endpoints with type Gateway"
  type        = list(string)
  default     = []
}

variable "route_table_association_num" {
  description = "Pass numbet of route table IDs for count values"
  type        = number
  default     = 0
}

variable "private_dns_enabled" {
  description = "Enable private DNS for VPC Endpoint"
  type        = bool
  default     = false
}

variable "sagemaker_notebook_endpoint_region" {
  description = "Only required to create sagemaker_notebook VPC Endpoint"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Map of tags to add to the VPC Endpoint"
  type        = map(string)
  default     = {}
}
