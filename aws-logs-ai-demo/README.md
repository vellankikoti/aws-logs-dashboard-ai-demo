# 📊 AWS Logs Dashboard + AI Summary Demo

A real-time analytics and AI-powered insights demo built entirely with **AWS-native tools**, plus optional GPT integration.  
Designed for a 25-minute AWS Meetup talk — beginner-friendly, highly practical, and includes a surprise AI twist. 💡

---

## 🚀 What This Demo Does

1. ✅ Simulates application logs (bash script)
2. ✅ Sends logs to **CloudWatch Logs**
3. ✅ Exports logs to **S3**
4. ✅ Queries logs using **Athena**
5. ✅ Visualizes in **QuickSight**
6. ✅ Feeds results into **Claude (AWS Bedrock)** or **OpenAI** for natural-language insights

---

## 🗂️ Project Structure

```
aws-logs-ai-demo/
├── app/                 # Log generation script
├── analytics/           # Athena schema, queries, dashboard sample
├── ai-summary/          # Bedrock and OpenAI scripts
├── docs/                # Step-by-step guides (export, Athena, QuickSight)
├── infra/               # IAM/permissions JSON (optional)
├── slides/              # Optional talk script and deck
└── README.md
```

---

## ⚙️ How to Run the Demo

### 🔹 Step 1: Simulate Logs
```bash
cd app
./simulate_logs.sh
```

### 🔹 Step 2: Export Logs to S3
Follow `docs/export_logs_to_s3.md`

### 🔹 Step 3: Set Up Athena
Use:
- `analytics/athena_schema.sql` to create the table
- `analytics/queries.sql` to analyze

### 🔹 Step 4: Build QuickSight Dashboard
Use `docs/quicksight_dashboard.md` for guidance

---

## 🤖 AI Summary (Optional Surprise Twist)

### Option A: Using AWS Bedrock
```bash
cd ai-summary
python summary_bedrock.py
```

Requires:
- Bedrock access in your region
- Boto3 configured (`aws configure`)

### Option B: Using OpenAI (Fallback)
```bash
export OPENAI_API_KEY=your-api-key
python summary_openai.py
```

---

## 🎤 Talk Flow (Suggested)

1. Intro: "Logs are everywhere, but insights aren't"
2. Show Logs → Athena → Dashboard
3. Twist: "Let’s ask the logs what went wrong..."
4. AI shows root cause summary
5. Outro: Simple, powerful, production-ready

---

## ✅ Prerequisites

- AWS account with:
  - CloudWatch Logs
  - S3
  - Athena
  - QuickSight
  - (Optional) Bedrock access in `us-east-1`
- AWS CLI (`aws configure`)
- Python 3.8+ with `boto3`, `openai` if using AI scripts

---

## 🧠 Who Should Use This?

- DevOps engineers
- SREs
- Beginner AWS users
- Meetup/demo/podcast/talk audiences

---

## 📎 License

MIT — use it for your talks, your team, or your customers. No strings attached.

---