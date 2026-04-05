import os
import re
from mcp.server.fastmcp import FastMCP
import pymysql

mcp = FastMCP("Eve Intelligence MCP")

DB_HOST = os.environ.get("DB_HOST", "seat-docker-mariadb-1")
DB_USER = os.environ.get("DB_USER", "seat_readonly")
DB_PASSWORD = os.environ.get("DB_PASSWORD", "")
MAX_ROWS = int(os.environ.get("MCP_MAX_ROWS", "500"))

READ_ONLY_PREFIXES = ("SELECT", "SHOW", "DESCRIBE", "EXPLAIN")


def normalize_query(sql: str) -> tuple[bool, str]:
    query = sql.strip()
    if not query:
        return False, "Error: Empty query provided."

    # Allow one optional trailing semicolon, but block stacked statements.
    if ";" in query[:-1]:
        return False, "Error: Multiple SQL statements are not allowed."

    upper_query = query.upper()
    if not upper_query.startswith(READ_ONLY_PREFIXES):
        return False, "Error: Security constraint. Only SELECT, SHOW, DESCRIBE, and EXPLAIN queries are allowed."

    # Add a default limit to SELECT statements to protect the DB from accidental full scans.
    if upper_query.startswith("SELECT") and "LIMIT" not in upper_query:
        query = re.sub(r";\s*$", "", query)
        query = f"{query} LIMIT {MAX_ROWS}"

    return True, query

def get_connection(db_name: str):
    return pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=db_name,
        connect_timeout=5,
        read_timeout=30,
        write_timeout=30,
        cursorclass=pymysql.cursors.DictCursor
    )

@mcp.tool()
def query_seat_live_database(sql: str) -> str:
    """Execute a read-only SQL query against the SeAT live database containing character assets, wallets, and industry jobs."""
    is_valid, parsed = normalize_query(sql)
    if not is_valid:
        return parsed
    try:
        with get_connection("seat") as conn:
            with conn.cursor() as cursor:
                cursor.execute(parsed)
                rows = cursor.fetchall()
                if not rows:
                    return "No results found."
                # Format mildly to avoid massive string buffers
                return str(rows)
    except Exception as e:
        return f"Database Error: {e}"

@mcp.tool()
def query_sde_static_database(sql: str) -> str:
    """Execute a read-only SQL query against the EVE SDE static database containing item type names, map logic, etc."""
    is_valid, parsed = normalize_query(sql)
    if not is_valid:
        return parsed
    try:
        # SDE is on another container, so we use its host. 
        sde_conn = pymysql.connect(
            host="eve-sde",
            user="root",
            password="",  # User specified blank password for SDE
            database="sde",
            cursorclass=pymysql.cursors.DictCursor
        )
        with sde_conn:
            with sde_conn.cursor() as cursor:
                cursor.execute(parsed)
                rows = cursor.fetchall()
                if not rows:
                    return "No results found."
                return str(rows)
    except Exception as e:
        return f"Database Error: {e}"

if __name__ == "__main__":
    # In SSE mode, fastmcp run is preferred, but for a raw script execution:
    mcp.settings.host = "0.0.0.0"
    mcp.settings.port = 8000
    mcp.run(transport='sse')
