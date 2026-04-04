-- 02_rich_list.sql
-- Database: seat-docker-mariadb-1 (SeAT)
-- Purpose: Generates a leaderboard of characters by their liquid ISK.
-- Usage in Metabase: Set as a "Table" or "Bar Chart" visualization

SELECT
  ci.name AS character_name,
  cw.balance AS liquid_isk
FROM
  character_wallets cw
JOIN
  character_infos ci ON cw.character_id = ci.character_id
ORDER BY
  cw.balance DESC;
