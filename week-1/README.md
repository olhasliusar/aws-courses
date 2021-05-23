## Preparation

Create Key Pair for ability to use SSH.

## Create stack 

```shell
aws --profile lohika-course cloudformation create-stack --stack-name lohika-course \
  --template-body file://week-1/week-1.yml \
  --parameters ParameterKey=InstanceTypeParameter,ParameterValue=t2.micro
```

## Delete stack

```shell
aws --profile lohika-course cloudformation delete-stack --stack-name lohika-course
```

## JAVA

[Install steps](https://docs.aws.amazon.com/corretto/latest/corretto-8-ug/amazon-linux-install.html) used in template

#### Verify installation

Connect to EC2 instance via SSH. Example:
```shell
ssh -i "key.pem" ec2-user@ec2-54-190-1-229.us-west-2.compute.amazonaws.com
```

Check version
```shell
java -version
```

