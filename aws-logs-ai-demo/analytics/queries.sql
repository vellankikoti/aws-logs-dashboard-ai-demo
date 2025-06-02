-- 🔍 List all log entries
SELECT * FROM cloudwatch_logs LIMIT 20;

-- 🔥 Find all error messages
SELECT *
FROM cloudwatch_logs
WHERE LOWER(message) LIKE '%error%';

-- 📊 Count of log types
SELECT
  CASE
    WHEN message LIKE '%ERROR%' THEN 'ERROR'
    WHEN message LIKE '%WARN%' THEN 'WARN'
    WHEN message LIKE '%INFO%' THEN 'INFO'
    ELSE 'OTHER'
  END AS log_level,
  COUNT(*) AS count
FROM cloudwatch_logs
GROUP BY log_level;

-- ⏱️ Latest log message
SELECT *
FROM cloudwatch_logs
ORDER BY message DESC
LIMIT 1;
