
# Create a NAT Gateway in each availability zone
resource "aws_nat_gateway" "nat_gateway-a" {
  allocation_id = aws_eip.nat-eip-a.id
  subnet_id     = aws_subnet.public_subnet1.id
  tags = {
    Name = "NAT Gateway A"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gateway-b" {
  allocation_id = aws_eip.nat-eip-b.id
  subnet_id     = aws_subnet.public_subnet2.id
  tags = {
    Name = "NAT Gateway B"
  }
  depends_on = [aws_internet_gateway.igw]
}

# Create an Elastic IP for each NAT Gateway
resource "aws_eip" "nat-eip-a" {
  associate_with_private_ip = true
}

resource "aws_eip" "nat-eip-b" {
  associate_with_private_ip = true
}
