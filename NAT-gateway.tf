
# Create a NAT Gateway in each availability zone
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat-eip1.id
  subnet_id     = aws_subnet.public_subnet1.id
  tags = {
    Name = "NAT Gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gateway2" {
  allocation_id = aws_eip.nat-eip2.id
  subnet_id     = aws_subnet.public_subnet2.id
  tags = {
    Name = "NAT Gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}

# Create an Elastic IP for each NAT Gateway
resource "aws_eip" "nat-eip1" {
  associate_with_private_ip = true
}

resource "aws_eip" "nat-eip2" {
  associate_with_private_ip = true
}
