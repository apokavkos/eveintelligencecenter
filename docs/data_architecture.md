# Data Architecture strategy: Cross-DB Analytics

**Goal:** Provide Metabase with joined data from both the live SeAT character database and the EVE Static Data Export (SDE) while adhering to strict separation of concerns (SeAT manages *only* its own database).

## The Approach: Metabase Semantic Layer (Virtual Models)

Because we cannot physically merge the databases into the `seat-docker-mariadb-1` container, and configuring MySQL `FEDERATED` tables across containers can introduce network bottlenecks or read-locks, we will leverage **Metabase's native cross-database joining capability** using "Models" and "Saved Questions".

### System Flow
1. **Source A (Live ESI):** Metabase connects natively to `seat-docker-mariadb-1` (read-only). We write complex SQL to aggregate liquid ISK, extract assets, and grab industry jobs using raw `type_id` integers.
2. **Source B (Static SDE):** Metabase connects natively to `eve-sde` (read-only). We expose the `invTypes` and `mapSolarSystems` tables.
3. **The Bridge (Virtualization):** Inside Metabase, we will save base questions from Source A and Source B. Using Metabase's GUI Query Builder, we orchestrate a `JOIN` bringing the two together over the native application layer.

### Why this is the best judgement:
- **Zero Risk to SeAT:** The `seat` database container is 100% physically and logically isolated from the SDE infrastructure. Updates or schema changes to SeAT will never conflict with SDE data.
- **Easy SDE Upgrades:** Every time CCP releases a new event/expansion, the `eve-sde` container can be completely destroyed and rebuilt with a new SQL dump without taking down the SeAT dashboard or risking character APIs.
- **Portability:** If you migrate away from MariaDB or Hetzner, the logical joins remain intact inside Metabase's application state.

---

## Next Steps for Dashboard Creation

With this architecture defined, we proceed to create two distinct sets of SQL logic that you will ingest into Metabase as "Base Views".

### Part 1: SeAT Base Queries
We will write the raw SQL files that extract the heavily normalized data out of SeAT. For example:
- `seat_liquid_isk.sql`: Grouping wallet balances.
- `seat_industry_jobs.sql`: Normalizing current job queues.

### Part 2: SDE Base Queries
We will create a streamlined view of `invTypes` and Universe data so Metabase doesn't have to cache the entire 3GB MariaDB EVE universe dump.
- `sde_item_definitions.sql`: Extracting just `typeID`, `typeName`, `volume`.

### Part 3: Dashboard Assembly
A guide mapping how to link the Saved Questions together in Metabase to output the clean, human-readable tables (like having actual Ship Names instead of ID `632` for a Catalyst).
