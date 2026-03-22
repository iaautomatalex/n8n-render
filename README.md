# OpenClaw — Deploy on Render + Supabase

Bot IA personnel propulsé par **Gemini 2.0 Flash** (gratuit), hébergé sur **Render** avec **Supabase** comme base de données.

---

## Structure du dépôt

```
├── render.yaml        # Config déploiement Render (Infrastructure as Code)
├── Dockerfile         # Image Docker basée sur alpine/openclaw
├── entrypoint.sh      # Injecte les env vars dans clawdbot.json au démarrage
└── README.md
```

---

## Déploiement rapide

### 1. Supabase — créer le projet

1. Aller sur [supabase.com](https://supabase.com) → **New project**
2. Récupérer dans **Settings → API** :
   - `SUPABASE_URL` → `https://xxxx.supabase.co`
   - `SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY`
3. Récupérer dans **Settings → Database** :
   - `DATABASE_URL` → `postgresql://postgres:[password]@db.[ref].supabase.co:5432/postgres`

### 2. Google AI Studio — clé gratuite

1. Aller sur [aistudio.google.com/apikey](https://aistudio.google.com/apikey)
2. **Create API Key** → copier la clé `AIza...`

### 3. Render — déployer

1. Fork ce dépôt sur votre GitHub
2. Sur [render.com](https://render.com) → **New** → **Blueprint**
3. Connecter votre repo → Render lit `render.yaml` automatiquement
4. Dans le dashboard → service `openclaw` → **Environment** → remplir :
   - `GOOGLE_API_KEY` → votre clé `AIza...`
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY`
   - `DATABASE_URL`
5. **Deploy** → attendre ~2 min

### 4. Accéder à OpenClaw

URL générée par Render : `https://openclaw-xxxx.onrender.com`

Le token de connexion se trouve dans **Environment → CLAWDBOT_GATEWAY_TOKEN** (généré automatiquement).

URL tokenisée :
```
https://openclaw-xxxx.onrender.com/?token=VOTRE_TOKEN
```

---

## Variables d'environnement

| Variable | Description | Requis |
|---|---|---|
| `CLAWDBOT_GATEWAY_TOKEN` | Token d'accès à l'UI (auto-généré) | ✅ auto |
| `GOOGLE_API_KEY` | Clé Google AI Studio (Gemini) | ✅ |
| `SUPABASE_URL` | URL du projet Supabase | ✅ |
| `SUPABASE_ANON_KEY` | Clé publique Supabase | ✅ |
| `SUPABASE_SERVICE_ROLE_KEY` | Clé privée Supabase | ✅ |
| `DATABASE_URL` | URL PostgreSQL Supabase | ✅ |
| `TELEGRAM_BOT_TOKEN` | Token bot Telegram | ⬜ optionnel |
| `DISCORD_BOT_TOKEN` | Token bot Discord | ⬜ optionnel |

---

## Changer de modèle

Modifier dans `entrypoint.sh` la ligne :
```json
"id": "gemini-2.0-flash"
```
Modèles gratuits disponibles :
- `gemini-2.0-flash` — rapide, recommandé
- `gemini-2.5-flash-preview-05-20` — plus puissant
- `gemini-1.5-flash` — stable
- `gemini-2.0-flash-lite` — ultra léger

---

## Limitations Render plan gratuit

- Le service **s'endort** après 15 min d'inactivité (cold start ~30s)
- Pas de disque persistant → la config est régénérée depuis les env vars à chaque démarrage (géré par `entrypoint.sh`)
- 750h gratuites/mois
