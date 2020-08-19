# get new function name
# FUNCTION=$(aws dynamodb list-tables | grep cfn-demo-dynamo-BookTable | sed -e 's/^[ \t]*//' | tr -d '"')
FUNCTION=$(aws lambda list-functions | jq -r '.[] | .[] | select(.FunctionName | contains("cfn-demo-dynamo-LambdaFunction")) .FunctionName')

# loop through all books test
jq -c '.[]' data.json | while read -r book; do
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

#TABLE=$(aws dynamodb list-tables | grep cfn-demo-dynamo-BookTable | sed -e 's/^[ \t]*//' | tr -d '"')
TABLE=$(aws dynamodb list-tables | jq -r '.[] | .[] | select(. | contains("cfn"))')

aws dynamodb scan --table-name "$TABLE"
