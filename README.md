# AWS CloudFormation Demonstration

_work in progress..._

## Helpful Commands

```bash
aws cloudformation help

aws cloudformation create-stack help

aws cloudformation create-stack \
  --stack-name cfn-demo-code-commit \
  --template-body file://cfn-templates/code_commit.yaml \
  --capabilities CAPABILITY_IAM

aws cloudformation create-stack \
  --stack-name cfn-demo-code-pipeline \
  --template-body file://cfn-templates/code_pipeline.yaml \
  --capabilities CAPABILITY_IAM

aws cloudformation delete-stack \
    --stack-name cfn-demo-code-commit

aws codebuild start-build --project-name CloudFormationDemo

aws cloudformation create-stack \
  --stack-name cfn-demo-dynamo \
  --template-body file://dynamo_1.yaml \
  --parameters ParameterKey=HashKeyElementName,ParameterValue=Artist \
               ParameterKey=HashKeyElementType,ParameterValue=S \
               ParameterKey=ReadCapacityUnits,ParameterValue=10 \
               ParameterKey=WriteCapacityUnits,ParameterValue=25

aws cloudformation describe-stack-events --stack-name cfn-demo-dynamo | jq .

aws cloudformation update-stack \
  --stack-name cfn-demo-dynamo \
  --template-body file://dynamo_1.yaml \
  --parameters ParameterKey=HashKeyElementName,ParameterValue=ArtistId \
               ParameterKey=HashKeyElementType,ParameterValue=N \
               ParameterKey=ReadCapacityUnits,ParameterValue=5 \
               ParameterKey=WriteCapacityUnits,ParameterValue=15

aws cloudformation create-change-set \
    --stack-name cfn-demo-dynamo \
    --change-set-name v2-change-set \
    --template-body file://dynamo_2.yaml \
    --parameters ParameterKey=HashKeyElementName,ParameterValue=ArtistId \
                 ParameterKey=HashKeyElementType,ParameterValue=N \
                 ParameterKey=ReadCapacityUnits,ParameterValue=5 \
                 ParameterKey=WriteCapacityUnits,ParameterValue=15

aws cloudformation execute-change-set \
    --stack-name cfn-demo-dynamo \
    --change-set-name new-table-change-set

aws cloudformation delete-stack --stack-name cfn-demo-dynamo

```

## References

- <https://docs.aws.amazon.com/codebuild/latest/userguide/jenkins-plugin.html>  
- <https://github.com/stelligent/cloudformation_templates/blob/master/labs/codebuild/codebuild.yml>  
- <https://kb.novaordis.com/index.php/AWS_CodeBuild_Buildspec>  
- <https://github.com/adrienverge/yamllint>  
- <https://docs.aws.amazon.com/codepipeline/latest/userguide/tutorials-cloudformation-codecommit.html>
