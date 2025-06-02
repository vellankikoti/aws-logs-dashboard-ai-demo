### 📝 Title: **Setting Up Lambda to Simulate Logs in CloudWatch**

---

### ✅ Step 1: Create the Lambda Function

1. Go to [AWS Lambda Console](https://console.aws.amazon.com/lambda/)
2. Click **Create function**
3. Choose:

   * **Author from scratch**
   * **Function name**: `LogSimulatorFunction`
   * **Runtime**: `Python 3.11`
   * **Execution role**:

     * Choose **Create a new role with basic Lambda permissions**
4. Click **Create function**

---

### ✅ Step 2: Add the Log Simulator Code

1. In the Lambda editor, open the file: `lambda_function.py`
2. Replace the content with the following:

```python
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
```

3. Click **Deploy**

---

### ✅ Step 3: Add Permissions to the Lambda Role

Go to:

1. **IAM → Roles**
2. Find the Lambda’s IAM Role (e.g., `LogSimulatorFunction-role-xxxxx`)
3. Click **Add Permissions → Create inline policy**
4. Choose **JSON** tab and paste:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": "*"
    }
  ]
}
```

5. Click **Review policy**
6. Name: `AllowCloudWatchLogging`
7. Click **Create policy**

---

### ✅ Step 4: Test the Lambda Function

1. Back in the Lambda function page
2. Click **Test**
3. Configure a test event (any dummy JSON, e.g. `{}`)
4. Run the test

✅ You should see a success message.

---

### ✅ Step 5: Verify Logs in CloudWatch

1. Go to **CloudWatch → Log groups**
2. Click `/aws/logs-ai-demo/app-logs`
3. Open the latest log stream (e.g., `lambda-stream-...`)
4. You’ll see 10 log entries with mixed INFO/WARN/ERROR messages

---

✅ Now you can take a screenshot of this and save it to:

```
docs/screens/cloudwatch-log-stream.png
```

---
