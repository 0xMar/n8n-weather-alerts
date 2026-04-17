# n8n Self-Hosted

![n8n version](https://img.shields.io/badge/n8n-2.16.1-blue)
![Docker](https://img.shields.io/badge/Docker-latest-blue)
![License](https://img.shields.io/badge/License-MIT-green)

n8n automation running locally with Docker. Includes a weather alert workflow as example.

## What's included

- **n8n Docker setup** — SQLite database, Basic Auth, customizable environment
- **Example workflow** — Automated weather alerts that notify via Telegram when conditions are met
- **Backup script** — Database backup with rotation (keeps last 7)
- **Configuration** — Environment variables ready to customize

## Requirements

- Docker
- Docker Compose

## Setup

```bash
cp .env.example .env
# Edit .env with your values
docker compose up -d
```

n8n will be available at `http://localhost:5678`.

## Configuration

| Variable | Description |
|---|---|
| `N8N_ENCRYPTION_KEY` | Random string used to encrypt credentials |
| `N8N_BASIC_AUTH_USER` | Username for the n8n UI |
| `N8N_BASIC_AUTH_PASSWORD` | Password for the n8n UI |
| `GENERIC_TIMEZONE` | Timezone for schedule nodes (e.g. America/Buenos_Aires) |
| `TZ` | System timezone |

Generate a secure encryption key:
```bash
openssl rand -base64 32
```

## Workflows

Exported workflows live in the `workflows/` folder. To import one, go to n8n → Workflows → Import from file.

## Data persistence

n8n data (SQLite database, credentials) is stored in `./n8n-data/` — excluded from git via `.gitignore`.

## Backup

Run the backup script to create a snapshot of your database:

```bash
chmod +x scripts/backup.sh
./scripts/backup.sh
```

Or preview what would happen without making changes:

```bash
./scripts/backup.sh --dry-run
```

Backups are saved in `n8n-data/backups/` and the last 7 are kept.

## Update

To update n8n to the latest version:

```bash
docker compose pull
docker compose up -d
```