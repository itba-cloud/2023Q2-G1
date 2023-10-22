import json

def lambda_handler(event, context):
    return {
        'statusCode' : 200,
        'body': json.dumps('putExpenses: Hello from Lambda!')
    }