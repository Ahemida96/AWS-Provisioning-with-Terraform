variable "vpc_name" {
  description = "The name of the VPC"
  type        = string

}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = list(any)
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "The public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "The private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "The availability zone"
  type        = list(string)
}

variable "instance_type" {
  description = "The type of instance to launch"
  type        = string
  #   default     = "t2.micro"
}
