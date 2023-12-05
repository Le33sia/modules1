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
  vpc_id = aws_vpc.demovpc.id
}
<<<<<<< HEAD
#public subnets 
resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.demovpc.id
  map_public_ip_on_launch = true
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  tags                    = merge({ Name = each.key }, each.value.tags)
=======
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
>>>>>>> 5a414d40ba8b957aa6985f554151a403a9647e3f
}

# Route Table
resource "aws_route_table" "route" {
<<<<<<< HEAD
  vpc_id = aws_vpc.demovpc.id
=======
  vpc_id = var.vpc_id
>>>>>>> 5a414d40ba8b957aa6985f554151a403a9647e3f
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demogateway.id
  }
<<<<<<< HEAD
=======
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
>>>>>>> 5a414d40ba8b957aa6985f554151a403a9647e3f
  tags = {
    Name = "Route to internet"
  }
}
<<<<<<< HEAD
resource "aws_route_table_association" "rt" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public_subnets[each.key].id
  route_table_id = aws_route_table.route.id
=======

# 2nd private subnet
resource "aws_subnet" "private_subnet2" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet2_cidr
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = false
  tags = {
    Name = "Private Subnet 2"
  }
>>>>>>> 5a414d40ba8b957aa6985f554151a403a9647e3f
}

resource "aws_subnet" "private_subnets" {
  for_each                = var.private_subnets
  vpc_id                  = aws_vpc.demovpc.id
  map_public_ip_on_launch = true
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  tags                    = merge({ Name = each.key }, each.value.tags)
}

# route table for private subnets
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.demovpc.id
  tags = {
    Name = "Private Route Table"
  }
}
# Associate private subnets with the private route table
<<<<<<< HEAD
resource "aws_route_table_association" "rt_private" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private_subnets[each.key].id
=======
resource "aws_route_table_association" "private_subnet1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private_subnet2" {
  subnet_id      = aws_subnet.private_subnet2.id
>>>>>>> 5a414d40ba8b957aa6985f554151a403a9647e3f
  route_table_id = aws_route_table.private_route.id
}



