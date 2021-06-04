variable "instance_ami" {
  description = "EC2 instance image id"
  type        = string
  default     = "ami-0cf6f5c8a62fa5da6"
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
  default     = "vpc-be2b1ec6"
}

variable "subnet_id" {
  description = "Subnet id"
  type        = string
  default     = "subnet-6697111e"
}

variable "key_pair" {
  description = "Name of an existing EC2 key pair for SSH access to the EC2 instance"
  type        = string
  default     = "LohikaKeyPair"
}
