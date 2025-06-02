import boto3
import csv

# Load logs from CSV
def load_log_messages(file_path):
    messages = []
    with open(file_path, "r") as f:
        reader = csv.DictReader(f)
        for row in reader:
            messages.append(row["message"])
    return "\n".join(messages)

# Format prompt
def build_prompt(log_data):
    return f"""
You are an expert SRE assistant. Analyze the following application logs and provide:

1. A summary of key issues.
2. Count of ERRORs and WARNs.
3. Likely root causes or patterns.
4. Recommended actions (if any).

Logs:
{log_data}
"""

# Call Bedrock Claude model
def ask_bedrock(prompt):
    client = boto3.client("bedrock-runtime", region_name="us-east-1")

    response = client.invoke_model(
        modelId="anthropic.claude-3-sonnet-20240229-v1:0",
        contentType="application/json",
        accept="application/json",
        body=f"""{{
          "prompt": "<<SYS>>\nYou are a helpful AI.\n<</SYS>>\n\n{prompt}\n\nAssistant:",
          "max_tokens": 500,
          "temperature": 0.5,
          "top_k": 250,
          "top_p": 1.0,
          "stop_sequences": ["\\n\\nHuman:"]
        }}"""
    )
    return response["body"].read().decode("utf-8")

# Main flow
if __name__ == "__main__":
    file_path = "sample_athena_result.csv"
    logs = load_log_messages(file_path)
    prompt = build_prompt(logs)
    result = ask_bedrock(prompt)

    print("===== AI Summary from Bedrock (Claude v3) =====\n")
    print(result)
