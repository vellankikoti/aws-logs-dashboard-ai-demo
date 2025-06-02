CREATE EXTERNAL TABLE IF NOT EXISTS cloudwatch_logs (
  message string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = '1'
)
LOCATION 's3://your-s3-bucket/path-to-exported-logs/'
TBLPROPERTIES ('has_encrypted_data'='false');
