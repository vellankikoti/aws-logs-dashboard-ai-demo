# 📤 Export CloudWatch Logs to S3

1. Go to **CloudWatch > Log Groups** in AWS Console.
2. Click your log group: `/aws/logs-ai-demo/app-logs`.
3. Click **Actions → Export data to Amazon S3**.
4. Choose/create an S3 bucket.
5. Select time range → click **Export**.
6. The logs will appear in S3 as `.gz` files in folders like:
AWSLogs/{account-id}/CloudWatchLogs/region/year/month/day/

You can now query these with Athena.
