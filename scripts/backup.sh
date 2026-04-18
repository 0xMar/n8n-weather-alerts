#!/bin/bash
# backup-workflows.sh
# Usage: ./backup.sh [--dry-run]
# Run from the project root: ./scripts/backup.sh

set -e

DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
fi

BACKUP_DIR="./n8n-data/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Resolve container name dynamically (works regardless of project name)
cd "$PROJECT_ROOT"
CONTAINER_ID=$(docker compose ps -q n8n 2>/dev/null || true)

if [ -z "$CONTAINER_ID" ]; then
    echo "❌ Error: n8n container not found. Is it running?"
    echo "   Try: docker compose up -d"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

if [ "$DRY_RUN" = true ]; then
    echo "🔍 Dry-run mode - no changes will be made"
    echo ""
    echo "Container: $CONTAINER_ID"
    echo "Would perform:"
    echo " - Copy database to: $BACKUP_DIR/database-$TIMESTAMP.sqlite"
    echo " - Cleanup: remove backups older than 7 days"
    echo ""
    echo "Current backups:"
    ls -la "$BACKUP_DIR" 2>/dev/null || echo " (none)"
    exit 0
fi

# Backup SQLite database
docker exec "$CONTAINER_ID" sh -c "cp /home/node/.n8n/database.sqlite /tmp/backup-$TIMESTAMP.sqlite"
docker cp "$CONTAINER_ID:/tmp/backup-$TIMESTAMP.sqlite" "$BACKUP_DIR/database-$TIMESTAMP.sqlite"
docker exec "$CONTAINER_ID" sh -c "rm /tmp/backup-$TIMESTAMP.sqlite"

echo "✅ Backup created: $BACKUP_DIR/database-$TIMESTAMP.sqlite"

# Cleanup old backups (keep last 7)
cd "$BACKUP_DIR"
ls -t database-*.sqlite 2>/dev/null | tail -n +8 | xargs -r rm || true

echo "📦 Kept last 7 backups"