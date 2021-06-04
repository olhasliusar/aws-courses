## Create stack 

```shell
aws cloudformation create-stack --stack-name lohika-course \
  --template-body file://cloudformation/week-2.yml --capabilities CAPABILITY_NAMED_IAM \
  --profile lohika-course
```

## Delete stack

```shell
aws --profile lohika-course cloudformation delete-stack --stack-name lohika-course
```
