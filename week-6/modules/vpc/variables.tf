variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    public_1 = {
      cidr_block        = "10.0.1.0/24",
      availability_zone = "us-west-2a"
    }
    public_2 = {
      cidr_block        = "10.0.2.0/24",
      availability_zone = "us-west-2b"
    }
  }
}

variable "private_subnets" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
  }))
  default = {
    private_1 = {
      cidr_block        = "10.0.3.0/24",
      availability_zone = "us-west-2a"
    },
    private_2 = {
      cidr_block        = "10.0.4.0/24",
      availability_zone = "us-west-2b"
    }
  }
}
