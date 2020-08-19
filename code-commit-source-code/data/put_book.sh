# get new function name
FUNCTION=$(aws lambda list-functions | jq -r '.[] | .[] | select(.FunctionName | contains("cfn-demo-dynamo-LambdaFunction")) .FunctionName')

# loop through all books
jq -c '.[]' data.json | while read book; do
  echo $book
  aws lambda invoke \
    --function-name $FUNCTION \
    --payload $book \
    --invocation-type Event \
    --cli-binary-format raw-in-base64-out \
    output.log
done

# alternately, just a single book
aws lambda invoke \
  --function-name $FUNCTION \
  --payload "$(cat book.json)" \
  --cli-binary-format raw-in-base64-out \
  output.log
