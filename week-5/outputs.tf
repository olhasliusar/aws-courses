output "sqs_url" {
  description = "SQS queue URL"
  value       = aws_sqs_queue.queue.id
}

output "sns_topic" {
  description = "SNS topic"
  value       = aws_sns_topic.sns.arn
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.my_ec2.public_ip
}
