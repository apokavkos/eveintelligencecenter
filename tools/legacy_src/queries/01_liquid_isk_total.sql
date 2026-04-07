-- 01_liquid_isk_total.sql
-- Database: seat-docker-mariadb-1 (SeAT)
-- Purpose: Calculate the total liquid ISK across all authenticated characters
-- Usage in Metabase: Set as a "Number" visualization

SELECT
  SUM(cw.balance) AS total_liquid_isk
FROM
  character_wallets cw
JOIN
  users u ON u.id = cw.character_id; 
  -- Note: SeAT schema may link to `character_infos` or `users`. 
  -- Generally, we sum all balances in `character_wallets`.

-- Alternative if character_wallets contains multiple divisions per char:
-- SELECT SUM(balance) AS total_liquid_isk FROM character_wallets WHERE division_id = 1;
