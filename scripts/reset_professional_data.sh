#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SEED_SQL="$ROOT_DIR/scripts/sql/professional_seed_2026.sql"
BACKUP_DIR="$ROOT_DIR/runtime-db-backup"

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-campus_service_manager_ai}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-123456}"

if [[ ! -f "$SEED_SQL" ]]; then
  echo "未找到种子脚本: $SEED_SQL"
  exit 1
fi

mkdir -p "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_backup_$(date +%Y%m%d_%H%M%S).sql"

echo "1/3 正在备份当前数据库 -> $BACKUP_FILE"
mysqldump -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$BACKUP_FILE"

echo "2/3 正在导入专业演示数据 -> $SEED_SQL"
mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$SEED_SQL"

echo "3/3 完成"
echo "数据库: $DB_NAME"
echo "备份文件: $BACKUP_FILE"
echo "你现在可以刷新三个端口页面查看最新专业数据。"
