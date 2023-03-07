import json
import boto3


def lambda_handler(event, context):
    print(event['body'])
    temp = json.loads(event['body'])
    client = boto3.resource('dynamodb')
    table = client.Table('test-table')
   
    table.put_item(Item=temp)
    return {
        "statusCode": 200,
        "body": "successfully inserted",
        "headers": {
          "content-type": "application/json"
        }
      }