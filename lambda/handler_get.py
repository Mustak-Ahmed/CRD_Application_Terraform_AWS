import json
import boto3

def lambda_handler(event, context):
    print(event['queryStringParameters']['employee-id'])
    client = boto3.client('dynamodb')
    response = client.get_item(
        TableName='test-table',
        Key={
            'employee-id': {'S':event['queryStringParameters']['employee-id']}
     
        }
    )
    print(response['Item'])
    return {
        "statusCode": 200,
        "body": str(response['Item']),
        "headers": {
          "content-type": "application/json"
        }
    }