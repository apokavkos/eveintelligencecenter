import os
from mcp.server.fastmcp import FastMCP
import pymysql

mcp = FastMCP("Eve Intelligence MCP")

DB_HOST = os.environ.get("DB_HOST", "seat-docker-mariadb-1")
DB_USER = os.environ.get("DB_USER", "root")
DB_PASSWORD = os.environ.get("DB_PASSWORD", "")

def get_connection(db_name: str):
    return pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=db_name,
        cursorclass=pymysql.cursors.DictCursor
    )

@mcp.tool()
def query_seat_live_database(sql: str) -> str:
    """Execute a read-only SQL query against the SeAT live database containing character assets, wallets, and industry jobs."""
    if not sql.strip().upper().startswith(("SELECT", "SHOW", "DESCRIBE")):
        return "Error: Security constraint. Only SELECT, SHOW, and DESCRIBE queries are allowed."
    try:
        with get_connection("seat") as conn:
            with conn.cursor() as cursor:
                cursor.execute(sql)
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
    if not sql.strip().upper().startswith(("SELECT", "SHOW", "DESCRIBE")):
        return "Error: Security constraint. Only SELECT, SHOW, and DESCRIBE queries are allowed."
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
                cursor.execute(sql)
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
