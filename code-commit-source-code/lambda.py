import boto3
import os

table_name = os.environ['TABLE_NAME']


def lambda_handler(event, context):
    client = boto3.resource('dynamodb')
    table = client.Table(table_name)
    print(table.table_status)
    table.put_item(Item={'EmployeeId': '1', 'Employee': 'Jeff Bezos'})
