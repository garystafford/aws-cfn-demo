# AWS CloudFormation Demonstration

_work in progress..._

Demonstration of an Infrastructure as Code (IaC) CI/CD pipeline. Use AWS CloudFormation to create AWS CodePipeline pipeline and associated resources. Then, use the pipeline to test and deploy AWS resources, using a CloudFormation template, CloudFormation configuration file, and CloudFormation stack change set.

Compare the use of a pipeline with using the AWS CLI to execute similar CloudFormation functionality.

## Getting Started with AWS CodePipeline Demo

```bash
aws cloudformation create-stack \
  --stack-name cfn-demo-iam \
  --template-body file://cfn-templates/code_commit_iam.yaml \
  --capabilities CAPABILITY_IAM

aws cloudformation create-stack \
  --stack-name cfn-demo-code-commit \
  --template-body file://cfn-templates/code_commit.yaml \
  --capabilities CAPABILITY_IAM
```

For HTTPS: Manually create 'HTTPS Git credentials for AWS CodeCommit' for IAM User. Can't do with CFN?  

For SSH: Manually upload 'SSH keys for AWS CodeCommit' public key for IAM User. Can't do with CFN?

```bash
cat ~/.ssh/id_rsa.pub | pbcopy
```

Remove older codecommit cred entries if necessary

- <https://docs.aws.amazon.com/codecommit/latest/userguide/troubleshooting-ch.html#troubleshooting-macoshttps>  
- <https://stackoverflow.com/a/20195558/580268>  

```bash
git config --global credential.helper osxkeychain
```

```bash
nano ~/.ssh/known_hosts
```

```bash
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true

# for https:
git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/cfn-demo-repo

# ignore empty repo message...

# or for ssh:
git clone ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/cfn-demo-repo


cd cfn-demo-repo
cp ../aws-cfn-demo/code-commit-source-code/*.* .
cp ../aws-cfn-demo/code-commit-source-code/.gitignore .
cp -R ../aws-cfn-demo/code-commit-source-code/data/ ./data
```

Commit files in the `code-commit-source-code` directory to the new AWS CodeCommit repository.

```bash
git add -A
git commit -m"Initial commit"
git push
```

The `cfn-demo-code-commit` stack must succeed before creating next stack!

```bash
aws cloudformation create-stack \
  --stack-name cfn-demo-code-pipeline \
  --template-body file://cfn-templates/code_pipeline.yaml \
  --capabilities CAPABILITY_IAM
```

```bash
aws codepipeline start-pipeline-execution --name CloudFormationDemo
```

## Helpful AWS CLI Commands

```bash
aws cloudformation help
aws cloudformation create-stack help
```

## Create and Update Demo Stack using AWS CLI

```bash
aws cloudformation create-stack \
  --stack-name cfn-demo-dynamo \
  --template-body file://dynamo.yaml \
  --parameters ParameterKey=ReadCapacityUnits,ParameterValue=10 \
               ParameterKey=WriteCapacityUnits,ParameterValue=25

aws cloudformation describe-stack-events \
    --stack-name cfn-demo-dynamo | jq .

aws cloudformation update-stack \
  --stack-name cfn-demo-dynamo \
  --template-body file://dynamo.yaml \
  --parameters ParameterKey=ReadCapacityUnits,ParameterValue=5 \
               ParameterKey=WriteCapacityUnits,ParameterValue=15
```

## Create and Execute Demo Stack Change Set using AWS CLI

```bash
aws cloudformation create-change-set \
    --stack-name cfn-demo-dynamo \
    --change-set-name demo-change-set \
    --template-body file://dynamo_v2.yaml \
    --parameters ParameterKey=ReadCapacityUnits,ParameterValue=5 \
                 ParameterKey=WriteCapacityUnits,ParameterValue=15

aws cloudformation execute-change-set \
    --stack-name cfn-demo-dynamo \
    --change-set-name demo-change-set
```

## Detect Stack Drift using AWS CLI

```bash
aws cloudformation detect-stack-drift \
    --stack-name cfn-demo-dynamo

aws cloudformation describe-stack-resource-drifts \
    --stack-name cfn-demo-dynamo
```

## Delete Demo Stacks using AWS CLI

Delete one stack at a time, letting each one finish completely, before proceeding to the next stack.

```bash
aws cloudformation delete-stack --stack-name cfn-demo-dynamo

aws cloudformation delete-stack --stack-name cfn-demo-code-pipeline
aws cloudformation delete-stack --stack-name cfn-demo-code-commit

# manaully delete HTTPS Git credentials for AWS CodeCommit 
# from CodeCommitPowerUser from console or next step will fail
aws cloudformation delete-stack --stack-name cfn-demo-iam
```

## References

- <https://docs.aws.amazon.com/codebuild/latest/userguide/jenkins-plugin.html>  
- <https://github.com/stelligent/cloudformation_templates/blob/master/labs/codebuild/codebuild.yml>  
- <https://kb.novaordis.com/index.php/AWS_CodeBuild_Buildspec>  
- <https://github.com/adrienverge/yamllint>  
- <https://docs.aws.amazon.com/codepipeline/latest/userguide/tutorials-cloudformation-codecommit.html>
- <https://aws.amazon.com/blogs/devops/custom-lookup-using-aws-lambda-and-amazon-dynamodb/>
- <https://docs.aws.amazon.com/codebuild/latest/userguide/jenkins-plugin.html>
- <https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/deploying.applications.html>