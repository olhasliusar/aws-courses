#!/bin/bash

echo "Test S3." > file.txt

aws s3api create-bucket --bucket olga-lohika-bucket \
    --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2 \
    --profile lohika-course

aws s3api put-bucket-versioning --bucket olga-lohika-bucket \
    --versioning-configuration Status=Enabled \
    --profile lohika-course

aws s3api put-object --bucket olga-lohika-bucket \
    --key file.txt \
    --body file.txt \
    --profile lohika-course
