# 🎯 Set Up Athena for Log Queries

1. Go to **Athena** → "Query Editor".
2. Choose or create a workgroup.
3. Set output location (e.g., `s3://your-athena-results-bucket/`) in "Settings".
4. Run the schema from `analytics/athena_schema.sql`, replacing the S3 path.
5. Use `queries.sql` to analyze logs:
   - Find errors
   - Count warnings
   - Generate visualizations
