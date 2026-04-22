<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>智慧校园生活服务平台 - 登录</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/static/css/main.css">
    <style>
        .campus-login-body {
            min-height: 100vh;
            margin: 0;
            background:
                radial-gradient(circle at 18% 18%, rgba(255, 255, 255, 0.12), transparent 28%),
                radial-gradient(circle at 82% 10%, rgba(64, 158, 255, 0.22), transparent 24%),
                linear-gradient(135deg, #2c394b 0%, #344b62 48%, #436789 100%);
            font-family: "Microsoft YaHei", "PingFang SC", sans-serif;
        }

        .campus-login-page {
            min-height: 100vh;
            display: grid;
            place-items: center;
            padding: 30px 20px;
        }

        .campus-login-shell {
            width: min(1080px, calc(100vw - 32px));
            display: grid;
            grid-template-columns: 1.05fr 0.95fr;
            background: rgba(245, 247, 250, 0.97);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 24px 60px rgba(15, 33, 56, 0.28);
        }

        .campus-login-hero {
            padding: 54px 44px 42px;
            color: #fff;
            background:
                linear-gradient(180deg, rgba(16, 28, 40, 0.1), rgba(16, 28, 40, 0.22)),
                linear-gradient(155deg, #24405b 0%, #2f5376 50%, #3f74a8 100%);
        }

        .campus-login-badge {
            display: inline-flex;
            align-items: center;
            padding: 8px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.18);
            font-size: 13px;
            letter-spacing: 0.04em;
        }

        .campus-login-hero h1 {
            margin: 24px 0 14px;
            font-size: 38px;
            line-height: 1.24;
        }

        .campus-login-hero p {
            margin: 0;
            line-height: 1.9;
            color: rgba(255, 255, 255, 0.86);
        }

        .campus-login-highlights {
            margin: 28px 0 0;
            padding: 0;
            list-style: none;
            display: grid;
            gap: 14px;
        }

        .campus-login-highlights li {
            display: grid;
            grid-template-columns: 14px 1fr;
            gap: 12px;
            align-items: start;
            color: rgba(255, 255, 255, 0.9);
            line-height: 1.7;
        }

        .campus-login-highlights li::before {
            content: "";
            width: 12px;
            height: 12px;
            margin-top: 6px;
            border-radius: 50%;
            background: linear-gradient(135deg, #8ec5ff, #d6ebff);
            box-shadow: 0 0 0 4px rgba(255, 255, 255, 0.08);
        }

        .campus-login-panels {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 12px;
            margin-top: 38px;
        }

        .campus-port-switch {
            margin-top: 18px;
            display: grid;
            gap: 10px;
        }

        .campus-port-switch-title {
            font-size: 13px;
            color: rgba(255, 255, 255, 0.78);
            letter-spacing: 0.06em;
        }

        .campus-port-switch-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 10px;
        }

        .campus-port-switch button {
            text-align: left;
            padding: 11px 12px;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.18);
            background: rgba(255, 255, 255, 0.12);
            color: #fff;
            cursor: pointer;
            font: inherit;
        }

        .campus-port-switch button strong {
            display: block;
            font-size: 13px;
            margin-bottom: 4px;
        }

        .campus-port-switch button span {
            display: block;
            font-size: 12px;
            color: rgba(255, 255, 255, 0.78);
        }

        .campus-port-switch button em {
            display: block;
            margin-top: 3px;
            font-style: normal;
            font-size: 11px;
            color: rgba(255, 255, 255, 0.72);
            line-height: 1.55;
        }

        .campus-port-switch button.active {
            background: rgba(255, 255, 255, 0.24);
            border-color: rgba(255, 255, 255, 0.45);
            box-shadow: 0 10px 20px rgba(8, 18, 30, 0.18);
        }

        .campus-login-panel {
            padding: 18px 20px;
            border-radius: 18px;
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.14);
        }

        .campus-login-panel strong {
            display: block;
            margin-bottom: 8px;
            font-size: 16px;
        }

        .campus-login-panel span {
            color: rgba(255, 255, 255, 0.82);
            line-height: 1.7;
            font-size: 14px;
        }

        .campus-login-panel ul {
            margin: 8px 0 0;
            padding-left: 16px;
            color: rgba(255, 255, 255, 0.84);
            font-size: 12px;
            line-height: 1.65;
        }

        .campus-login-panel li + li {
            margin-top: 3px;
        }

        .campus-login-box {
            padding: 42px 36px;
            background: #f7f9fc;
        }

        .campus-login-header {
            margin-bottom: 24px;
        }

        .campus-login-header strong {
            display: block;
            color: #2f3b4d;
            font-size: 28px;
            line-height: 1.25;
        }

        .campus-login-header span {
            display: block;
            margin-top: 8px;
            color: #7b8795;
            line-height: 1.7;
            font-size: 14px;
        }

        .campus-port-tip {
            margin-top: 10px;
            padding: 8px 10px;
            border-radius: 10px;
            background: #edf5ff;
            color: #2d6fbe;
            font-size: 12px;
            line-height: 1.6;
            border: 1px solid #d2e6ff;
        }

        .campus-demo-path {
            margin: 0 0 16px;
            padding: 12px 14px;
            border-radius: 12px;
            border: 1px solid #dbe6f2;
            background: #f9fcff;
        }

        .campus-demo-path strong {
            display: block;
            margin: 0 0 6px;
            color: #274565;
            font-size: 14px;
        }

        .campus-demo-path ol {
            margin: 0;
            padding-left: 18px;
            color: #5a6f85;
            font-size: 13px;
            line-height: 1.68;
        }

        .campus-primary-btn,
        .campus-light-btn {
            border: 0;
            cursor: pointer;
            font: inherit;
        }

        .campus-login-form {
            display: none;
        }

        .campus-login-form.active {
            display: block;
        }

        .campus-login-title {
            margin-bottom: 18px;
        }

        .campus-login-title h2 {
            margin: 0 0 8px;
            font-size: 30px;
            color: #303133;
        }

        .campus-login-title p {
            margin: 0;
            color: #909399;
            line-height: 1.8;
        }

        .campus-form-stack {
            display: grid;
            gap: 12px;
        }

        .campus-field-label {
            margin: 2px 0 -2px;
            color: #5e6b78;
            font-size: 14px;
            font-weight: 600;
        }

        .campus-input-wrap {
            display: flex;
            align-items: center;
            min-height: 54px;
            border: 1px solid #dfe5ee;
            border-radius: 12px;
            background: #fff;
            overflow: hidden;
        }

        .campus-input-icon {
            width: 56px;
            flex: 0 0 56px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: #f7f9fb;
            border-right: 1px solid #e7ebf0;
        }

        .campus-input-icon::before {
            content: "";
            width: 14px;
            height: 14px;
            border-radius: 50%;
            background: linear-gradient(135deg, #409eff, #7ab8ff);
            box-shadow: 0 0 0 5px rgba(64, 158, 255, 0.12);
        }

        .campus-input-wrap input {
            width: 100%;
            border: 0;
            background: transparent;
            padding: 14px 16px;
            font: inherit;
            color: #303133;
        }

        .campus-inline-form {
            display: grid;
            grid-template-columns: minmax(0, 1fr) auto;
            gap: 10px;
        }

        .campus-checkbox-row {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #606266;
            font-size: 14px;
            line-height: 1.2;
        }

        .campus-checkbox-row input[type="checkbox"] {
            width: 16px;
            height: 16px;
            margin: 0;
            accent-color: #409eff;
            flex: 0 0 16px;
        }

        .campus-primary-btn {
            width: 100%;
            padding: 13px 18px;
            border-radius: 12px;
            background: linear-gradient(135deg, #409eff, #6fb3ff);
            color: #fff;
            font-weight: 600;
        }

        .campus-primary-btn:disabled,
        .campus-light-btn:disabled {
            opacity: 0.72;
            cursor: not-allowed;
        }

        .campus-light-btn {
            padding: 0 18px;
            border-radius: 12px;
            background: #edf5ff;
            color: #409eff;
            min-width: 128px;
            font-weight: 600;
        }

        .campus-login-tips {
            margin-top: 16px;
            font-size: 13px;
            color: #909399;
            line-height: 1.85;
        }

        .campus-login-desc {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-top: 22px;
            padding-top: 18px;
            border-top: 1px dashed #d8dee8;
            color: #909399;
            font-size: 12px;
        }

        .campus-login-notice {
            display: none;
            margin-top: 18px;
            padding: 13px 14px;
            border-left: 4px solid #e6a23c;
            border-radius: 10px;
            background: #fdf6ec;
            color: #b88230;
            line-height: 1.7;
        }

        .campus-login-notice.show {
            display: block;
        }

        @media (max-width: 960px) {
            .campus-login-shell {
                grid-template-columns: 1fr;
            }

            .campus-login-hero,
            .campus-login-box {
                padding: 30px 24px;
            }

            .campus-login-panels {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 640px) {
            .campus-inline-form,
            .campus-login-desc {
                grid-template-columns: 1fr;
            }

            .campus-login-desc {
                display: grid;
            }

            .campus-login-hero h1,
            .campus-login-title h2 {
                font-size: 26px;
            }
        }
    </style>
</head>
<body class="campus-login-body"
      data-login-portal="${loginPortal!'admin'}"
      data-admin-host="${adminHost!'127.0.0.1'}"
      data-client-host="${clientHost!'localhost'}"
      data-super-host="${superHost!'::1'}"
      data-admin-port="${adminPort!'8091'}"
      data-client-port="${clientPort!'8092'}"
      data-super-port="${superPort!'8093'}">
<div class="campus-login-page">
    <div class="campus-login-shell">
        <section class="campus-login-hero">
            <span class="campus-login-badge">Campus Service Manager</span>
            <h1>智慧校园生活服务平台</h1>
            <p>覆盖校园餐饮、自习室预约、活动报名与 AI 服务，支持统一账号、统一数据与统一权限管理。</p>
            <ul class="campus-login-highlights">
                <li>管理端：商家、菜品、套餐、自习室、活动与报表管理。</li>
                <li>用户端：手机号登录、预约、报名、支付与 AI 问答。</li>
                <li>超级端：账号治理、审计日志、跨端联动总览。</li>
            </ul>
            <div class="campus-login-panels">
                <div class="campus-login-panel">
                    <strong>管理端</strong>
                    <span>用于业务运营管理与规则配置。</span>
                    <ul>
                        <li>商家与菜品增删改查</li>
                        <li>活动、自习室与审计联动</li>
                    </ul>
                </div>
                <div class="campus-login-panel">
                    <strong>学生端</strong>
                    <span>用于学生日常办理与服务查询。</span>
                    <ul>
                        <li>点餐支付、预约座位、报名活动</li>
                        <li>个人资料与 AI 问答</li>
                    </ul>
                </div>
                <div class="campus-login-panel">
                    <strong>超级端</strong>
                    <span>用于账号治理与跨端权限控制。</span>
                    <ul>
                        <li>学生端/管理端账号统一管理</li>
                        <li>审计日志追溯与趋势查看</li>
                    </ul>
                </div>
            </div>
            <div class="campus-port-switch">
                <div class="campus-port-switch-title">端口切换</div>
                <div class="campus-port-switch-grid" id="port-switch-grid">
                    <button type="button" data-portal="admin" data-port="${adminPort!'8091'}" data-host="${adminHost!'127.0.0.1'}" data-href="/login/admin">
                        <strong>管理端 8091</strong>
                        <span>/login/admin</span>
                        <em>商家/菜品/活动/审计</em>
                    </button>
                    <button type="button" data-portal="client" data-port="${clientPort!'8092'}" data-host="${clientHost!'localhost'}" data-href="/login/client">
                        <strong>学生端 8092</strong>
                        <span>/login/client</span>
                        <em>点餐/预约/报名/AI</em>
                    </button>
                    <button type="button" data-portal="super" data-port="${superPort!'8093'}" data-host="${superHost!'::1'}" data-href="/login/super">
                        <strong>超级端 8093</strong>
                        <span>/login/super</span>
                        <em>账号治理/跨端联动</em>
                    </button>
                </div>
            </div>
        </section>

        <section class="campus-login-box">
            <div class="campus-login-header">
                <strong id="login-entry-title">统一身份登录</strong>
                <span id="login-entry-subtitle">按当前端口进入对应系统，登录后直达该端首页。</span>
                <div id="port-tip" class="campus-port-tip"></div>
            </div>
            <div id="demo-path" class="campus-demo-path">
                <strong id="demo-path-title">管理端黄金演示路径</strong>
                <ol id="demo-path-list"></ol>
            </div>

            <div id="admin-form" class="campus-login-form active">
                <div class="campus-login-title">
                    <h2 id="admin-login-title">后台管理登录</h2>
                    <p id="admin-login-desc">商家、自习室、活动、统计报表统一从这里进入。</p>
                </div>
                <form method="post" action="/login" class="campus-form-stack">
                    <input id="portal-target-input" type="hidden" name="portalTarget" value="${loginPortal!'admin'}">
                    <div class="campus-field-label">用户名</div>
                    <div class="campus-input-wrap">
                        <span class="campus-input-icon" aria-hidden="true"></span>
                        <input type="text" name="username" autocomplete="username" placeholder="账号">
                    </div>
                    <div class="campus-field-label">密码</div>
                    <div class="campus-input-wrap">
                        <span class="campus-input-icon" aria-hidden="true"></span>
                        <input type="password" name="password" autocomplete="current-password" placeholder="密码">
                    </div>
                    <label class="campus-checkbox-row"><input type="checkbox" name="remember-me"> 记住我</label>
                    <button type="submit" class="campus-primary-btn">登录后台</button>
                </form>
                <div class="campus-login-tips">
                    <p id="admin-account-hint">默认后台账号：merchant_north</p>
                    <p>备用后台账号：ops_admin</p>
                    <p>默认超级账号：platform_super</p>
                    <p>默认密码：123456</p>
                </div>
            </div>

            <div id="client-form" class="campus-login-form">
                <div class="campus-login-title">
                    <h2>手机快速登录</h2>
                    <p>登录后进入用户端首页，体验餐饮浏览、预约、自主报名和 AI 助手。</p>
                </div>
                <div class="campus-form-stack">
                    <div class="campus-field-label">手机号</div>
                    <div class="campus-input-wrap">
                        <span class="campus-input-icon" aria-hidden="true"></span>
                        <input id="client-phone" type="text" inputmode="numeric" value="18819530636" placeholder="手机号">
                    </div>
                    <div class="campus-field-label">验证码</div>
                    <div class="campus-inline-form">
                        <div class="campus-input-wrap">
                            <span class="campus-input-icon" aria-hidden="true"></span>
                            <input id="client-code" type="text" inputmode="numeric" placeholder="验证码">
                        </div>
                        <button id="send-code-btn" type="button" class="campus-light-btn">获取验证码</button>
                    </div>
                    <button id="client-login-btn" type="button" class="campus-primary-btn">进入用户端</button>
                </div>
                <div class="campus-login-tips">
                    <p>默认手机号：18819530636</p>
                    <p>验证码将输出到启动终端日志。</p>
                </div>
            </div>

            <div class="campus-login-desc">
                <span>统一认证 · 多端联动</span>
                <span>登录后进入对应业务首页</span>
            </div>

            <div id="login-notice" class="campus-login-notice" aria-live="polite"></div>
        </section>
    </div>
</div>

<script src="/static/vendor/axios/axios.min.js"></script>
<script>
    (function () {
        const adminForm = document.getElementById("admin-form");
        const clientForm = document.getElementById("client-form");
        const notice = document.getElementById("login-notice");
        const phoneInput = document.getElementById("client-phone");
        const codeInput = document.getElementById("client-code");
        const sendCodeButton = document.getElementById("send-code-btn");
        const clientLoginButton = document.getElementById("client-login-btn");
        const portalTargetInput = document.getElementById("portal-target-input");
        const initialPortal = document.body.dataset.loginPortal || "admin";
        let effectivePortal = initialPortal;
        const adminLoginTitle = document.getElementById("admin-login-title");
        const adminLoginDesc = document.getElementById("admin-login-desc");
        const adminAccountHint = document.getElementById("admin-account-hint");
        const loginEntryTitle = document.getElementById("login-entry-title");
        const loginEntrySubtitle = document.getElementById("login-entry-subtitle");
        const portTip = document.getElementById("port-tip");
        const demoPathTitle = document.getElementById("demo-path-title");
        const demoPathList = document.getElementById("demo-path-list");
        const portSwitchButtons = document.querySelectorAll("#port-switch-grid button");
        const bodyDataset = document.body.dataset || {};
        const currentPort = window.location.port || (window.location.protocol === "https:" ? "443" : "80");
        const currentHost = window.location.hostname || "127.0.0.1";
        const portalHosts = {
            admin: bodyDataset.adminHost || "127.0.0.1",
            client: bodyDataset.clientHost || "localhost",
            super: bodyDataset.superHost || "::1"
        };
        const portalPorts = {
            admin: bodyDataset.adminPort || "8091",
            client: bodyDataset.clientPort || "8092",
            super: bodyDataset.superPort || "8093"
        };
        const demoPaths = {
            admin: [
                "进入商家管理，新增一个商家并设置为已审核。",
                "在菜品与套餐里新增菜品，刷新后确认列表立即出现。",
                "切到活动与报表新增活动，再到审计日志查看记录。"
            ],
            client: [
                "选择商家并下单，完成支付方式选择与支付提交。",
                "进入预约模块选择座位并提交预约，确认状态变化。",
                "进入个人中心修改姓名/电话，再到 AI 问答验证新数据。"
            ],
            super: [
                "在学生端用户页新增或编辑账号，验证状态切换。",
                "在管理端账号页新增管理员并调整角色权限。",
                "回到总览查看联动统计，并在审计日志确认操作轨迹。"
            ]
        };

        function showNotice(message) {
            if (!message) {
                notice.textContent = "";
                notice.classList.remove("show");
                return;
            }
            notice.textContent = message;
            notice.classList.add("show");
        }

        function switchMode(mode) {
            const adminActive = mode === "admin";
            adminForm.classList.toggle("active", adminActive);
            clientForm.classList.toggle("active", !adminActive);
            if (portalTargetInput) {
                portalTargetInput.value = adminActive ? (effectivePortal === "super" ? "super" : "admin") : "client";
            }
        }

        function renderDemoPath(portal) {
            const target = portal === "super" ? "super" : (portal === "client" ? "client" : "admin");
            if (demoPathTitle) {
                demoPathTitle.textContent = (target === "client" ? "学生端" : (target === "super" ? "超级端" : "管理端")) + "黄金演示路径";
            }
            if (demoPathList) {
                demoPathList.innerHTML = (demoPaths[target] || []).map(function (item) {
                    return "<li>" + item + "</li>";
                }).join("");
            }
        }

        function applyPortContext() {
            if (currentPort === "8093") {
                effectivePortal = "super";
                if (loginEntryTitle) {
                    loginEntryTitle.textContent = "超级管理端登录入口";
                }
                if (loginEntrySubtitle) {
                    loginEntrySubtitle.textContent = "当前端口 8093，建议使用超级管理员账号登录。";
                }
            } else if (currentPort === "8092") {
                effectivePortal = "client";
                if (loginEntryTitle) {
                    loginEntryTitle.textContent = "学生用户端登录入口";
                }
                if (loginEntrySubtitle) {
                    loginEntrySubtitle.textContent = "当前端口 8092，建议使用手机号验证码登录。";
                }
            } else {
                effectivePortal = "admin";
                if (loginEntryTitle) {
                    loginEntryTitle.textContent = "后台管理端登录入口";
                }
                if (loginEntrySubtitle) {
                    loginEntrySubtitle.textContent = "当前端口 8091，建议使用后台管理账号登录。";
                }
            }

            if (portTip) {
                portTip.textContent = "当前访问：" + currentHost + ":" + currentPort + "（三端口已拆分为独立本地域名会话）";
            }
            renderDemoPath(effectivePortal);

            portSwitchButtons.forEach((button) => {
                const targetPort = button.dataset.port;
                const targetHost = button.dataset.host || currentHost;
                button.classList.toggle("active", targetPort === currentPort);
                button.addEventListener("click", function () {
                    const href = button.dataset.href || "/";
                    window.location.href = window.location.protocol + "//" + formatHost(targetHost) + ":" + targetPort + href;
                });
            });
        }

        function formatHost(value) {
            return value && value.includes(":") && !value.startsWith("[") ? "[" + value + "]" : value;
        }

        async function postJson(url, payload) {
            try {
                const response = await axios.post(url, payload, {
                    withCredentials: true,
                    headers: {
                        "Content-Type": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    }
                });
                return response.data;
            } catch (error) {
                const response = error && error.response ? error.response : null;
                const payloadData = response && response.data ? response.data : null;
                return {
                    success: false,
                    message: payloadData && payloadData.message ? payloadData.message : "请求失败，请稍后重试。",
                    data: payloadData && payloadData.data ? payloadData.data : null
                };
            }
        }

        async function sendCode() {
            const phone = phoneInput.value.trim();
            if (!phone) {
                showNotice("请先输入手机号。");
                return;
            }

            sendCodeButton.disabled = true;
            sendCodeButton.textContent = "发送中...";
            try {
                const data = await postJson("/api/auth/send-code", { phone: phone });
                if (!data.success) {
                    showNotice(data.message || "验证码发送失败，请稍后重试。");
                    return;
                }
                const demoCode = data.data && data.data.demoCode ? data.data.demoCode : "";
                codeInput.value = demoCode;
                showNotice("验证码已发送，请查看启动终端中的验证码。");
            } catch (error) {
                showNotice("验证码发送失败，请稍后重试。");
            } finally {
                sendCodeButton.disabled = false;
                sendCodeButton.textContent = "获取验证码";
            }
        }

        async function loginClient() {
            const phone = phoneInput.value.trim();
            const code = codeInput.value.trim();
            if (!phone || !code) {
                showNotice("请先填写手机号和验证码。");
                return;
            }

            clientLoginButton.disabled = true;
            clientLoginButton.textContent = "登录中...";
            try {
                const data = await postJson("/api/auth/login", { phone: phone, code: code });
                if (!data.success) {
                    showNotice(data.message || "登录失败，请稍后重试。");
                    return;
                }
                window.location.href = "/client";
            } catch (error) {
                showNotice("登录失败，请稍后重试。");
            } finally {
                clientLoginButton.disabled = false;
                clientLoginButton.textContent = "进入用户端";
            }
        }

        sendCodeButton.addEventListener("click", sendCode);
        clientLoginButton.addEventListener("click", loginClient);
        codeInput.addEventListener("keydown", function (event) {
            if (event.key === "Enter") {
                loginClient();
            }
        });

        const params = new URLSearchParams(window.location.search);
        applyPortContext();

        if (effectivePortal === "client" || params.has("client")) {
            switchMode("client");
        } else {
            switchMode("admin");
            if (effectivePortal === "super") {
                if (adminLoginTitle) {
                    adminLoginTitle.textContent = "超级管理端登录";
                }
                if (adminLoginDesc) {
                    adminLoginDesc.textContent = "账号、权限、审计与跨端联动治理从这里进入。";
                }
                if (adminAccountHint) {
                    adminAccountHint.textContent = "默认超级账号：platform_super";
                }
                showNotice("当前端口：8093（超级端）。登录后将进入超级端首页。");
            } else if (effectivePortal === "admin") {
                if (adminLoginTitle) {
                    adminLoginTitle.textContent = "后台管理登录";
                }
                if (adminLoginDesc) {
                    adminLoginDesc.textContent = "商家、自习室、活动、统计报表统一从这里进入。";
                }
                if (adminAccountHint) {
                    adminAccountHint.textContent = "默认后台账号：merchant_north";
                }
                showNotice("当前端口：8091（管理端）。登录后将进入后台首页。");
            }
        }
        if (params.has("error")) {
            switchMode("admin");
            showNotice(effectivePortal === "super" ? "超级端账号或密码错误，请重新登录。" : "后台账号或密码错误，请重新登录。");
        } else if (params.has("clientRequired")) {
            switchMode("client");
            showNotice("请先完成用户端登录。");
        } else if (params.has("logout")) {
            switchMode("admin");
            showNotice("你已安全退出后台。");
        }
    })();
</script>
</body>
</html>
