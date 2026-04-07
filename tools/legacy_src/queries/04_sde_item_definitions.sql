-- 04_sde_item_definitions.sql
-- Database: eve-sde (SDE)
-- Purpose: Streamlined export of item data from the SDE to reduce Metabase memory overhead.
--          This serves as "Source B" for the Metabase cross-database link.

SELECT
  typeID,
  typeName,
  volume
FROM
  invTypes
WHERE
  published = 1;
