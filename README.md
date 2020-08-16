# AWS CloudFormation Demonstration

_work in progress..._

## Getting Started AWS CodePipeline Demo

```bash
aws cloudformation create-stack \
  --stack-name cfn-demo-code-commit \
  --template-body file://cfn-templates/code_commit.yaml \
  --capabilities CAPABILITY_IAM

# cfn-demo-code-commit stack must succeed first!

aws cloudformation create-stack \
  --stack-name cfn-demo-code-pipeline \
  --template-body file://cfn-templates/code_pipeline.yaml \
  --capabilities CAPABILITY_IAM
```

Manually created 'HTTPS Git credentials for AWS CodeCommit' for IAM User. Can't do with CFN?  
Manually uploaded 'SSH keys for AWS CodeCommit' public key for IAM User. Can't do with CFN?

```bash
aws codepipeline start-pipeline-execution --name CloudFormationDemo
```

## Helpful Commands

```bash
aws cloudformation help
aws cloudformation create-stack help
```

## Create and Update Demo Stack

```bash
aws cloudformation create-stack \
  --stack-name cfn-demo-dynamo \
  --template-body file://dynamo.yaml \
  --parameters ParameterKey=HashKeyElementName,ParameterValue=Artist \
               ParameterKey=HashKeyElementType,ParameterValue=S \
               ParameterKey=ReadCapacityUnits,ParameterValue=10 \
               ParameterKey=WriteCapacityUnits,ParameterValue=25

aws cloudformation describe-stack-events \
    --stack-name cfn-demo-dynamo | jq .

aws cloudformation update-stack \
  --stack-name cfn-demo-dynamo \
  --template-body file://dynamo.yaml \
  --parameters ParameterKey=HashKeyElementName,ParameterValue=ArtistId \
               ParameterKey=HashKeyElementType,ParameterValue=N \
               ParameterKey=ReadCapacityUnits,ParameterValue=5 \
               ParameterKey=WriteCapacityUnits,ParameterValue=15
```

## Create and Execute Demo Stack Change Set

```bash
aws cloudformation create-change-set \
    --stack-name cfn-demo-dynamo \
    --change-set-name demo-change-set \
    --template-body file://dynamo_v2.yaml \
    --parameters ParameterKey=HashKeyElementName,ParameterValue=ArtistId \
                 ParameterKey=HashKeyElementType,ParameterValue=N \
                 ParameterKey=ReadCapacityUnits,ParameterValue=5 \
                 ParameterKey=WriteCapacityUnits,ParameterValue=15

aws cloudformation execute-change-set \
    --stack-name cfn-demo-dynamo \
    --change-set-name demo-change-set
```

## Delete Demo Stack

```bash
aws cloudformation delete-stack \
    --stack-name cfn-demo-dynamo
```

## References

- <https://docs.aws.amazon.com/codebuild/latest/userguide/jenkins-plugin.html>  
- <https://github.com/stelligent/cloudformation_templates/blob/master/labs/codebuild/codebuild.yml>  
- <https://kb.novaordis.com/index.php/AWS_CodeBuild_Buildspec>  
- <https://github.com/adrienverge/yamllint>  
- <https://docs.aws.amazon.com/codepipeline/latest/userguide/tutorials-cloudformation-codecommit.html>
