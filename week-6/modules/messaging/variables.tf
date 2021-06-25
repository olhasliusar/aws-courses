variable "sqs_name" {
  type        = string
  default     = "edu-lohika-training-aws-sqs-queue"
}

variable "sns_name" {
  type        = string
  default     = "edu-lohika-training-aws-sns-topic"
}

variable "sns_subs_email" {
  description = "Email for SNS subscription"
  type        = string
  default     = "otuznychenko@lohika.com"
}