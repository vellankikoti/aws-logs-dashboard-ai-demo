import openai
import csv
import os

# Load log messages from CSV
def load_log_messages(file_path):
    messages = []
    with open(file_path, "r") as f:
        reader = csv.DictReader(f)
        for row in reader:
            messages.append(row["message"])
    return "\n".join(messages)

# Build the GPT prompt
def build_prompt(log_data):
    return f"""
You are an expert DevOps assistant.

Analyze the following application logs and provide:
1. A summary of the issues.
2. Count of ERRORs and WARNs.
3. Any patterns or recurring problems.
4. Suggested root causes and actions.

Logs:
{log_data}
"""

# Call OpenAI GPT
def ask_openai(prompt):
    openai.api_key = os.getenv("OPENAI_API_KEY")  # set this in env or manually

    response = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[
            {"role": "system", "content": "You are a helpful assistant for DevOps log analysis."},
            {"role": "user", "content": prompt}
        ],
        temperature=0.4,
        max_tokens=500
    )
    return response["choices"][0]["message"]["content"]

# Main flow
if __name__ == "__main__":
    file_path = "sample_athena_result.csv"
    logs = load_log_messages(file_path)
    prompt = build_prompt(logs)
    result = ask_openai(prompt)

    print("===== AI Summary from OpenAI (GPT-4) =====\n")
    print(result)
