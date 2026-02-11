#!/bin/bash
# Arvutiklasside andmebaasi varundamise skript
# Kasutamine: bash backup/backup.sh

DB_NAME="${PGDATABASE:-arvutiklassid}"
BACKUP_DIR="$(dirname "$0")"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/backup_${DB_NAME}_${TIMESTAMP}.sql"

echo "=== Andmebaasi varundamine ==="
echo "Andmebaas: $DB_NAME"
echo "Fail: $BACKUP_FILE"
echo ""

pg_dump "$DB_NAME" > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✓ Varukoopia loodud edukalt!"
    echo "  Faili suurus: $(wc -c < "$BACKUP_FILE" | tr -d ' ') baiti"
else
    echo "✗ Viga varukoopia loomisel!"
    exit 1
fi
