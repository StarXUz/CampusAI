# Campus Service Manager AI 端口说明

## 端口与端别映射

- `8091` -> 管理端（ADMIN）  
  默认入口：`http://127.0.0.1:8091/admin/overview`

- `8092` -> 学生端（CLIENT）  
  默认入口：`http://127.0.0.1:8092/client`

- `8093` -> 超级端（SUPER）  
  默认入口：`http://127.0.0.1:8093/super/overview`

## 快速访问行为

- 访问 `http://127.0.0.1:8091/` -> 跳转登录页（或已登录角色对应页）
- 访问 `http://127.0.0.1:8092/` -> 直接跳转学生端
- 访问 `http://127.0.0.1:8093/` -> 直接跳转超级端

## 启动终端输出

应用启动后，终端会打印：

- 管理端链接
- 学生端链接
- 超级端链接

默认不会自动打开浏览器，只在终端打印以上 3 个链接，按需点击访问。

## AI 接入说明

- 当前项目 AI 已改为兼容千问接口，不需要 OpenAI Key。
- 启动前可任选一种环境变量：
  - `export QWEN_API_KEY=你的千问密钥`
  - `export DASHSCOPE_API_KEY=你的千问密钥`
- 详细说明见：
  - `docs/千问API接入说明.md`

## 专业演示数据重置

- 一键重置脚本：`./scripts/reset_professional_data.sh`
- 默认数据库连接：
  - `DB_HOST=127.0.0.1`
  - `DB_PORT=3306`
  - `DB_NAME=campus_service_manager_ai`
  - `DB_USER=root`
  - `DB_PASSWORD=123456`
- 自定义示例：
  - `DB_PASSWORD=你的密码 ./scripts/reset_professional_data.sh`
