#----------------- Create a Subnets -----------------#
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr_block[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnets[0]
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr_block[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags = {
    Name = var.public_subnets[1]
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block[2]
  availability_zone = var.availability_zones[0]
  tags = {
    Name = var.private_subnets[0]
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_block[3]
  availability_zone = var.availability_zones[1]
  tags = {
    Name = var.private_subnets[1]
  }
}
