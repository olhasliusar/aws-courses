#!/bin/bash

aws s3api create-bucket --bucket olga-lohika-bucket \
    --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2 \
    --profile lohika-course

aws s3api put-object --bucket olga-lohika-bucket \
    --key rds-script.sql \
    --body rds-script.sql \
    --profile lohika-course

aws s3api put-object --bucket olga-lohika-bucket \
    --key dynamodb-script.sh \
    --body dynamodb-script.sh \
    --profile lohika-course
