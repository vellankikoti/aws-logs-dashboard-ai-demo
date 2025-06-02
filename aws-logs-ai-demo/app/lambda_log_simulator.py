import json
import time
import boto3
import random

LOG_GROUP_NAME = "/aws/logs-ai-demo/app-logs"
REGION = "us-east-1"
LOG_STREAM_NAME = f"lambda-stream-{int(time.time())}"

logs_client = boto3.client("logs", region_name=REGION)

def create_log_stream():
    try:
        logs_client.create_log_group(logGroupName=LOG_GROUP_NAME)
    except logs_client.exceptions.ResourceAlreadyExistsException:
        pass

    logs_client.create_log_stream(
        logGroupName=LOG_GROUP_NAME,
        logStreamName=LOG_STREAM_NAME
    )

def lambda_handler(event, context):
    create_log_stream()

    log_types = ["INFO", "WARN", "ERROR"]
    messages = [
        "User login successful",
        "Database connection failed",
        "Memory usage high",
        "Order processed",
        "Payment gateway timeout",
        "Health check passed",
        "Slow response on /api/orders",
        "New user registered"
    ]

    sequence_token = None
    for _ in range(10):
        log_level = random.choice(log_types)
        message = f"{log_level}: {random.choice(messages)}"
        timestamp = int(time.time() * 1000)

        log_event = {
            'logGroupName': LOG_GROUP_NAME,
            'logStreamName': LOG_STREAM_NAME,
            'logEvents': [{
                'timestamp': timestamp,
                'message': message
            }]
        }

        if sequence_token:
            log_event['sequenceToken'] = sequence_token

        response = logs_client.put_log_events(**log_event)
        sequence_token = response['nextSequenceToken']
        time.sleep(1)

    return {
        'statusCode': 200,
        'body': json.dumps('Logs sent successfully via Lambda!')
    }
