# terraform-aws-vpc modules changelog

## 0.1.0

- Initial version

## 0.1.1

- Rebalance NAT Gateway routes in AZs without NATs

## 0.1.2

- Add possibility to use only AZ letter in tags instead of full AZ name

## 0.1.3

- Add possibility to specify availability zones for db, elasticache and redshift subnet groups

## 0.1.4

- Fix data_source aws_vpc_endpoint_service multiresult issu in vpc_endpoints module 
- FIX count issue for internet gateway and nat gateway routes