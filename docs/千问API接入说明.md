# 千问 API 接入说明

当前项目已经按“兼容 OpenAI 协议的千问接口”完成配置，默认读取环境变量，不需要把密钥硬编码到代码里。

## 一、项目当前配置

配置文件：
`/Users/xujunming/idea-java/网站架构项目大作业/Campus Service ManagerAI/web/src/main/resources/application.properties`

当前关键配置为：

```properties
app.ai.enabled=true
app.ai.provider=qwen-compatible
app.ai.api-key=${QWEN_API_KEY:${DASHSCOPE_API_KEY:}}
app.ai.api-url=https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions
app.ai.model=qwen-plus
```

说明：

1. 项目优先读取 `QWEN_API_KEY`
2. 如果未设置 `QWEN_API_KEY`，会继续读取 `DASHSCOPE_API_KEY`
3. 这意味着你可以直接使用千问密钥，不需要改成 OpenAI 密钥

## 二、终端运行方式

在启动项目前，先执行：

```bash
export QWEN_API_KEY=你的千问密钥
```

然后再启动项目。

如果你更习惯阿里云命名，也可以：

```bash
export DASHSCOPE_API_KEY=你的千问密钥
```

## 三、IDEA 中的配置方式

如果你用 IntelliJ IDEA 启动：

1. 打开 `Run/Debug Configurations`
2. 找到项目运行配置
3. 在 `Environment variables` 中加入：

```text
QWEN_API_KEY=你的千问密钥
```

或：

```text
DASHSCOPE_API_KEY=你的千问密钥
```

## 四、如何验证是否接入成功

项目启动后，进入学生端 AI 助手页面，输入一个简单问题，例如：

- 今天有哪些商家营业？
- 推荐一个轻食类菜品
- 最近有什么校园活动？

如果返回正常答案，说明接入成功。

如果返回鉴权失败或 401/403，一般是：

1. 环境变量没有生效
2. 密钥复制错误
3. 当前账号没有对应模型权限

## 五、安全建议

1. 不要把真实密钥直接写入 Git 仓库
2. 不要提交到 `application.properties`
3. 优先用系统环境变量或 IDEA 运行配置传入

这样更安全，也更适合课程项目后续演示和打包。
