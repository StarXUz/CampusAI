# 交付回归清单（企业版）

运行脚本：

```bash
chmod +x ./scripts/regression_smoke.sh
./scripts/regression_smoke.sh
```

## 覆盖范围

1. 业务一致性
- 订单状态流：`UNPAID -> PAID -> CANCELLED(超时)`。
- 支付幂等：重复支付同一订单不报错，最终状态保持 `PAID`。

2. 并发安全
- 同用户同时间段重复预约会被拦截。
- 改期次数上限（最多 2 次）有效。

3. 数据实时性
- 订单列表触发超时取消后立即可见最新状态。
- 预约改期后查询立即刷新。

4. 角色边界
- 未登录访问 `/api/admin/**` 返回 JSON `401`。
- 管理员访问 `/api/super/**` 返回 JSON `403`。

5. 可运维性
- API 响应包含 `X-Request-Id`。
- 审计日志分页接口可查询，具备可追溯能力。

## 前置条件

- 三端口应用已启动（8091/8092/8093）。
- MySQL、Redis 可用，连接参数与 `application.properties` 一致。
- 默认管理员可登录（可通过环境变量覆盖）：
  - `ADMIN_USER=merchant_north`
  - `ADMIN_PASS=123456`

## 可选环境变量

```bash
BASE_ADMIN_URL=http://127.0.0.1:8091
BASE_CLIENT_URL=http://127.0.0.1:8092
BASE_SUPER_URL=http://127.0.0.1:8093

DB_HOST=127.0.0.1
DB_PORT=3306
DB_NAME=campus_service_manager_ai
DB_USER=root
DB_PASSWORD=123456

REDIS_HOST=127.0.0.1
REDIS_PORT=6379
REDIS_DB=0
```
