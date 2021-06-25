resource "aws_sqs_queue" "queue" {
  name = var.sqs_name
}

resource "aws_sns_topic" "sns" {
  name = var.sns_name
}

resource "aws_sns_topic_subscription" "lohika-subs" {
  topic_arn = aws_sns_topic.sns.arn
  protocol  = "email"
  endpoint  = var.sns_subs_email
}
