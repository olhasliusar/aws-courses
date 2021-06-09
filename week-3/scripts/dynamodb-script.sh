#!/bin/bash

aws dynamodb list-tables --region us-west-2

aws dynamodb put-item --table-name course \
  --item '{"id":{"N":"1"},"lesson":{"S":"S3"},"type":{"N":"0"}}' --region us-west-2

aws dynamodb get-item --table-name course --key '{"id":{"N":"1"}}' --region us-west-2
aws dynamodb get-item --table-name course --key '{"id":{"N":"0"}}' --region us-west-2
