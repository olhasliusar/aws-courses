variable "instance_ami" {
  description = "EC2 instance image id"
  type        = string
  default     = "ami-0cf6f5c8a62fa5da6"
}

variable "key_pair" {
  description = "Name of an existing EC2 key pair for SSH access to the EC2 instance"
  type        = string
  default     = "LohikaKeyPair"
}

variable "sns_subs_email" {
  description = "Email for SNS subscription"
  type        = string
  default     = "otuznychenko@lohika.com"
}
