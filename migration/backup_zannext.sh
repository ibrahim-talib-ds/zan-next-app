#!/bin/bash
# ZanNext Postgres backup script
# Runs daily via cron. Keeps 30 days of backups.
# Logs to ~/Backups/zannext/backup.log

set -e

BACKUP_DIR="$HOME/Backups/zannext"
LOG_FILE="$BACKUP_DIR/backup.log"
DATE=$(date +%Y-%m-%d)
DUMP_FILE="$BACKUP_DIR/zannext_${DATE}.dump"
RETENTION_DAYS=30

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Log header
{
  echo "=========================================="
  echo "Backup started: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "Target: $DUMP_FILE"
} >> "$LOG_FILE"

# Load Postgres environment (adds pg_dump 17.6 to PATH)
if [ -f "$HOME/Databases/postgresql-build/pg_env.sh" ]; then
  # shellcheck disable=SC1090
  source "$HOME/Databases/postgresql-build/pg_env.sh" > /dev/null 2>&1
fi

# Run the dump
if PGPASSWORD=1542004ibrahim pg_dump \
    -U ibrahim \
    -h localhost \
    -d zannext \
    -F c \
    -f "$DUMP_FILE" 2>> "$LOG_FILE"; then

  SIZE=$(du -h "$DUMP_FILE" | cut -f1)
  echo "Backup OK — size: $SIZE" >> "$LOG_FILE"

  # Prune old backups
  DELETED=$(find "$BACKUP_DIR" -name "zannext_*.dump" -type f -mtime +$RETENTION_DAYS -print -delete | wc -l)
  echo "Pruned $DELETED backup(s) older than $RETENTION_DAYS days" >> "$LOG_FILE"

  # Show current backups
  echo "Current backups:" >> "$LOG_FILE"
  ls -lh "$BACKUP_DIR"/zannext_*.dump 2>/dev/null | awk '{print "  " $9 " (" $5 ")"}' >> "$LOG_FILE"
else
  echo "Backup FAILED — see errors above" >> "$LOG_FILE"
  exit 1
fi

echo "Backup finished: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
