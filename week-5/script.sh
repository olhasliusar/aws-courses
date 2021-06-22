#!/bin/bash

aws sqs send-message --queue-url "https://sqs.us-west-2.amazonaws.com/305838294209/lohika-queue" \
  --message-body "hello sqs" --region us-west-2

aws sqs receive-message --queue-url "https://sqs.us-west-2.amazonaws.com/305838294209/lohika-queue" \
  --region us-west-2

aws sns publish --topic "arn:aws:sns:us-west-2:305838294209:lohika-sns" \
  --message "hello sns" --region us-west-2
