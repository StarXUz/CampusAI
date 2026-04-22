#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TMP_DIR="$ROOT_DIR/runtime-smoke"
mkdir -p "$TMP_DIR"

BASE_ADMIN_URL="${BASE_ADMIN_URL:-http://127.0.0.1:8091}"
BASE_CLIENT_URL="${BASE_CLIENT_URL:-http://127.0.0.1:8092}"
BASE_SUPER_URL="${BASE_SUPER_URL:-http://127.0.0.1:8093}"

ADMIN_USER="${ADMIN_USER:-merchant_north}"
ADMIN_PASS="${ADMIN_PASS:-123456}"

DB_HOST="${DB_HOST:-127.0.0.1}"
DB_PORT="${DB_PORT:-3306}"
DB_NAME="${DB_NAME:-campus_service_manager_ai}"
DB_USER="${DB_USER:-root}"
DB_PASSWORD="${DB_PASSWORD:-123456}"

REDIS_HOST="${REDIS_HOST:-127.0.0.1}"
REDIS_PORT="${REDIS_PORT:-6379}"
REDIS_DB="${REDIS_DB:-0}"

ADMIN_COOKIE="$TMP_DIR/admin.cookie"
CLIENT_COOKIE="$TMP_DIR/client.cookie"

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "缺少命令: $cmd"
    exit 1
  fi
}

log_step() {
  echo
  echo "==> $1"
}

assert_eq() {
  local actual="$1"
  local expected="$2"
  local msg="$3"
  if [[ "$actual" != "$expected" ]]; then
    echo "断言失败: $msg"
    echo "期望: $expected"
    echo "实际: $actual"
    exit 1
  fi
}

assert_non_empty() {
  local val="$1"
  local msg="$2"
  if [[ -z "$val" || "$val" == "null" ]]; then
    echo "断言失败: $msg"
    exit 1
  fi
}

curl_json_with_code() {
  local outfile="$1"
  shift
  curl -sS -o "$outfile" -w "%{http_code}" "$@"
}

require_cmd curl
require_cmd jq
require_cmd redis-cli
require_cmd mysql

rm -f "$ADMIN_COOKIE" "$CLIENT_COOKIE"

log_step "0) API 未登录返回 JSON + 401，并带 X-Request-Id"
UNAUTH_BODY="$TMP_DIR/unauth.json"
UNAUTH_CODE="$(curl_json_with_code "$UNAUTH_BODY" -D "$TMP_DIR/unauth.header" "$BASE_ADMIN_URL/api/admin/dashboard")"
assert_eq "$UNAUTH_CODE" "401" "未登录访问 /api/admin/dashboard 应返回 401"
assert_eq "$(jq -r '.success' "$UNAUTH_BODY")" "false" "未登录响应 success 应为 false"
TRACE_HEADER="$(grep -i '^X-Request-Id:' "$TMP_DIR/unauth.header" | head -n 1 | awk '{print $2}' | tr -d '\r')"
assert_non_empty "$TRACE_HEADER" "未登录响应应包含 X-Request-Id"
echo "PASS: 未登录 API 鉴权与追踪头"

log_step "1) 管理端登录 + 角色边界校验"
LOGIN_CODE="$(curl -sS -c "$ADMIN_COOKIE" -b "$ADMIN_COOKIE" -o /dev/null -w "%{http_code}" \
  -X POST "$BASE_ADMIN_URL/login" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "username=$ADMIN_USER" \
  --data-urlencode "password=$ADMIN_PASS" \
  --data-urlencode "portalTarget=admin")"
assert_eq "$LOGIN_CODE" "302" "管理端表单登录应返回 302"

ADMIN_DASH_BODY="$TMP_DIR/admin_dashboard.json"
ADMIN_DASH_CODE="$(curl_json_with_code "$ADMIN_DASH_BODY" -b "$ADMIN_COOKIE" -c "$ADMIN_COOKIE" "$BASE_ADMIN_URL/api/admin/dashboard")"
assert_eq "$ADMIN_DASH_CODE" "200" "管理员访问 /api/admin/dashboard 应成功"
assert_eq "$(jq -r '.success' "$ADMIN_DASH_BODY")" "true" "管理员访问 dashboard success 应为 true"

SUPER_FORBIDDEN_BODY="$TMP_DIR/super_forbidden.json"
SUPER_FORBIDDEN_CODE="$(curl_json_with_code "$SUPER_FORBIDDEN_BODY" -b "$ADMIN_COOKIE" "$BASE_ADMIN_URL/api/super/overview")"
assert_eq "$SUPER_FORBIDDEN_CODE" "403" "管理员访问 /api/super/overview 应为 403"
assert_eq "$(jq -r '.success' "$SUPER_FORBIDDEN_BODY")" "false" "无权限响应 success 应为 false"
echo "PASS: 管理员登录与超级端越权拦截"

log_step "2) 学生端登录（验证码自动读取 Redis）"
PHONE="139$(date +%s | tail -c 9)"
SEND_BODY="$TMP_DIR/send_code.json"
SEND_CODE_HTTP="$(curl_json_with_code "$SEND_BODY" \
  -X POST "$BASE_CLIENT_URL/api/auth/send-code" \
  -H "Content-Type: application/json" \
  -d "{\"phone\":\"$PHONE\"}")"
assert_eq "$SEND_CODE_HTTP" "200" "发送验证码应成功"
assert_eq "$(jq -r '.success' "$SEND_BODY")" "true" "发送验证码 success 应为 true"

REDIS_KEY="campus:login:code:$PHONE"
CODE="$(redis-cli -h "$REDIS_HOST" -p "$REDIS_PORT" -n "$REDIS_DB" GET "$REDIS_KEY" | tr -d '\r')"
assert_non_empty "$CODE" "应能从 Redis 读取验证码"

CLIENT_LOGIN_BODY="$TMP_DIR/client_login.json"
CLIENT_LOGIN_HTTP="$(curl_json_with_code "$CLIENT_LOGIN_BODY" -c "$CLIENT_COOKIE" -b "$CLIENT_COOKIE" \
  -X POST "$BASE_CLIENT_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"phone\":\"$PHONE\",\"code\":\"$CODE\"}")"
assert_eq "$CLIENT_LOGIN_HTTP" "200" "学生端登录应成功"
assert_eq "$(jq -r '.success' "$CLIENT_LOGIN_BODY")" "true" "学生端登录 success 应为 true"
CLIENT_USER_ID="$(jq -r '.data.id' "$CLIENT_LOGIN_BODY")"
assert_non_empty "$CLIENT_USER_ID" "学生端登录应返回 user id"
echo "PASS: 学生端验证码登录"

log_step "3) 订单状态流：UNPAID -> PAID；重复支付幂等；超时自动取消"
MERCHANTS_BODY="$TMP_DIR/merchants.json"
curl -sS -b "$CLIENT_COOKIE" "$BASE_CLIENT_URL/api/client/merchants" > "$MERCHANTS_BODY"
MERCHANT_ID="$(jq -r '.data[0].id' "$MERCHANTS_BODY")"
assert_non_empty "$MERCHANT_ID" "应存在至少一个商家"

DISHES_BODY="$TMP_DIR/dishes.json"
curl -sS -b "$CLIENT_COOKIE" "$BASE_CLIENT_URL/api/client/merchants/$MERCHANT_ID/dishes?pageNum=1&pageSize=50&includeSoldOut=true" > "$DISHES_BODY"
DISH_NAME="$(jq -r '.data.records[] | select(.onSale==true) | .name' "$DISHES_BODY" | head -n 1)"
DISH_PRICE="$(jq -r '.data.records[] | select(.onSale==true) | .price' "$DISHES_BODY" | head -n 1)"
assert_non_empty "$DISH_NAME" "应存在可下单菜品"
assert_non_empty "$DISH_PRICE" "应存在可下单菜品价格"

CREATE_ORDER_BODY="$TMP_DIR/create_order.json"
curl -sS -b "$CLIENT_COOKIE" -c "$CLIENT_COOKIE" -X POST "$BASE_CLIENT_URL/api/client/orders" \
  -H "Content-Type: application/json" \
  -d "{\"merchantId\":$MERCHANT_ID,\"itemType\":\"DISH\",\"itemName\":\"$DISH_NAME\",\"totalAmount\":$DISH_PRICE}" > "$CREATE_ORDER_BODY"
assert_eq "$(jq -r '.success' "$CREATE_ORDER_BODY")" "true" "创建订单应成功"
ORDER_ID="$(jq -r '.data.id' "$CREATE_ORDER_BODY")"
assert_non_empty "$ORDER_ID" "创建订单应返回订单ID"
assert_eq "$(jq -r '.data.status' "$CREATE_ORDER_BODY")" "UNPAID" "新订单应为 UNPAID"

PAY_ONCE_BODY="$TMP_DIR/pay_once.json"
curl -sS -b "$CLIENT_COOKIE" -c "$CLIENT_COOKIE" -X POST "$BASE_CLIENT_URL/api/client/orders/$ORDER_ID/pay" \
  -H "Content-Type: application/json" \
  -d '{"payChannel":"WECHAT"}' > "$PAY_ONCE_BODY"
assert_eq "$(jq -r '.success' "$PAY_ONCE_BODY")" "true" "首次支付应成功"
assert_eq "$(jq -r '.data.status' "$PAY_ONCE_BODY")" "PAID" "支付后订单应为 PAID"

PAY_TWICE_BODY="$TMP_DIR/pay_twice.json"
curl -sS -b "$CLIENT_COOKIE" -c "$CLIENT_COOKIE" -X POST "$BASE_CLIENT_URL/api/client/orders/$ORDER_ID/pay" \
  -H "Content-Type: application/json" \
  -d '{"payChannel":"ALIPAY"}' > "$PAY_TWICE_BODY"
assert_eq "$(jq -r '.success' "$PAY_TWICE_BODY")" "true" "重复支付应幂等成功"
assert_eq "$(jq -r '.data.status' "$PAY_TWICE_BODY")" "PAID" "重复支付后仍应为 PAID"

CREATE_TIMEOUT_BODY="$TMP_DIR/create_timeout_order.json"
curl -sS -b "$CLIENT_COOKIE" -c "$CLIENT_COOKIE" -X POST "$BASE_CLIENT_URL/api/client/orders" \
  -H "Content-Type: application/json" \
  -d "{\"merchantId\":$MERCHANT_ID,\"itemType\":\"DISH\",\"itemName\":\"$DISH_NAME\",\"totalAmount\":$DISH_PRICE}" > "$CREATE_TIMEOUT_BODY"
TIMEOUT_ORDER_ID="$(jq -r '.data.id' "$CREATE_TIMEOUT_BODY")"
assert_non_empty "$TIMEOUT_ORDER_ID" "超时测试订单应创建成功"

mysql -h"$DB_HOST" -P"$DB_PORT" -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -e \
  "update campus_order set created_at = date_sub(now(), interval 20 minute), status='UNPAID' where id = $TIMEOUT_ORDER_ID;"

ORDERS_AFTER_TIMEOUT_BODY="$TMP_DIR/orders_after_timeout.json"
curl -sS -b "$CLIENT_COOKIE" "$BASE_CLIENT_URL/api/client/orders/mine" > "$ORDERS_AFTER_TIMEOUT_BODY"
TIMEOUT_STATUS="$(jq -r ".data[] | select(.id==$TIMEOUT_ORDER_ID) | .status" "$ORDERS_AFTER_TIMEOUT_BODY" | head -n 1)"
assert_eq "$TIMEOUT_STATUS" "CANCELLED" "超时订单应自动变为 CANCELLED"
echo "PASS: 订单状态流与幂等、超时取消"

log_step "4) 预约并发/重复防护 + 改期上限"
ROOMS_BODY="$TMP_DIR/rooms.json"
curl -sS -b "$CLIENT_COOKIE" "$BASE_CLIENT_URL/api/client/study-rooms" > "$ROOMS_BODY"
ROOM_ID="$(jq -r '.data[0].id' "$ROOMS_BODY")"
assert_non_empty "$ROOM_ID" "应存在自习室"

RESERVE_DATE="$(date -v+1d +%F 2>/dev/null || date -d '+1 day' +%F)"
SEATS_BODY="$TMP_DIR/seats.json"
curl -sS -b "$CLIENT_COOKIE" "$BASE_CLIENT_URL/api/client/study-rooms/$ROOM_ID/seats?reservationDate=$RESERVE_DATE&startTime=10:00&endTime=12:00" > "$SEATS_BODY"
SEAT_1="$(jq -r '.data[] | select(.status=="FREE") | .id' "$SEATS_BODY" | head -n 1)"
SEAT_2="$(jq -r '.data[] | select(.status=="FREE") | .id' "$SEATS_BODY" | sed -n '2p')"
assert_non_empty "$SEAT_1" "应存在空闲座位1"
assert_non_empty "$SEAT_2" "应存在空闲座位2"

RESERVE_OK_BODY="$TMP_DIR/reserve_ok.json"
curl -sS -b "$CLIENT_COOKIE" -c "$CLIENT_COOKIE" -X POST "$BASE_CLIENT_URL/api/client/study-rooms/reserve" \
  -H "Content-Type: application/json" \
  -d "{\"roomId\":$ROOM_ID,\"seatId\":$SEAT_1,\"reservationDate\":\"$RESERVE_DATE\",\"startTime\":\"10:00\",\"endTime\":\"12:00\"}" > "$RESERVE_OK_BODY"
assert_eq "$(jq -r '.success' "$RESERVE_OK_BODY")" "true" "首次预约应成功"

RESERVE_DUP_BODY="$TMP_DIR/reserve_dup.json"
curl -sS -b "$CLIENT_COOKIE" -c "$CLIENT_COOKIE" -X POST "$BASE_CLIENT_URL/api/client/study-rooms/reserve" \
  -H "Content-Type: application/json" \
  -d "{\"roomId\":$ROOM_ID,\"seatId\":$SEAT_2,\"reservationDate\":\"$RESERVE_DATE\",\"startTime\":\"10:00\",\"endTime\":\"12:00\"}" > "$RESERVE_DUP_BODY"
assert_eq "$(jq -r '.success' "$RESERVE_DUP_BODY")" "false" "同用户同时段重复预约应失败"

MY_RESERVATIONS_BODY="$TMP_DIR/my_reservations.json"
curl -sS -b "$CLIENT_COOKIE" "$BASE_CLIENT_URL/api/client/study-rooms/reservations/mine" > "$MY_RESERVATIONS_BODY"
RESERVATION_ID="$(jq -r '.data[] | select(.reservationDate == [($date[0:4]|tonumber), ($date[5:7]|tonumber), ($date[8:10]|tonumber)] and .startTime == [10,0]) | .id' --arg date "$RESERVE_DATE" "$MY_RESERVATIONS_BODY" | head -n 1)"
assert_non_empty "$RESERVATION_ID" "应能查到预约记录ID"

RESCHEDULE_1="$TMP_DIR/reschedule1.json"
curl -sS -b "$CLIENT_COOKIE" -X POST "$BASE_CLIENT_URL/api/client/study-rooms/reservations/$RESERVATION_ID/reschedule" \
  -H "Content-Type: application/json" \
  -d "{\"roomId\":$ROOM_ID,\"seatId\":$SEAT_1,\"reservationDate\":\"$RESERVE_DATE\",\"startTime\":\"12:00\",\"endTime\":\"14:00\"}" > "$RESCHEDULE_1"
assert_eq "$(jq -r '.success' "$RESCHEDULE_1")" "true" "第一次改期应成功"

RESCHEDULE_2="$TMP_DIR/reschedule2.json"
curl -sS -b "$CLIENT_COOKIE" -X POST "$BASE_CLIENT_URL/api/client/study-rooms/reservations/$RESERVATION_ID/reschedule" \
  -H "Content-Type: application/json" \
  -d "{\"roomId\":$ROOM_ID,\"seatId\":$SEAT_1,\"reservationDate\":\"$RESERVE_DATE\",\"startTime\":\"14:00\",\"endTime\":\"16:00\"}" > "$RESCHEDULE_2"
assert_eq "$(jq -r '.success' "$RESCHEDULE_2")" "true" "第二次改期应成功"

RESCHEDULE_3="$TMP_DIR/reschedule3.json"
curl -sS -b "$CLIENT_COOKIE" -X POST "$BASE_CLIENT_URL/api/client/study-rooms/reservations/$RESERVATION_ID/reschedule" \
  -H "Content-Type: application/json" \
  -d "{\"roomId\":$ROOM_ID,\"seatId\":$SEAT_1,\"reservationDate\":\"$RESERVE_DATE\",\"startTime\":\"16:00\",\"endTime\":\"18:00\"}" > "$RESCHEDULE_3"
assert_eq "$(jq -r '.success' "$RESCHEDULE_3")" "false" "第三次改期应失败（超过上限）"
echo "PASS: 预约重复防护与改期上限"

log_step "5) 审计日志可追溯（后台）"
AUDIT_BODY="$TMP_DIR/admin_audit_page.json"
curl -sS -b "$ADMIN_COOKIE" -X POST "$BASE_ADMIN_URL/api/admin/audit-logs/page" \
  -H "Content-Type: application/json" \
  -d '{"pageNum":1,"pageSize":10}' > "$AUDIT_BODY"
assert_eq "$(jq -r '.success' "$AUDIT_BODY")" "true" "审计日志分页查询应成功"
AUDIT_TOTAL="$(jq -r '.data.total' "$AUDIT_BODY")"
assert_non_empty "$AUDIT_TOTAL" "审计日志应返回 total"
echo "PASS: 审计日志可查询"

echo
echo "所有关键回归项已通过。"
echo "输出目录: $TMP_DIR"
