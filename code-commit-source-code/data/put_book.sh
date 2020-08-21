# Author: Gary A. Stafford
# Put data into Amazon DynamoDB table, then scan to confirm
# Use: sh ./put_book.sh


# get new function name
# FUNCTION=$(aws dynamodb list-tables | grep cfn-demo-dynamo-Books | sed -e 's/^[ \t]*//' | tr -d '"')
FUNCTION=$(aws lambda list-functions | jq -r '.[] | .[] | select(.FunctionName | contains("cfn-demo-dynamo-LambdaFunction")) .FunctionName')

# loop through all books test
jq -c '.[]' books.json | while read -r book; do
  echo "$book"
  aws lambda invoke \
    --function-name "$FUNCTION" \
    --payload "$book" \
    --invocation-type Event \
    --cli-binary-format raw-in-base64-out \
    output.log
done

# single book test
aws lambda invoke \
  --function-name "$FUNCTION" \
  --payload "$(cat book.json)" \
  --cli-binary-format raw-in-base64-out \
  output.log

#TABLE=$(aws dynamodb list-tables | grep cfn-demo-dynamo-Books | sed -e 's/^[ \t]*//' | tr -d '"')
TABLE=$(aws dynamodb list-tables | jq -r '.[] | .[] | select(. | contains("cfn-demo-dynamo-Books"))')

aws dynamodb scan --table-name "$TABLE"
