import boto3
import os

table_name = os.environ['TABLE_NAME']


def lambda_handler(event, context):
    client = boto3.resource('dynamodb')
    table = client.Table(table_name)
    book = {
        'AuthorName': event['AuthorName'],
        'BookTitle': event['BookTitle'],
        'PublishedPublished': event['PublishedPublished'],
        'OriginalLanguage': event['OriginalLanguage'],
        'ApproximateSales': event['ApproximateSales']
    }
    table.put_item(Item=book)
