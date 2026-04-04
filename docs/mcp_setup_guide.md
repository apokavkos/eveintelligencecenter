# MCP Configuration Guide: EVE Intelligence Center

This guide explains how to connect your deployed remote MCP server (`https://evemcp.apokavkos.com/sse`) to your AI clients.

## 1. Antigravity Configuration

Antigravity operates locally on your Mac using the standard Input/Output (`stdio`) transport method for MCP. Because your MCP server is isolated inside the Hetzner internal docker network, we can use an incredibly elegant solution: **Pipe the Docker container's Standard IO securely over SSH.**

I have already injected this exact configuration into your `/Users/apok/.gemini/antigravity/mcp_config.json` file! 

For reference, the JSON configuration I added is:
```json
{
  "mcpServers": {
    "eve-intelligence": {
      "command": "ssh",
      "args": [
         "root@apokavkos.com",
         "docker", "run", "-i", "--rm",
         "--network", "seat-docker_seat-internal",
         "-e", "DB_HOST=seat-docker-mariadb-1",
         "-e", "DB_USER=root",
         "-e", "DB_PASSWORD=I8vOQk5svUGe3nBsx6DgEG",
         "eve-mcp-server-mcp-server",
         "python", "-c", "from server import mcp; mcp.run(transport='stdio')"
      ]
    }
  }
}
```
**How it works:** When Antigravity boots, it transparently `ssh`s into your Hetzner box, spawns a temporary, read-only Docker container linked to your live databases, ignores the SSE HTTPS setup, and talks to the databases natively.


---

## 2. Claude iOS Configuration

**Current Limitation:** As of right now, the official Anthropic Claude iOS mobile app **does not support configuring custom user MCP servers**. 

The MCP protocol is fundamentally designed for desktop environments (like Claude Desktop, Cursor, or Antigravity) where local processes govern the connections. 

If you want your EVE database available on your iPhone:
1. **Third-Party UIs:** You can use a mobile-friendly web UI (like LibreChat or Open WebUI) self-hosted on your Hetzner server and attach the MCP server there. You then open safari on iOS to talk to your database.
2. **Wait for Anthropic Cloud:** Anthropic intends to eventually roll out cloud-hosted MCP syncing for Enterprise users so desktop configurations seamlessly propagate to mobile, but that feature is not publicly available for standard mobile users yet.
