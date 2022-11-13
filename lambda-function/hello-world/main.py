import json
import datetime

def lambda_handler(event, context):

    print(f"This funtion was executed at {datetime.datetime.now()}")

    return {"statusCode": 200, "body": json.dumps("Hello from lamda")}
