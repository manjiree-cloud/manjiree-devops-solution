import json
import requests
import os

def lambda_handler(event, context):
   
    subnet_id = os.environ['SUBNET_ID']
    name = os.environ['NAME']
    email = os.environ['EMAIL']
    
    payload = {
       "subnet_id": subnet_id,
        "name": name,
        "email": email
    }
    
    headers = {'X-Siemens-Auth': 'test'}
    response = requests.post("https://bc1yy8dzsg.execute-api.eu-west-1.amazonaws.com/v1/data",json=payload , headers=headers)
    
    print(f" Response: {response.status_code}")
    print(f"Response Body: {response.text}")
    
    return {
        'statusCode': 200,
        'body': json.dumps('API called successfully!')
    }
