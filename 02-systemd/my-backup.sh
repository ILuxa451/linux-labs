#!/bin/bash
set -euo pipefail

BACKUP_DIR="/backup"
DATA_DIR="/home/important-data"
LOG_FILE="/var/log/my-backup.log"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
ARCHIVE="${BACKUP_DIR}/backup-${TIMESTAMP}.tar.gz"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

# Проверки
if [ ! -d "$BACKUP_DIR" ]; then
    log "ERROR: $BACKUP_DIR does not exist"
    exit 1
fi

if [ ! -d "$DATA_DIR" ]; then
    log "ERROR: $DATA_DIR does not exist"
    exit 1
fi

# Создание архива
if tar -czf "$ARCHIVE" "$DATA_DIR" 2>> "$LOG_FILE"; then
    SIZE=$(du -h "$ARCHIVE" | cut -f1)
    log "Backup completed: $ARCHIVE ($SIZE)"
    exit 0
else
    log "ERROR: backup failed"
    exit 1
fi
