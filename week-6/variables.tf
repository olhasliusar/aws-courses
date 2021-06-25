#################### EC2 ####################

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

####################  DB  ####################

variable "dynamodb_table" {
  description = "DynamoDB table name"
  type        = string
  default     = "edu-lohika-training-aws-dynamodb"
}

variable "postgres_db_name" {
  description = "Postgres DB name"
  type        = string
  default     = "EduLohikaTrainingAwsRds"
}

variable "postgres_user" {
  description = "Postgres DB User"
  type        = string
  default     = "rootuser"
}

variable "postgres_password" {
  description = "Postgres DB password"
  type        = string
  default     = "rootuser"
}

#################  MESSAGES  #################

variable "sns_name" {
  type        = string
  default     = "edu-lohika-training-aws-sns-topic"
}

variable "sqs_name" {
  type        = string
  default     = "edu-lohika-training-aws-sqs-queue"
}

variable "sns_subs_email" {
  description = "Email for SNS subscription"
  type        = string
  default     = "otuznychenko@lohika.com"
}

####################  VPC  ####################

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

#################### ./VPC ####################

