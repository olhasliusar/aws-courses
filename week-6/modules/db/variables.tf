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

variable "vpc_id" {
  type = string
}

variable "postgres_subnets" {
  type = list(any)
}
