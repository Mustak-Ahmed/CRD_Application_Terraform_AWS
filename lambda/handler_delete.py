import json
import boto3

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('test-table')
    table.delete_item(
    Key={
        'employee-id':event['queryStringParameters']['employee-id']
     
    })
    return {
        "statusCode": 200,
        "body": "successfully deleted",
        "headers": {
          "content-type": "application/json"
        }
      }