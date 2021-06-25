#!/bin/bash

# messaging
aws sqs send-message --queue-url "https://sqs.us-west-2.amazonaws.com/305838294209/lohika-queue" \
  --message-body "hello sqs" --region us-west-2

aws sqs receive-message --queue-url "https://sqs.us-west-2.amazonaws.com/305838294209/lohika-queue" \
  --region us-west-2

aws sns publish --topic "arn:aws:sns:us-west-2:305838294209:edu-lohika-training-aws-sns-topic" \
  --message "hello sns" --region us-west-2

# rds

psql \
   --host=terraform-20210625161805322900000001.cnanhz7lfctk.us-west-2.rds.amazonaws.com \
   --port=5432 \
   --dbname=EduLohikaTrainingAwsRds \
   --username=rootuser \
   -c 'SELECT * FROM LOGS;'

# dynamodb

aws dynamodb scan --table-name edu-lohika-training-aws-dynamodb --region us-west-2
