#!/bin/sh
set -e

CONFIG_DIR="/home/clawdbot/.clawdbot"
CONFIG_FILE="$CONFIG_DIR/clawdbot.json"

mkdir -p "$CONFIG_DIR"
mkdir -p "/home/clawdbot/workspace"

# Écrire le fichier de config en injectant les variables d'environnement
cat > "$CONFIG_FILE" <<EOF
{
  "models": {
    "mode": "merge",
    "providers": {
      "google": {
        "baseUrl": "https://generativelanguage.googleapis.com/v1beta/openai",
        "apiKey": "${GOOGLE_API_KEY}",
        "auth": "api-key",
        "api": "openai-completions",
        "models": [
          {
            "id": "gemini-2.0-flash",
            "name": "Gemini (gemini-2.0-flash)",
            "reasoning": false,
            "input": ["text"],
            "cost": { "input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0 },
            "contextWindow": 1000000,
            "maxTokens": 8192
          }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": { "primary": "gemini" },
      "models": {
        "google/gemini-2.0-flash": { "alias": "gemini" }
      },
      "compaction": { "mode": "safeguard" },
      "workspace": "/home/clawdbot/workspace",
      "maxConcurrent": 4,
      "subagents": { "maxConcurrent": 8 }
    }
  },
  "messages": { "ackReactionScope": "group-mentions" },
  "commands": {
    "native": "auto",
    "nativeSkills": "auto",
    "restart": false
  },
  "gateway": {
    "controlUi": { "enabled": true, "allowInsecureAuth": true },
    "auth": {
      "mode": "token",
      "token": "${CLAWDBOT_GATEWAY_TOKEN}"
    }
  },
  "plugins": {
    "entries": {
      "telegram": {
        "enabled": false,
        "token": "${TELEGRAM_BOT_TOKEN}"
      }
    }
  },
  "supabase": {
    "url": "${SUPABASE_URL}",
    "anonKey": "${SUPABASE_ANON_KEY}",
    "serviceRoleKey": "${SUPABASE_SERVICE_ROLE_KEY}",
    "databaseUrl": "${DATABASE_URL}"
  }
}
EOF

echo "[entrypoint] Config écrite dans $CONFIG_FILE"
echo "[entrypoint] Modèle : gemini-2.0-flash"
echo "[entrypoint] Supabase URL : ${SUPABASE_URL}"

# Démarrer Clawdbot
exec clawdbot
