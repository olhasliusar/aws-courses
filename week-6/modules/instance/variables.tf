variable "instance_ami" {
  description = "EC2 instance image id"
  type        = string
  default     = "ami-0cf6f5c8a62fa5da6"
}

variable "nat_instance_ami" {
  description = "NAT EC2 instance image id"
  type        = string
  default     = "ami-0032ea5ae08aa27a2"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_pair" {
  description = "Name of an existing EC2 key pair for SSH access to the EC2 instance"
  type        = string
  default     = "LohikaKeyPair"
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(any)
}

variable "private_subnets" {
  type = list(any)
}

variable "rds_endpoint" {
  type = string
}