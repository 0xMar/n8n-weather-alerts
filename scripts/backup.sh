#!/bin/bash
# backup-workflows.sh
# Usage: ./backup.sh [--dry-run]
# Run from the project root: ./scripts/backup.sh

DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
fi

BACKUP_DIR="./n8n-data/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$BACKUP_DIR"

if [ "$DRY_RUN" = true ]; then
  echo "🔍 Dry-run mode - no changes will be made"
  echo ""
  echo "Would perform:"
  echo "  - Copy database to: $BACKUP_DIR/database-$TIMESTAMP.sqlite"
  echo "  - Cleanup: remove backups older than 7 days"
  echo ""
  echo "Current backups:"
  ls -la "$BACKUP_DIR" 2>/dev/null || echo "  (none)"
  exit 0
fi

# Backup SQLite database
docker exec n8n-selfhosted-n8n-1 sh -c "cp /home/node/.n8n/database.sqlite /tmp/backup-$TIMESTAMP.sqlite"
docker cp "n8n-selfhosted-n8n-1:/tmp/backup-$TIMESTAMP.sqlite" "$BACKUP_DIR/database-$TIMESTAMP.sqlite"
docker exec n8n-selfhosted-n8n-1 sh -c "rm /tmp/backup-$TIMESTAMP.sqlite"

echo "✅ Backup created: $BACKUP_DIR/database-$TIMESTAMP.sqlite"

# Cleanup old backups (keep last 7)
cd "$BACKUP_DIR"
ls -t database-*.sqlite | tail -n +8 | xargs -r rm

echo "📦 Kept last 7 backups"