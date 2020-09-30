output "endpoint" { value = { for k, v in aws_vpc_endpoint.this : k => v if contains(["tags", "timeouts"], k) == false } }
