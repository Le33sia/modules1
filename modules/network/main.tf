resource "aws_vpc" "demovpc" {
  cidr_block           = var.vpc_cidr_block
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = {
    Name = "Demo VPC"
  }
}
resource "aws_internet_gateway" "demogateway" {
  vpc_id = var.vpc_id
}
# 1st public subnet 
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet1_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[0]
  tags = {
    Name = "Public subnet 1"
  }
}
# 2nd public subnet 
resource "aws_subnet" "public_subnet2" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet2_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[1]
  tags = {
    Name = "Public subnet 2"
  }
}
# Route Table
resource "aws_route_table" "route" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demogateway.id
  }
  tags = {
    Name = "Route to internet"
  }
}
resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.route.id
}
resource "aws_route_table_association" "rt2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.route.id
}




# 1st private subnet
resource "aws_subnet" "private_subnet1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet1_cidr
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = false
  tags = {
    Name = "Private Subnet 1"
  }
}

# 2nd private subnet
resource "aws_subnet" "private_subnet2" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet2_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "Private Subnet 2"
  }
}
# route table for private subnets
resource "aws_route_table" "private_route" {
  vpc_id = var.vpc_id
  tags = {
    Name = "Private Route Table"
  }
}

# Associate private subnets with the private route table
resource "aws_route_table_association" "private_subnet1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private_subnet2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_route.id
}





