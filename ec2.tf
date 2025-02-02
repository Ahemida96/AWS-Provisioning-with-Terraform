data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"] #canonical
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["137112412989"] # Amazon
}


# resource "aws_instance" "private_instance1" {
#   ami             = data.aws_ami.ubuntu.id
#   instance_type   = var.instance_type
#   subnet_id       = aws_subnet.private_subnet1.id
#   security_groups = [aws_security_group.sg-1.id]
#   key_name        = var.key_name
#   user_data       = <<-EOF
#                     #!/bin/bash
#                     sudo yum update -y
#                     sudo yum install -y httpd
#                     sudo systemctl start httpd
#                     sudo systemctl enable httpd
#                     echo ?Hello World from $(hostname -I)? > /var/www/html/index.html
#                     EOF
#   tags = {
#     Name = "private-instance1"
#   }
# }

# resource "aws_instance" "private_instance2" {
#   ami             = data.aws_ami.ubuntu.id
#   instance_type   = var.instance_type
#   subnet_id       = aws_subnet.private_subnet2.id
#   security_groups = [aws_security_group.sg-2.id]
#   user_data       = <<-EOF
#                     #!/bin/bash
#                     sudo yum update -y
#                     sudo yum install -y httpd
#                     sudo systemctl start httpd
#                     sudo systemctl enable httpd
#                     echo ?Hello World from $(hostname -I)? > /var/www/html/index.html
#                     EOF
#   key_name        = var.key_name
#   tags = {
#     Name = "private-instance2"
#   }
# }
