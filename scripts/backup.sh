#!/bin/bash

SOURCE_DIR="/var/www/html/uploads/"
DEST_DIR="/var/backups/uploads_backup/"

sudo cp -r $SOURCE_DIR* $DEST_DIR

# Log Backup
echo "Backup of $SOURCE_DIR completed on $(date)" >> /var/log/backup.log