#vpc                 

resource "aws_vpc" "avg_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "avg-vpc"
  }
}

# Public Subnet 1 - us-east-1a
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.avg_vpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "avg-public-subnet-1"
  }
}

# Public Subnet 2 - us-east-1b
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.avg_vpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "avg-public-subnet-2"
  }
}

# Private App Subnet 1 - us-east-1a
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.avg_vpc.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "avg-private-subnet-1"
  }
}

# Private App Subnet 2 - us-east-1b
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.avg_vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "avg-private-subnet-2"
  }
}

# Private DB Subnet 1 - us-east-1a
resource "aws_subnet" "db_1" {
  vpc_id            = aws_vpc.avg_vpc.id
  cidr_block        = var.db_subnet_1_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "avg-db-subnet-1"
  }
}

# Private DB Subnet 2 - us-east-1b
resource "aws_subnet" "db_2" {
  vpc_id            = aws_vpc.avg_vpc.id
  cidr_block        = var.db_subnet_2_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "avg-db-subnet-2"
  }
}

#internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.avg_vpc.id

  tags = {
    Name = "avg-igw"
  }
}


# ELASTIC IPs (for NAT)   


resource "aws_eip" "nat_eip_1" {
  vpc = true

  tags = {
    Name = "avg-nat-eip-1"
  }
}

resource "aws_eip" "nat_eip_2" {
  vpc = true

  tags = {
    Name = "avg-nat-eip-2"
  }
}


# NAT GATEWAYS


resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public_1.id

  tags = {
    Name = "avg-nat-1"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_2.id

  tags = {
    Name = "avg-nat-2"
  }

  depends_on = [aws_internet_gateway.igw]
}


# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.avg_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "avg-public-rt"
  }
}

# Private Route Table 1 (App subnet 1 + DB subnet 1)
resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.avg_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }

  tags = {
    Name = "avg-private-rt-1"
  }
}

# Private Route Table 2 (App subnet 2 + DB subnet 2)
resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.avg_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_2.id
  }

  tags = {
    Name = "avg-private-rt-2"
  }
}
         

# Associate public subnets to public route table
resource "aws_route_table_association" "public_1_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate private app subnets
resource "aws_route_table_association" "private_1_assoc" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_route_table_association" "private_2_assoc" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_rt_2.id
}

# Associate DB subnets
resource "aws_route_table_association" "db_1_assoc" {
  subnet_id      = aws_subnet.db_1.id
  route_table_id = aws_route_table.private_rt_1.id
}

resource "aws_route_table_association" "db_2_assoc" {
  subnet_id      = aws_subnet.db_2.id
  route_table_id = aws_route_table.private_rt_2.id
}
