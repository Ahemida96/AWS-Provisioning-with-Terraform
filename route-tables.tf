#----------------- Create a Public Route Tables -----------------#
resource "aws_route_table" "public_route_table1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table" "public_route_table2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public Route Table"
  }
}

#----------------- Associate the Public Route Tables with the Subnets -----------------#
resource "aws_route_table_association" "public_route_table_association1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route_table1.id

}

resource "aws_route_table_association" "public_route_table_association2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route_table2.id
}

#----------------- Create a Private Route Table -----------------#
resource "aws_route_table" "private_route_table1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway-a.id
  }
  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table" "private_route_table2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway-b.id
  }
  tags = {
    Name = "Private Route Table"
  }
}

#----------------- Associate the Private Route Table with the Subnets -----------------#
resource "aws_route_table_association" "private_route_table_association1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_route_table1.id
}

resource "aws_route_table_association" "private_route_table_association2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_route_table2.id
}
