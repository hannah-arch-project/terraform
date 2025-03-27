output "db-az1" {
  value = aws_subnet.private_db_a
}

output "db-az2" {
  value = aws_subnet.private_db_c
}

output "network-vpc" {
  value = aws_vpc.my_vpc
}

output "public-az1" {
  value = aws_subnet.public_a
}
output "public-az2" {
  value = aws_subnet.public_c
}
output "service-az1" {
  value = aws_subnet.private_app_a
}

output "service-az2" {
  value = aws_subnet.private_app_c
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}
output "vpc_cidr" {
  value = aws_vpc.my_vpc.cidr_block
}
output "nat_ip_a" {
  value = aws_eip.nat_eip1.public_ip
}
output "nat_ip_c" {
  value = aws_eip.nat_eip2.public_ip
}
output "nat_id_a" {
  value = aws_nat_gateway.nat_gw_1.id
}
output "nat_id_c" {
  value = aws_nat_gateway.nat_gw_2.id
}
output "pri_rt_id_a" {
  value = aws_route_table.prv_rt1.id
}
output "pri_rt_id_c" {
  value = aws_route_table.prv_rt2.id
}

output "private_app_subnet_ids" {
  description = "List of private subnets for ALB/EC2"
  value       = [aws_subnet.private_app_a.id, aws_subnet.private_app_c.id]
}

output public_app_subnet_ids {
  description = "List of public subnets for ALB/EC2"
  value       = [aws_subnet.public_a.id, aws_subnet.public_c.id]
}