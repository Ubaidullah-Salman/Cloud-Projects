import json
import boto3
import uuid
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('FormSubmissions')

def lambda_handler(event, context):
    try:
        body = json.loads(event['body'])
        
        item = {
            'id': str(uuid.uuid4()),
            'name': body.get('name', ''),
            'email': body.get('email', ''),
            'message': body.get('message', ''),
            'timestamp': datetime.utcnow().isoformat()
        }
        
        table.put_item(Item=item)
        
        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type',
            },
            'body': json.dumps({'message': 'Form submitted successfully!'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
