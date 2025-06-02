New-Item -ItemType Directory -Name "aws-logs-ai-demo"
Set-Location "aws-logs-ai-demo"

# Create subfolders
"app","infra","analytics","ai-summary","docs","slides" | ForEach-Object {
    New-Item -ItemType Directory -Name $_
}

# Root files
New-Item -Name "README.md" -ItemType File
New-Item -Name ".gitignore" -ItemType File

# App
New-Item -Path "app/simulate_logs.sh" -ItemType File

# Infra
New-Item -Path "infra/iam_roles.json" -ItemType File

# Analytics
"athena_schema.sql","sample_logs.csv","queries.sql","dashboard.png" | ForEach-Object {
    New-Item -Path "analytics/$_" -ItemType File
}

# AI Summary
"summary_bedrock.py","summary_openai.py","sample_athena_result.csv","ai_output.txt" | ForEach-Object {
    New-Item -Path "ai-summary/$_" -ItemType File
}

# Docs
"export_logs_to_s3.md","setup_athena.md","quicksight_dashboard.md" | ForEach-Object {
    New-Item -Path "docs/$_" -ItemType File
}

# Slides
"talk_script.md","slides.pdf" | ForEach-Object {
    New-Item -Path "slides/$_" -ItemType File
}
