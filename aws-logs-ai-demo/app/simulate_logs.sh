#!/bin/bash
# ------------------------------------------
# simulate_logs.sh
# Description: Simulates log messages and pushes them to AWS CloudWatch Logs
# Dependencies: AWS CLI v2, configured profile with access to CloudWatch Logs
# ------------------------------------------

# ===== Configuration =====
LOG_GROUP_NAME="/aws/demo/logs"
LOG_STREAM_NAME="cli-log-stream"
AWS_REGION="us-east-1"
PROFILE="default"

# ===== Create log group and stream if not exist =====
echo "[INFO] Ensuring log group and stream exist..."
aws logs create-log-group \
  --log-group-name "$LOG_GROUP_NAME" \
  --region "$AWS_REGION" \
  --profile "$PROFILE" 2>/dev/null

aws logs create-log-stream \
  --log-group-name "$LOG_GROUP_NAME" \
  --log-stream-name "$LOG_STREAM_NAME" \
  --region "$AWS_REGION" \
  --profile "$PROFILE" 2>/dev/null

# ===== Get the next sequence token =====
SEQUENCE_TOKEN=$(aws logs describe-log-streams \
  --log-group-name "$LOG_GROUP_NAME" \
  --log-stream-name "$LOG_STREAM_NAME" \
  --query 'logStreams[0].uploadSequenceToken' \
  --output text \
  --region "$AWS_REGION" \
  --profile "$PROFILE")

# ===== Simulated log lines =====
LOG_LINES=(
  "INFO: Service started successfully"
  "ERROR: Failed to connect to database"
  "WARN: Memory usage at 85%"
  "INFO: Request handled in 123ms"
  "ERROR: Timeout while reaching external API"
)

# ===== Format log events =====
TIMESTAMP=$(($(date +%s%N)/1000000))
LOG_EVENTS="["
for i in ${!LOG_LINES[@]}; do
  LOG_EVENTS+="{\"timestamp\":$((TIMESTAMP + i * 1000)),\"message\":\"${LOG_LINES[$i]}\"}"
  [[ $i -lt $((${#LOG_LINES[@]} - 1)) ]] && LOG_EVENTS+="," || LOG_EVENTS+="]"
done

# ===== Push logs to CloudWatch =====
echo "[INFO] Sending logs to CloudWatch..."
SEND_CMD=(aws logs put-log-events \
  --log-group-name "$LOG_GROUP_NAME" \
  --log-stream-name "$LOG_STREAM_NAME" \
  --log-events "$LOG_EVENTS" \
  --region "$AWS_REGION" \
  --profile "$PROFILE")

# Add sequence token if available
if [[ "$SEQUENCE_TOKEN" != "None" ]]; then
  SEND_CMD+=(--sequence-token "$SEQUENCE_TOKEN")
fi

"${SEND_CMD[@]}"

echo "[SUCCESS] Logs pushed to CloudWatch in group: $LOG_GROUP_NAME, stream: $LOG_STREAM_NAME"
