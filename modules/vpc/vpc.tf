# vpc/subnet관련 소스
# public subnet az1, 2
# service subnet az1, 2
# db subnet az1, 2
# igw
# nat
# routetable pub,pri
# routetable association

# VPC

resource "aws_vpc" "my_vpc" {
    cidr_block           = var.vpc_ip_range
    instance_tenancy     = "default"
    enable_dns_hostnames = true
}

# Subnet

# Public Subnet 1 (10.1.0.0/24)
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.subnet_public_az1
  availability_zone       = element(var.az, 0)
  map_public_ip_on_launch = true

  depends_on = [
    aws_vpc.my_vpc
  ]
}

# Private Subnet 1 (10.1.1.0/24)
resource "aws_subnet" "private_app_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_app_az1
  availability_zone = element(var.az, 0)
  map_public_ip_on_launch = true

  depends_on = [
    aws_vpc.my_vpc
  ]
}

# Private Subnet 2 (10.1.2.0/24)
resource "aws_subnet" "private_db_a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_db_az1
  availability_zone = element(var.az, 0)
  map_public_ip_on_launch = true
}

# AZ: ap-northeast-2c
# Public Subnet 2 (10.1.3.0/24)
resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_public_az2
  availability_zone = element(var.az, 1)
  map_public_ip_on_launch = true

  depends_on = [
    aws_vpc.my_vpc
  ]
}

# Private Subnet 3 (10.1.4.0/24)
resource "aws_subnet" "private_app_c" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_app_az2
  availability_zone = element(var.az, 1)
  map_public_ip_on_launch = true

  depends_on = [
    aws_vpc.my_vpc
  ]
}

# Private Subnet 4 (10.1.5.0/24)
resource "aws_subnet" "private_db_c" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.subnet_db_az2
  availability_zone = element(var.az, 1)
  map_public_ip_on_launch = true

  depends_on = [
    aws_vpc.my_vpc
  ]
}

# igw
resource "aws_internet_gateway" "my_igw" {
    vpc_id = aws_vpc.my_vpc.id
}

# EIP for NAT
resource "aws_eip" "nat_eip1" {
    # vpc = "true"
    depends_on = [aws_internet_gateway.my_igw]
}

resource "aws_eip" "nat_eip2" {
    # vpc = "true"
    depends_on = [aws_internet_gateway.my_igw]
}

# NAT
resource "aws_nat_gateway" "nat_gw_1" {
    allocation_id = aws_eip.nat_eip1.id
    subnet_id     = aws_subnet.public_a.id

    depends_on = [aws_internet_gateway.my_igw]
}

resource "aws_nat_gateway" "nat_gw_2" {
    allocation_id = aws_eip.nat_eip2.id
    subnet_id     = aws_subnet.public_c.id

    depends_on = [aws_internet_gateway.my_igw]
}

# routetable
resource "aws_route_table" "pub_rt" {
    vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "prv_rt1" {
    vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table" "prv_rt2" {
    vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "route_to_igw" {
  route_table_id         = aws_route_table.pub_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my_igw.id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "route_to_nat1" {
  route_table_id         = aws_route_table.prv_rt1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw_1.id
}

resource "aws_route" "route_to_nat2" {
  route_table_id         = aws_route_table.prv_rt2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw_2.id
}

# routetable association
resource "aws_route_table_association" "pub_rt_asso_az1" {
    subnet_id      = aws_subnet.public_a.id
    route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "pub_rt_asso_az2" {
    subnet_id      = aws_subnet.public_c.id
    route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "prv_app_rt_asso_az1" {
    subnet_id      = aws_subnet.private_app_a.id
    route_table_id = aws_route_table.prv_rt1.id
}

resource "aws_route_table_association" "prv_app_rt_asso_az2" {
    subnet_id      = aws_subnet.private_app_c.id
    route_table_id = aws_route_table.prv_rt2.id
}

# resource "aws_route_table_association" "prv_db_rt_asso_az1" {
#     subnet_id      = aws_subnet.private_db_a.id
#     route_table_id = aws_route_table.prv_rt1.id
# }

# resource "aws_route_table_association" "prv_db_rt_asso_az2" {
#     subnet_id      = aws_subnet.private_db_c.id
#     route_table_id = aws_route_table.prv_rt2.id
# }
