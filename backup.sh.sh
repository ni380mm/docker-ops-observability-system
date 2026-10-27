#!/bin/bash
BACKUP_DIR="/home/admin/devops-project/mysql/backup"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="devops_db"
CONTAINER_NAME="ops-mysql"
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${DATE}.sql.gz"
LOG_FILE="${BACKUP_DIR}/backup.log"

echo "[$(date +"%Y-%m-%d %H:%M:%S")] 开始执行数据库备份..." >> $LOG_FILE

docker exec $CONTAINER_NAME mysqldump -uroot -pDevops@2026 $DB_NAME | gzip > $BACKUP_FILE

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] 备份成功: $BACKUP_FILE" >> $LOG_FILE
else
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] 备份失败，请检查数据库状态！" >> $LOG_FILE
    exit 1
fi

find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -exec rm -f {} \;
echo "[$(date +"%Y-%m-%d %H:%M:%S")] 已清理 7 天前的历史备份。" >> $LOG_FILE
