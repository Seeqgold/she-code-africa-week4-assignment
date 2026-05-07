#!/bin/bash

CONTAINER_NAME="mysql-db"
DB_NAME="wordpress_db"
BACKUP_DIR="/tmp"
TIMESTAMP=$(date +%F-%H%M)
BACKUP_FILE="${BACKUP_DIR}/backup-${TIMESTAMP}.sql"
S3_BUCKET="s3://wordpress-backup-sikirat-2026"

# create a mysql dump
docker exec ${CONTAINER_NAME} mysqldump 
-u root 
-p${MYSQL_ROOT_PASSWORD} 
${DB_NAME} > ${BACKUP_FILE}

# Check if backup was created 
if [ $? -ne 0 ]; then echo "Backup failed!" 
	exit 1 
fi

# upload backup to s3
aws s3 cp ${BACKUP_FILE} ${S3_BUCKET}

# Check upload status
if [ $? -eq 0 ]; 
then echo "Backup successfully uploaded!" 
	echo "S3 Location: ${S3_BUCKET}/backup-${TIMESTAMP}.sql"
else echo "S3 upload failed!" 
	exit 1 
fi
