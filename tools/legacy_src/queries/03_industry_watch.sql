-- 03_industry_watch.sql
-- Database: seat-docker-mariadb-1 (SeAT)
-- Purpose: Monitor active and ready industry jobs. 
--          This serves as "Source A" for the Metabase cross-database link.

SELECT
  ci.name AS installer_name,
  ij.activity_id, -- 1=Manufacturing, 3=TE, 4=ME, 5=Copying, 8=Invention. (Can map via custom Metabase column or let SDE handle it if ramActivities is added)
  ij.status,
  ij.start_date,
  ij.end_date,
  ij.runs,
  ij.product_type_id AS output_type_id
FROM
  character_industry_jobs ij
JOIN
  character_infos ci ON ij.installer_id = ci.character_id
WHERE
  ij.status IN ('active', 'ready')
ORDER BY
  ij.end_date ASC;
