vpc_name = "main-vpc"

vpc_cidr_block = ["10.0.0.0/16"]

subnet_cidr_block = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]

public_subnets = ["public_subnet1", "public_subnet2"]

private_subnets = ["private_subnet1", "private_subnet2"]

availability_zones = ["us-east-1a", "us-east-1b"]

instance_type = "t2.micro"

key_name = "terraform"
