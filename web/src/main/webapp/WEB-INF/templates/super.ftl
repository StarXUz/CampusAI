<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>智慧校园生活服务平台 - 超级端</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/static/css/main.css">
</head>
<body class="campus-admin-body"
      data-super-page="${activeSuperPage!'overview'}"
      data-admin-host="${adminHost!'127.0.0.1'}"
      data-client-host="${clientHost!'localhost'}"
      data-super-host="${superHost!'::1'}"
      data-admin-port="${adminPort!'8091'}"
      data-client-port="${clientPort!'8092'}"
      data-super-port="${superPort!'8093'}">
<div class="campus-admin-layout">
    <header class="campus-admin-header campus-super-header">
        <div class="campus-admin-logo">
            <span class="campus-admin-logo-mark">Super</span>
            <span>智慧校园生活服务平台超级端</span>
        </div>
        <div class="campus-admin-userbar">
            <a href="${adminOverviewUrl!'http://127.0.0.1:8091/admin/overview'}" class="campus-admin-home">管理端</a>
            <a href="${clientHomeUrl!'http://localhost:8092/client'}" class="campus-admin-home">学生端</a>
            <a href="/logout" class="campus-admin-logout">退出</a>
        </div>
    </header>

    <div class="campus-admin-main">
        <aside class="campus-admin-sidebar">
            <a href="${superOverviewUrl!'http://[::1]:8093/super/overview'}" data-target="overview">联动总览</a>
            <a href="${superClientsUrl!'http://[::1]:8093/super/clients'}" data-target="clients">学生端用户</a>
            <a href="${superAdminsUrl!'http://[::1]:8093/super/admins'}" data-target="admins">管理端账号</a>
        </aside>

        <main class="campus-admin-content">
            <section class="campus-admin-breadcrumb">
                <h1 id="super-title">超级端总览</h1>
                <p id="super-desc">统一管理学生端与管理端账号，修改后可直接联动到登录和业务权限。</p>
            </section>

            <section id="super-panel-overview" class="admin-panel active-panel">
                <div class="admin-toolbar">
                    <button id="refresh-super-overview" class="campus-light-btn" type="button">刷新联动总览</button>
                    <a class="campus-link-btn inline" href="${adminLoginUrl!'http://127.0.0.1:8091/login/admin'}">回到统一登录页</a>
                </div>
                <div class="campus-admin-panel-grid">
                    <article class="campus-admin-panel">
                        <h2>学生端用户总数</h2>
                        <div id="super-client-count" class="super-big-number">0</div>
                    </article>
                    <article class="campus-admin-panel">
                        <h2>管理端账号总数</h2>
                        <div id="super-admin-count" class="super-big-number">0</div>
                    </article>
                    <article class="campus-admin-panel wide">
                        <h2>联动说明</h2>
                        <div class="campus-info-banner">
                            <strong>和其他端口直接联动</strong>
                            <span>这里新增或修改学生账号后，学生端手机号登录与个人资料会同步变化；这里新增或修改管理端账号后，管理端和超级端权限会立即受影响。</span>
                        </div>
                        <div class="super-link-grid">
                            <a class="campus-link-btn" href="${superClientsUrl!'http://[::1]:8093/super/clients'}" data-target="clients">进入学生端用户管理</a>
                            <a class="campus-link-btn" href="${superAdminsUrl!'http://[::1]:8093/super/admins'}" data-target="admins">进入管理端账号管理</a>
                        </div>
                    </article>
                </div>
                <div class="campus-admin-panel-grid campus-top-gap">
                    <article class="campus-admin-panel">
                        <h2>共享业务数据总览</h2>
                        <div id="super-shared-summary" class="campus-list-stack"></div>
                    </article>
                    <article class="campus-admin-panel wide">
                        <h2>跨端同步记录（实时）</h2>
                        <p class="campus-inline-tip">以下记录来自与学生端、管理端共用的数据库表，刷新后即可看到最新变更。</p>
                        <div class="campus-section-head campus-subsection-head">
                            <h3>最近订单</h3>
                        </div>
                        <table class="campus-table campus-table--overview">
                            <thead>
                            <tr><th>ID</th><th>商家</th><th>商品</th><th>金额</th><th>状态</th></tr>
                            </thead>
                            <tbody id="super-latest-orders"></tbody>
                        </table>
                        <div class="campus-section-head campus-subsection-head">
                            <h3>最近预约</h3>
                        </div>
                        <table class="campus-table campus-table--overview">
                            <thead>
                            <tr><th>ID</th><th>自习室</th><th>座位</th><th>日期</th><th>时段</th></tr>
                            </thead>
                            <tbody id="super-latest-reservations"></tbody>
                        </table>
                        <div class="campus-section-head campus-subsection-head">
                            <h3>最新商家与活动</h3>
                        </div>
                        <div class="campus-desk-layout super-shared-dual">
                            <div>
                                <div class="campus-panel-title">最新商家</div>
                                <div id="super-latest-merchants" class="campus-list-stack"></div>
                            </div>
                            <div>
                                <div class="campus-panel-title">最新活动</div>
                                <div id="super-latest-activities" class="campus-list-stack"></div>
                            </div>
                        </div>
                        <div class="campus-section-head campus-subsection-head super-audit-head">
                            <h3>超级端操作审计日志</h3>
                            <div class="admin-inline-actions super-audit-actions">
                                <input id="audit-operator-filter" class="admin-mini-input" type="text" placeholder="操作人">
                                <select id="audit-optype-filter" class="admin-mini-input">
                                    <option value="">全部操作</option>
                                    <option value="CREATE_USER">CREATE_USER</option>
                                    <option value="UPDATE_USER">UPDATE_USER</option>
                                    <option value="DELETE_USER">DELETE_USER</option>
                                    <option value="IMPORT_USER">IMPORT_USER</option>
                                </select>
                                <select id="audit-result-filter" class="admin-mini-input">
                                    <option value="">全部结果</option>
                                    <option value="SUCCESS">SUCCESS</option>
                                    <option value="FAIL">FAIL</option>
                                </select>
                                <input id="audit-start-filter" class="admin-mini-input" type="datetime-local">
                                <input id="audit-end-filter" class="admin-mini-input" type="datetime-local">
                                <button id="search-audit-logs" class="campus-light-btn" type="button">筛选日志</button>
                                <button id="reset-audit-logs" class="campus-light-btn" type="button">重置</button>
                                <button id="export-audit-logs" class="campus-light-btn" type="button">导出日志</button>
                                <select id="audit-trend-days" class="admin-mini-input">
                                    <option value="7">近7天</option>
                                    <option value="15">近15天</option>
                                    <option value="30">近30天</option>
                                </select>
                                <button id="refresh-audit-trend" class="campus-light-btn" type="button">刷新趋势</button>
                            </div>
                        </div>
                        <div id="super-audit-trend" class="campus-list-stack"></div>
                        <div class="campus-table-scroll">
                            <table class="campus-table campus-table--audit">
                                <thead>
                            <tr><th>ID</th><th>操作</th><th>目标账号</th><th>角色</th><th>结果</th><th>说明</th><th>操作人</th><th>时间</th></tr>
                                </thead>
                                <tbody id="super-audit-logs"></tbody>
                            </table>
                        </div>
                        <div class="admin-inline-actions admin-pagination">
                            <button id="audit-prev-page" class="campus-light-btn" type="button">上一页</button>
                            <span id="audit-page-text" class="campus-inline-tip">第 1 页</span>
                            <button id="audit-next-page" class="campus-light-btn" type="button">下一页</button>
                        </div>
                    </article>
                </div>
            </section>

            <section id="super-panel-clients" class="admin-panel" hidden>
                <div class="admin-split">
                    <div class="campus-admin-panel">
                        <div class="campus-section-head super-list-head">
                            <h2>学生端用户列表</h2>
                            <div class="admin-inline-actions">
                                <input id="client-keyword" class="admin-mini-input" type="text" placeholder="搜索用户名或手机号">
                                <button id="search-clients" class="campus-light-btn" type="button">查询</button>
                                <button id="open-client-user-modal" class="campus-primary-btn" type="button">新增学生用户</button>
                                <button id="batch-enable-clients" class="campus-light-btn" type="button">批量启用</button>
                                <button id="batch-disable-clients" class="campus-light-btn" type="button">批量停用</button>
                                <button id="batch-delete-clients" class="campus-light-btn danger-lite" type="button">批量删除</button>
                            </div>
                        </div>
                        <div class="campus-table-scroll">
                            <table class="campus-table campus-table--users">
                                <thead>
                                <tr><th><input id="select-all-clients" type="checkbox"></th><th>ID</th><th>用户名</th><th>手机号</th><th>状态</th><th>操作</th></tr>
                                </thead>
                                <tbody id="client-table-body"></tbody>
                            </table>
                        </div>
                        <div id="client-sync-banner" class="campus-info-banner"></div>
                        <div id="client-preview-grid" class="admin-preview-grid"></div>
                        <div class="admin-feedback admin-feedback-compact" data-feedback-for="client-feedback"></div>
                    </div>
                    <div id="client-form-panel" class="campus-admin-panel">
                        <div class="campus-section-head">
                            <h2 id="client-form-title">新增学生端用户</h2>
                            <button id="cancel-client-edit" class="campus-light-btn" type="button" hidden>取消编辑</button>
                        </div>
                        <div class="admin-form-grid">
                            <label class="admin-field">
                                <span>用户名</span>
                                <input id="client-username-input" type="text" placeholder="例如：student_demo">
                            </label>
                            <label class="admin-field">
                                <span>手机号</span>
                                <input id="client-phone-input" type="text" placeholder="例如：18819530636">
                            </label>
                            <label class="admin-field">
                                <span>密码</span>
                                <input id="client-password-input" type="text" placeholder="新增必填，编辑时可留空">
                            </label>
                            <label class="admin-field">
                                <span>头像地址</span>
                                <input id="client-avatar-input" type="text" value="/static/img/user.svg">
                            </label>
                            <label class="admin-field">
                                <span>状态</span>
                                <select id="client-enabled-input">
                                    <option value="true">启用</option>
                                    <option value="false">停用</option>
                                </select>
                            </label>
                        </div>
                        <div class="admin-action-row">
                            <button id="save-client-user" class="campus-primary-btn" type="button">新增学生用户</button>
                        </div>
                        <div id="client-feedback" class="admin-feedback"></div>
                        <div class="campus-info-banner campus-top-gap">
                            <strong>批量导入学生账号</strong>
                            <span>下载模板后填写账号信息，支持新增与按手机号更新。</span>
                        </div>
                        <div class="admin-inline-actions">
                            <a class="campus-link-btn inline" href="/api/super/users/template">下载导入模板</a>
                            <input id="import-clients-file" type="file" accept=".xlsx,.xls">
                            <button id="import-clients-btn" class="campus-light-btn" type="button">导入学生账号</button>
                        </div>
                    </div>
                </div>
            </section>

            <section id="super-panel-admins" class="admin-panel" hidden>
                <div class="admin-split">
                    <div class="campus-admin-panel">
                        <div class="campus-section-head super-list-head">
                            <h2>管理端账号列表</h2>
                            <div class="admin-inline-actions">
                                <input id="admin-keyword-super" class="admin-mini-input" type="text" placeholder="搜索管理员或手机号">
                                <button id="search-admins" class="campus-light-btn" type="button">查询</button>
                                <button id="open-admin-user-modal" class="campus-primary-btn" type="button">新增管理账号</button>
                                <button id="batch-enable-admins" class="campus-light-btn" type="button">批量启用</button>
                                <button id="batch-disable-admins" class="campus-light-btn" type="button">批量停用</button>
                                <button id="batch-delete-admins" class="campus-light-btn danger-lite" type="button">批量删除</button>
                            </div>
                        </div>
                        <div class="campus-table-scroll">
                            <table class="campus-table campus-table--users">
                                <thead>
                                <tr><th><input id="select-all-admins" type="checkbox"></th><th>ID</th><th>用户名</th><th>手机号</th><th>角色</th><th>操作</th></tr>
                                </thead>
                                <tbody id="admin-user-table-body"></tbody>
                            </table>
                        </div>
                        <div id="admin-sync-banner" class="campus-info-banner"></div>
                        <div id="admin-preview-grid" class="admin-preview-grid"></div>
                        <div class="admin-feedback admin-feedback-compact" data-feedback-for="admin-user-feedback"></div>
                    </div>
                    <div id="admin-user-form-panel" class="campus-admin-panel">
                        <div class="campus-section-head">
                            <h2 id="admin-user-form-title">新增管理端账号</h2>
                            <button id="cancel-admin-user-edit" class="campus-light-btn" type="button" hidden>取消编辑</button>
                        </div>
                        <div class="admin-form-grid">
                            <label class="admin-field">
                                <span>用户名</span>
                                <input id="admin-user-username-input" type="text" placeholder="例如：admin_demo">
                            </label>
                            <label class="admin-field">
                                <span>手机号</span>
                                <input id="admin-user-phone-input" type="text" placeholder="例如：13900001234">
                            </label>
                            <label class="admin-field">
                                <span>密码</span>
                                <input id="admin-user-password-input" type="text" placeholder="新增必填，编辑时可留空">
                            </label>
                            <label class="admin-field">
                                <span>角色</span>
                                <select id="admin-user-role-input">
                                    <option value="ROLE_MERCHANT_ADMIN">管理端管理员</option>
                                    <option value="ROLE_SUPER_ADMIN">超级管理员</option>
                                </select>
                            </label>
                            <label class="admin-field">
                                <span>头像地址</span>
                                <input id="admin-user-avatar-input" type="text" value="/static/img/admin.svg">
                            </label>
                            <label class="admin-field">
                                <span>状态</span>
                                <select id="admin-user-enabled-input">
                                    <option value="true">启用</option>
                                    <option value="false">停用</option>
                                </select>
                            </label>
                        </div>
                        <div class="admin-action-row">
                            <button id="save-admin-user" class="campus-primary-btn" type="button">新增管理账号</button>
                        </div>
                        <div id="admin-user-feedback" class="admin-feedback"></div>
                        <div class="campus-info-banner campus-top-gap">
                            <strong>批量导入管理账号</strong>
                            <span>下载模板后填写账号信息，导入时默认角色为管理端管理员。</span>
                        </div>
                        <div class="admin-inline-actions">
                            <a class="campus-link-btn inline" href="/api/super/users/template">下载导入模板</a>
                            <input id="import-admins-file" type="file" accept=".xlsx,.xls">
                            <button id="import-admins-btn" class="campus-light-btn" type="button">导入管理账号</button>
                        </div>
                    </div>
                </div>
            </section>
        </main>
    </div>
</div>

<script src="/static/vendor/axios/axios.min.js"></script>
<script>
    (function () {
        const bodyDataset = document.body.dataset || {};
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
        const sectionMeta = {
            overview: {
                title: "超级端总览",
                desc: "统一查看学生端和管理端账号规模，并实时感知跨端共享数据变化。"
            },
            clients: {
                title: "学生端用户管理",
                desc: "这里的增删改查会直接影响学生端手机号登录、个人资料和业务入口。"
            },
            admins: {
                title: "管理端账号管理",
                desc: "这里管理后台管理员和超级管理员账号，修改后会直接影响管理端与超级端访问权限。"
            }
        };

        const state = {
            editingClientId: null,
            editingAdminId: null,
            clientUsers: [],
            adminUsers: [],
            selectedClientIds: [],
            selectedAdminIds: [],
            auditPageNum: 1,
            auditPageSize: 20,
            auditTotal: 0
        };

        function escapeHtml(value) {
            return String(value == null ? "" : value)
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#39;");
        }

        function showFeedback(id, message, success) {
            const element = document.getElementById(id);
            const mirrors = document.querySelectorAll("[data-feedback-for='" + id + "']");
            [element].concat(Array.from(mirrors)).forEach((target) => {
                if (!target) {
                    return;
                }
                target.textContent = message || "";
                target.classList.toggle("is-success", Boolean(success));
                target.classList.toggle("is-error", success === false);
            });
        }

        const modalRegistry = {};

        function syncModalBodyState() {
            const hasOpenModal = Boolean(document.querySelector(".campus-modal-shell.is-open"));
            document.body.classList.toggle("campus-modal-open", hasOpenModal);
        }

        function createModalShell(modalId, panel) {
            const shell = document.createElement("div");
            shell.id = modalId;
            shell.className = "campus-modal-shell";
            shell.hidden = true;

            const backdrop = document.createElement("div");
            backdrop.className = "campus-modal-backdrop";
            backdrop.dataset.modalClose = modalId;

            const dialog = document.createElement("div");
            dialog.className = "campus-modal-dialog";

            const closeButton = document.createElement("button");
            closeButton.type = "button";
            closeButton.className = "campus-modal-close";
            closeButton.dataset.modalClose = modalId;
            closeButton.setAttribute("aria-label", "关闭弹窗");
            closeButton.textContent = "×";

            panel.classList.add("campus-modal-panel");
            dialog.appendChild(closeButton);
            dialog.appendChild(panel);
            shell.appendChild(backdrop);
            shell.appendChild(dialog);
            document.body.appendChild(shell);
            return shell;
        }

        function registerPanelModal(config) {
            const panel = document.getElementById(config.panelId);
            if (!panel) {
                return;
            }
            const shell = createModalShell(config.modalId, panel);
            modalRegistry[config.modalId] = {
                shell: shell,
                reset: config.reset || null
            };
            (config.triggerIds || []).forEach((triggerId) => {
                const trigger = document.getElementById(triggerId);
                if (!trigger) {
                    return;
                }
                trigger.addEventListener("click", function () {
                    if (typeof config.beforeOpen === "function") {
                        config.beforeOpen();
                    }
                    openModal(config.modalId);
                });
            });
        }

        function openModal(modalId) {
            const entry = modalRegistry[modalId];
            if (!entry) {
                return;
            }
            document.querySelectorAll(".campus-modal-shell.is-open").forEach((shell) => {
                if (shell.id !== modalId) {
                    closeModal(shell.id);
                }
            });
            entry.shell.hidden = false;
            entry.shell.classList.add("is-open");
            syncModalBodyState();
        }

        function closeModal(modalId, resetForm) {
            const entry = modalRegistry[modalId];
            if (!entry) {
                return;
            }
            entry.shell.classList.remove("is-open");
            entry.shell.hidden = true;
            if (resetForm !== false && typeof entry.reset === "function") {
                entry.reset();
            }
            syncModalBodyState();
        }

        function bindModalDismiss() {
            document.addEventListener("click", function (event) {
                const closeTrigger = event.target.closest("[data-modal-close]");
                if (!closeTrigger) {
                    return;
                }
                closeModal(closeTrigger.dataset.modalClose);
            });
            document.addEventListener("keydown", function (event) {
                if (event.key !== "Escape") {
                    return;
                }
                const openShells = Array.from(document.querySelectorAll(".campus-modal-shell.is-open"));
                const latest = openShells.length ? openShells[openShells.length - 1] : null;
                if (latest) {
                    closeModal(latest.id);
                }
            });
        }

        function roleCodeOf(user) {
            const roles = user && Array.isArray(user.roles) ? user.roles : [];
            return (roles[0] && roles[0].code) || "ROLE_MERCHANT_ADMIN";
        }

        function isValidMobile(phone) {
            return /^1\d{10}$/.test(String(phone || ""));
        }

        function validateUserForm(username, phone, feedbackId) {
            if (!username) {
                showFeedback(feedbackId, "用户名不能为空。", false);
                return false;
            }
            if (!phone) {
                showFeedback(feedbackId, "手机号不能为空。", false);
                return false;
            }
            if (!isValidMobile(phone)) {
                showFeedback(feedbackId, "手机号格式不正确，应为 11 位手机号。", false);
                return false;
            }
            return true;
        }

        function normalizeApiErrorMessage(message, statusCode) {
            const raw = String(message || "");
            if (statusCode === 401) {
                return "登录状态已失效，请重新登录后再试。";
            }
            if (statusCode === 403) {
                return "你没有当前操作权限，请联系系统管理员。";
            }
            if (raw.indexOf("Request method") >= 0 && raw.indexOf("not supported") >= 0) {
                return "请求方式不匹配，请刷新页面后重试当前操作。";
            }
            if (statusCode >= 500 || raw.indexOf("系统异常") >= 0) {
                return "服务暂时不可用，请稍后重试。";
            }
            return raw || ("请求失败（HTTP " + statusCode + "）");
        }

        function buildAxiosConfig(url, options) {
            const config = Object.assign({
                url: url,
                withCredentials: true,
                headers: {
                    "X-Requested-With": "XMLHttpRequest"
                }
            }, options || {});
            if (Object.prototype.hasOwnProperty.call(config, "body")) {
                config.data = config.body;
                delete config.body;
            }
            return config;
        }

        function resolveAxiosError(error) {
            const response = error && error.response ? error.response : null;
            if (response) {
                const headers = response.headers || {};
                const traceId = headers["x-request-id"] || headers["X-Request-Id"];
                const payload = response.data || {};
                const msg = normalizeApiErrorMessage(payload.message, response.status);
                return traceId ? (msg + " [追踪ID: " + traceId + "]") : msg;
            }
            if (error instanceof Error && error.message) {
                return error.message;
            }
            return "网络异常，请检查服务是否已启动或连接是否正常。";
        }

        async function requestJson(url, options) {
            try {
                const response = await axios(buildAxiosConfig(url, options));
                const data = response.data;
                if (!data) {
                    throw new Error("接口返回为空");
                }
                if (data.success === false) {
                    throw new Error(normalizeApiErrorMessage(data.message, response.status));
                }
                return data;
            } catch (error) {
                throw new Error(resolveAxiosError(error));
            }
        }

        async function runGuarded(actionKey, buttonId, busyText, fn, feedbackId) {
            if (state[actionKey]) {
                return;
            }
            state[actionKey] = true;
            const button = buttonId ? document.getElementById(buttonId) : null;
            const originalText = button ? button.textContent : "";
            if (button) {
                button.disabled = true;
                if (busyText) {
                    button.textContent = busyText;
                }
            }
            try {
                await fn();
            } catch (error) {
                if (feedbackId) {
                    showFeedback(feedbackId, error.message || "操作失败", false);
                }
            } finally {
                if (button) {
                    button.disabled = false;
                    button.textContent = originalText;
                }
                state[actionKey] = false;
            }
        }

        function switchSection(target) {
            document.querySelectorAll(".campus-admin-sidebar [data-target]").forEach((item) => {
                item.classList.toggle("active", item.dataset.target === target);
            });
            document.querySelectorAll("[id^='super-panel-']").forEach((panel) => {
                panel.hidden = panel.id !== "super-panel-" + target;
            });
            document.getElementById("super-title").textContent = sectionMeta[target].title;
            document.getElementById("super-desc").textContent = sectionMeta[target].desc;
        }

        function formatHostForUrl(host) {
            const resolvedHost = String(host || "127.0.0.1").trim();
            return resolvedHost.indexOf(":") >= 0 && resolvedHost.charAt(0) !== "[" ? ("[" + resolvedHost + "]") : resolvedHost;
        }

        function buildPortalUrl(portal, path) {
            const resolvedPortal = portal === "super" ? "super" : (portal === "client" ? "client" : "admin");
            const protocol = window.location.protocol || "http:";
            return protocol + "//" + formatHostForUrl(portalHosts[resolvedPortal]) + ":" + portalPorts[resolvedPortal] + path;
        }

        function bindSuperNavigation() {
            document.querySelectorAll("[data-target]").forEach((item) => {
                item.addEventListener("click", function (event) {
                    const target = item.dataset.target;
                    if (!sectionMeta[target]) {
                        return;
                    }
                    event.preventDefault();
                    switchSection(target);
                    const nextUrl = buildPortalUrl("super", "/super/" + target);
                    if (window.location.href !== nextUrl) {
                        window.history.pushState({ target: target }, "", nextUrl);
                    }
                });
            });

            window.addEventListener("popstate", function () {
                const path = window.location.pathname || "";
                const matched = path.match(/^\/super\/([^/?#]+)/);
                const target = matched && sectionMeta[matched[1]] ? matched[1] : "overview";
                switchSection(target);
            });
        }

        function fmtDateTime(value) {
            if (!value) {
                return "-";
            }
            if (Array.isArray(value)) {
                const parts = value.slice(0, 5).map((item) => String(item).padStart(2, "0"));
                return parts[0] + "-" + parts[1] + "-" + parts[2] + " " + parts[3] + ":" + parts[4];
            }
            return String(value).replace("T", " ").slice(0, 16);
        }

        function normalizeDateTimeLocal(value) {
            if (!value) {
                return "";
            }
            return String(value).replace("T", " ") + ":00";
        }

        function getAuditFilterQuery() {
            const query = new URLSearchParams();
            const operationType = document.getElementById("audit-optype-filter").value;
            const operatorName = document.getElementById("audit-operator-filter").value.trim();
            const actionResult = document.getElementById("audit-result-filter").value;
            const startTime = normalizeDateTimeLocal(document.getElementById("audit-start-filter").value);
            const endTime = normalizeDateTimeLocal(document.getElementById("audit-end-filter").value);
            if (operationType) {
                query.set("operationType", operationType);
            }
            if (operatorName) {
                query.set("operatorName", operatorName);
            }
            if (actionResult) {
                query.set("actionResult", actionResult);
            }
            if (startTime) {
                query.set("startTime", startTime);
            }
            if (endTime) {
                query.set("endTime", endTime);
            }
            return query;
        }

        function fmtDate(value) {
            if (!value) {
                return "-";
            }
            return String(value).slice(0, 10);
        }

        function fmtTime(value) {
            if (!value) {
                return "-";
            }
            return String(value).slice(0, 5);
        }

        function renderSharedData(sharedData) {
            const summary = sharedData && sharedData.summary ? sharedData.summary : {};
            const summaryHost = document.getElementById("super-shared-summary");
            if (summaryHost) {
                summaryHost.innerHTML = [
                    { label: "商家总数", value: summary.merchantCount || 0 },
                    { label: "菜品总数", value: summary.dishCount || 0 },
                    { label: "套餐总数", value: summary.packageCount || 0 },
                    { label: "活动总数", value: summary.activityCount || 0 },
                    { label: "自习室总数", value: summary.studyRoomCount || 0 },
                    { label: "今日订单", value: summary.todayOrderCount || 0 },
                    { label: "今日预约", value: summary.todayReservationCount || 0 },
                    { label: "已支付订单", value: summary.paidOrderCount || 0 }
                ].map((item) => {
                    return "<div class='campus-list-card compact'><strong>" + escapeHtml(item.label) + "</strong><p>" + escapeHtml(item.value) + "</p></div>";
                }).join("");
            }

            const latestOrders = sharedData && Array.isArray(sharedData.latestOrders) ? sharedData.latestOrders : [];
            document.getElementById("super-latest-orders").innerHTML = latestOrders.length
                ? latestOrders.map((item) => {
                    return "<tr>"
                        + "<td>" + escapeHtml(item.id) + "</td>"
                        + "<td>" + escapeHtml(item.merchantName || "-") + "</td>"
                        + "<td>" + escapeHtml(item.itemName || "-") + "</td>"
                        + "<td>￥" + escapeHtml(item.totalAmount || 0) + "</td>"
                        + "<td>" + escapeHtml(item.status || "-") + "</td>"
                        + "</tr>";
                }).join("")
                : "<tr><td colspan='5' class='admin-empty'>暂无订单数据</td></tr>";

            const latestReservations = sharedData && Array.isArray(sharedData.latestReservations) ? sharedData.latestReservations : [];
            document.getElementById("super-latest-reservations").innerHTML = latestReservations.length
                ? latestReservations.map((item) => {
                    return "<tr>"
                        + "<td>" + escapeHtml(item.id) + "</td>"
                        + "<td>" + escapeHtml(item.studyRoomName || "-") + "</td>"
                        + "<td>" + escapeHtml(item.seatCode || "-") + "</td>"
                        + "<td>" + escapeHtml(fmtDate(item.reservationDate)) + "</td>"
                        + "<td>" + escapeHtml(fmtTime(item.startTime)) + "-" + escapeHtml(fmtTime(item.endTime)) + "</td>"
                        + "</tr>";
                }).join("")
                : "<tr><td colspan='5' class='admin-empty'>暂无预约数据</td></tr>";

            const latestMerchants = sharedData && Array.isArray(sharedData.latestMerchants) ? sharedData.latestMerchants : [];
            document.getElementById("super-latest-merchants").innerHTML = latestMerchants.length
                ? latestMerchants.map((item) => {
                    return "<div class='campus-list-card compact'>"
                        + "<strong>" + escapeHtml(item.name || "-") + "</strong>"
                        + "<p>" + escapeHtml(item.canteenName || "未设置食堂区域") + "</p>"
                        + "<span class='campus-card-meta'>状态：" + escapeHtml(item.auditStatus || "PENDING") + "</span></div>";
                }).join("")
                : "<div class='campus-empty-card'>暂无商家数据</div>";

            const latestActivities = sharedData && Array.isArray(sharedData.latestActivities) ? sharedData.latestActivities : [];
            document.getElementById("super-latest-activities").innerHTML = latestActivities.length
                ? latestActivities.map((item) => {
                    return "<div class='campus-list-card compact'>"
                        + "<strong>" + escapeHtml(item.title || "-") + "</strong>"
                        + "<p>" + escapeHtml(item.location || "未设置地点") + "</p>"
                        + "<span class='campus-card-meta'>" + escapeHtml(item.status || "OPEN") + " / " + escapeHtml(fmtDateTime(item.startTime)) + "</span></div>";
                }).join("")
                : "<div class='campus-empty-card'>暂无活动数据</div>";

            const latestAuditLogs = sharedData && Array.isArray(sharedData.latestAuditLogs) ? sharedData.latestAuditLogs : [];
            renderAuditLogs(latestAuditLogs);
        }

        function renderAuditLogs(rows) {
            document.getElementById("super-audit-logs").innerHTML = rows && rows.length
                ? rows.map((item) => {
                    return "<tr>"
                        + "<td>" + escapeHtml(item.id) + "</td>"
                        + "<td>" + escapeHtml(item.operationType || "-") + "</td>"
                        + "<td>" + escapeHtml(item.targetUsername || "-") + "</td>"
                        + "<td>" + escapeHtml(item.roleCode || "-") + "</td>"
                        + "<td>" + escapeHtml(item.actionResult || "-") + "</td>"
                        + "<td>" + escapeHtml(item.detail || "-") + "</td>"
                        + "<td>" + escapeHtml(item.operatorName || "-") + "</td>"
                        + "<td>" + escapeHtml(fmtDateTime(item.createdAt)) + "</td>"
                        + "</tr>";
                }).join("")
                : "<tr><td colspan='8' class='admin-empty'>暂无审计日志</td></tr>";
        }

        function renderAuditTrend(rows) {
            const host = document.getElementById("super-audit-trend");
            if (!host) {
                return;
            }
            host.innerHTML = rows && rows.length
                ? rows.map((item) => {
                    return "<div class='campus-list-card compact'>"
                        + "<strong>" + escapeHtml(item.day) + "</strong>"
                        + "<p>新增 " + escapeHtml(item.createCount || 0)
                        + " / 修改 " + escapeHtml(item.updateCount || 0)
                        + " / 删除 " + escapeHtml(item.deleteCount || 0)
                        + " / 导入 " + escapeHtml(item.importCount || 0)
                        + " / 总计 " + escapeHtml(item.totalCount || 0) + "</p>"
                        + "</div>";
                }).join("")
                : "<div class='campus-empty-card'>最近暂无审计趋势数据。</div>";
        }

        async function loadOverview() {
            const result = await requestJson("/api/super/overview");
            document.getElementById("super-client-count").textContent = result.data.clientUsers;
            document.getElementById("super-admin-count").textContent = result.data.adminUsers;
            renderSharedData(result.data.sharedData || {});
            const trendRows = result.data.sharedData && Array.isArray(result.data.sharedData.auditTrend) ? result.data.sharedData.auditTrend : [];
            renderAuditTrend(trendRows);
            await loadAuditLogsByFilter();
        }

        async function loadAuditLogsByFilter() {
            const query = getAuditFilterQuery();
            const payload = {
                pageNum: state.auditPageNum,
                pageSize: state.auditPageSize,
                operationType: query.get("operationType") || "",
                operatorName: query.get("operatorName") || "",
                actionResult: query.get("actionResult") || "",
                startTime: query.get("startTime") || "",
                endTime: query.get("endTime") || ""
            };
            const result = await requestJson("/api/super/audit-logs/page", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest"
                },
                body: JSON.stringify(payload)
            });
            const pageData = result.data || {};
            state.auditTotal = Number(pageData.total || 0);
            renderAuditLogs(pageData.records || []);
            const totalPage = Math.max(1, Math.ceil(state.auditTotal / state.auditPageSize));
            document.getElementById("audit-page-text").textContent = "第 " + state.auditPageNum + " / " + totalPage + " 页（共 " + state.auditTotal + " 条）";
            document.getElementById("audit-prev-page").disabled = state.auditPageNum <= 1;
            document.getElementById("audit-next-page").disabled = state.auditPageNum >= totalPage;
        }

        async function loadAuditTrendByDays() {
            const days = Number(document.getElementById("audit-trend-days").value || 7);
            const result = await requestJson("/api/super/audit-trend?days=" + days);
            renderAuditTrend(result.data || []);
        }

        function roleLabel(user) {
            return (user.roles || []).map((role) => role.name || role.code).join(" / ");
        }

        function renderClientSyncSummary() {
            const enabledCount = state.clientUsers.filter((item) => item.enabled).length;
            document.getElementById("client-sync-banner").innerHTML = state.clientUsers.length
                ? "<strong>学生端账号联动</strong><span>当前共维护 " + escapeHtml(state.clientUsers.length) + " 个学生账号，其中启用 " + escapeHtml(enabledCount) + " 个。这里修改后的用户名、手机号和头像会直接同步到学生端登录和个人资料页。</span>"
                : "当前还没有学生端账号。";
            document.getElementById("client-preview-grid").innerHTML = state.clientUsers.slice(0, 6).map((user) => {
                return "<article class='campus-merchant-preview-card admin-merchant-card'>"
                    + "<img src='" + escapeHtml(user.avatarUrl || "/static/img/user.svg") + "' alt='" + escapeHtml(user.username) + "'>"
                    + "<div><strong>" + escapeHtml(user.username) + "</strong>"
                    + "<p>" + escapeHtml(user.phone || "未设置手机号") + "</p>"
                    + "<span>" + escapeHtml(user.enabled ? "启用中" : "已停用") + "</span></div>"
                    + "</article>";
            }).join("");
        }

        function renderAdminSyncSummary() {
            const superCount = state.adminUsers.filter((user) => (user.roles || []).some((role) => role.code === "ROLE_SUPER_ADMIN")).length;
            document.getElementById("admin-sync-banner").innerHTML = state.adminUsers.length
                ? "<strong>管理端账号联动</strong><span>当前共维护 " + escapeHtml(state.adminUsers.length) + " 个后台账号，其中超级管理员 " + escapeHtml(superCount) + " 个。这里修改角色后，会立即影响登录后的跳转页面和后台访问权限。</span>"
                : "当前还没有管理端账号。";
            document.getElementById("admin-preview-grid").innerHTML = state.adminUsers.slice(0, 6).map((user) => {
                return "<article class='campus-merchant-preview-card admin-merchant-card'>"
                    + "<img src='" + escapeHtml(user.avatarUrl || "/static/img/admin.svg") + "' alt='" + escapeHtml(user.username) + "'>"
                    + "<div><strong>" + escapeHtml(user.username) + "</strong>"
                    + "<p>" + escapeHtml(user.phone || "未设置手机号") + "</p>"
                    + "<span>" + escapeHtml(roleLabel(user) || "未分配角色") + "</span></div>"
                    + "</article>";
            }).join("");
        }

        function resetClientForm() {
            state.editingClientId = null;
            document.getElementById("client-form-title").textContent = "新增学生端用户";
            document.getElementById("save-client-user").textContent = "新增学生用户";
            document.getElementById("cancel-client-edit").hidden = true;
            document.getElementById("client-username-input").value = "";
            document.getElementById("client-phone-input").value = "";
            document.getElementById("client-password-input").value = "";
            document.getElementById("client-avatar-input").value = "/static/img/user.svg";
            document.getElementById("client-enabled-input").value = "true";
        }

        function fillClientForm(user) {
            state.editingClientId = user.id;
            document.getElementById("client-form-title").textContent = "编辑学生端用户";
            document.getElementById("save-client-user").textContent = "更新学生用户";
            document.getElementById("cancel-client-edit").hidden = false;
            document.getElementById("client-username-input").value = user.username || "";
            document.getElementById("client-phone-input").value = user.phone || "";
            document.getElementById("client-password-input").value = "";
            document.getElementById("client-avatar-input").value = user.avatarUrl || "/static/img/user.svg";
            document.getElementById("client-enabled-input").value = String(Boolean(user.enabled));
            openModal("client-user-modal");
        }

        function resetAdminForm() {
            state.editingAdminId = null;
            document.getElementById("admin-user-form-title").textContent = "新增管理端账号";
            document.getElementById("save-admin-user").textContent = "新增管理账号";
            document.getElementById("cancel-admin-user-edit").hidden = true;
            document.getElementById("admin-user-username-input").value = "";
            document.getElementById("admin-user-phone-input").value = "";
            document.getElementById("admin-user-password-input").value = "";
            document.getElementById("admin-user-role-input").value = "ROLE_MERCHANT_ADMIN";
            document.getElementById("admin-user-avatar-input").value = "/static/img/admin.svg";
            document.getElementById("admin-user-enabled-input").value = "true";
        }

        function fillAdminForm(user) {
            state.editingAdminId = user.id;
            document.getElementById("admin-user-form-title").textContent = "编辑管理端账号";
            document.getElementById("save-admin-user").textContent = "更新管理账号";
            document.getElementById("cancel-admin-user-edit").hidden = false;
            document.getElementById("admin-user-username-input").value = user.username || "";
            document.getElementById("admin-user-phone-input").value = user.phone || "";
            document.getElementById("admin-user-password-input").value = "";
            document.getElementById("admin-user-role-input").value = ((user.roles || [])[0] || {}).code || "ROLE_MERCHANT_ADMIN";
            document.getElementById("admin-user-avatar-input").value = user.avatarUrl || "/static/img/admin.svg";
            document.getElementById("admin-user-enabled-input").value = String(Boolean(user.enabled));
            openModal("admin-user-modal");
        }

        async function loadClientUsers() {
            const result = await requestJson("/api/super/clients/page", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest"
                },
                body: JSON.stringify({ pageNum: 1, pageSize: 50, keyword: document.getElementById("client-keyword").value.trim() })
            });
            const rows = result.data.records || [];
            state.clientUsers = rows;
            const rowIds = rows.map((item) => Number(item.id));
            state.selectedClientIds = state.selectedClientIds.filter((id) => rowIds.includes(id));
            document.getElementById("client-table-body").innerHTML = rows.length ? rows.map((user) => {
                const checked = state.selectedClientIds.includes(Number(user.id)) ? " checked" : "";
                return "<tr>"
                    + "<td><input type='checkbox' data-pick-client='" + user.id + "'" + checked + "></td>"
                    + "<td>" + escapeHtml(user.id) + "</td>"
                    + "<td>" + escapeHtml(user.username) + "</td>"
                    + "<td>" + escapeHtml(user.phone) + "</td>"
                    + "<td>" + escapeHtml(user.enabled ? "启用" : "停用") + "</td>"
                    + "<td class='admin-table-actions'>"
                    + "<button class='campus-light-btn' type='button' data-edit-client='" + user.id + "'>编辑</button>"
                    + "<button class='campus-light-btn danger-lite' type='button' data-delete-user='" + user.id + "'>删除</button>"
                    + "</td></tr>";
            }).join("") : "<tr><td colspan='6' class='admin-empty'>暂无学生端用户</td></tr>";

            document.querySelectorAll("[data-edit-client]").forEach((button) => {
                button.addEventListener("click", async function () {
                    const result = await requestJson("/api/super/users/" + button.dataset.editClient);
                    fillClientForm(result.data);
                    showFeedback("client-feedback", "学生端账号信息已回显，可直接修改后保存。", true);
                });
            });
            document.querySelectorAll("[data-pick-client]").forEach((checkbox) => {
                checkbox.addEventListener("change", function () {
                    const id = Number(checkbox.dataset.pickClient);
                    if (checkbox.checked) {
                        if (!state.selectedClientIds.includes(id)) {
                            state.selectedClientIds.push(id);
                        }
                    } else {
                        state.selectedClientIds = state.selectedClientIds.filter((item) => item !== id);
                    }
                    syncSelectAllClients();
                });
            });
            syncSelectAllClients();
            bindDeleteButtons("client-feedback", loadClientUsers);
            renderClientSyncSummary();
        }

        async function loadAdminUsers() {
            const result = await requestJson("/api/super/admins/page", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest"
                },
                body: JSON.stringify({ pageNum: 1, pageSize: 50, keyword: document.getElementById("admin-keyword-super").value.trim() })
            });
            const rows = result.data.records || [];
            state.adminUsers = rows;
            const rowIds = rows.map((item) => Number(item.id));
            state.selectedAdminIds = state.selectedAdminIds.filter((id) => rowIds.includes(id));
            document.getElementById("admin-user-table-body").innerHTML = rows.length ? rows.map((user) => {
                const checked = state.selectedAdminIds.includes(Number(user.id)) ? " checked" : "";
                return "<tr>"
                    + "<td><input type='checkbox' data-pick-admin='" + user.id + "'" + checked + "></td>"
                    + "<td>" + escapeHtml(user.id) + "</td>"
                    + "<td>" + escapeHtml(user.username) + "</td>"
                    + "<td>" + escapeHtml(user.phone) + "</td>"
                    + "<td>" + escapeHtml(roleLabel(user)) + "</td>"
                    + "<td class='admin-table-actions'>"
                    + "<button class='campus-light-btn' type='button' data-edit-admin-user='" + user.id + "'>编辑</button>"
                    + "<button class='campus-light-btn danger-lite' type='button' data-delete-user='" + user.id + "'>删除</button>"
                    + "</td></tr>";
            }).join("") : "<tr><td colspan='6' class='admin-empty'>暂无管理端账号</td></tr>";

            document.querySelectorAll("[data-edit-admin-user]").forEach((button) => {
                button.addEventListener("click", async function () {
                    const result = await requestJson("/api/super/users/" + button.dataset.editAdminUser);
                    fillAdminForm(result.data);
                    showFeedback("admin-user-feedback", "管理端账号信息已回显，可直接修改后保存。", true);
                });
            });
            document.querySelectorAll("[data-pick-admin]").forEach((checkbox) => {
                checkbox.addEventListener("change", function () {
                    const id = Number(checkbox.dataset.pickAdmin);
                    if (checkbox.checked) {
                        if (!state.selectedAdminIds.includes(id)) {
                            state.selectedAdminIds.push(id);
                        }
                    } else {
                        state.selectedAdminIds = state.selectedAdminIds.filter((item) => item !== id);
                    }
                    syncSelectAllAdmins();
                });
            });
            syncSelectAllAdmins();
            bindDeleteButtons("admin-user-feedback", loadAdminUsers);
            renderAdminSyncSummary();
        }

        function syncSelectAllClients() {
            const box = document.getElementById("select-all-clients");
            if (!box) {
                return;
            }
            box.checked = state.clientUsers.length > 0 && state.selectedClientIds.length === state.clientUsers.length;
        }

        function syncSelectAllAdmins() {
            const box = document.getElementById("select-all-admins");
            if (!box) {
                return;
            }
            box.checked = state.adminUsers.length > 0 && state.selectedAdminIds.length === state.adminUsers.length;
        }

        async function batchSetEnabled(users, ids, enabled, feedbackId, reloadFn) {
            if (!ids.length) {
                showFeedback(feedbackId, "请先勾选要处理的账号。", false);
                return;
            }
            try {
                for (const id of ids) {
                    const user = users.find((item) => Number(item.id) === Number(id));
                    if (!user) {
                        continue;
                    }
                    await requestJson("/api/super/users", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                            "X-Requested-With": "XMLHttpRequest"
                        },
                        body: JSON.stringify({
                            id: user.id,
                            username: user.username,
                            phone: user.phone,
                            password: "",
                            enabled: enabled,
                            avatarUrl: user.avatarUrl || "/static/img/user.svg",
                            roleCode: roleCodeOf(user)
                        })
                    });
                }
                showFeedback(feedbackId, enabled ? "批量启用完成。" : "批量停用完成。", true);
                await reloadFn();
                await loadOverview();
            } catch (error) {
                showFeedback(feedbackId, error.message, false);
            }
        }

        async function batchDeleteUsers(ids, feedbackId, reloadFn) {
            if (!ids.length) {
                showFeedback(feedbackId, "请先勾选要删除的账号。", false);
                return;
            }
            if (!window.confirm("确认批量删除选中的账号吗？")) {
                return;
            }
            try {
                for (const id of ids) {
                    await requestJson("/api/super/users/" + id + "/delete", { method: "POST" });
                }
                showFeedback(feedbackId, "批量删除完成。", true);
                await reloadFn();
                await loadOverview();
            } catch (error) {
                showFeedback(feedbackId, error.message, false);
            }
        }

        async function importUsers(fileInputId, roleCode, feedbackId, reloadFn) {
            const fileInput = document.getElementById(fileInputId);
            const file = fileInput && fileInput.files ? fileInput.files[0] : null;
            if (!file) {
                showFeedback(feedbackId, "请先选择导入文件。", false);
                return;
            }
            const formData = new FormData();
            formData.append("file", file);
            if (roleCode) {
                formData.append("roleCode", roleCode);
            }
            try {
                const response = await axios.post("/api/super/users/import", formData, {
                    withCredentials: true,
                    headers: {
                        "X-Requested-With": "XMLHttpRequest"
                    }
                });
                const result = response.data;
                if (!result || result.success === false) {
                    throw new Error(normalizeApiErrorMessage(result && result.message, response.status));
                }
                const data = result.data || {};
                const summary = "导入完成：总计 " + escapeHtml(data.total || 0)
                    + "，成功 " + escapeHtml(data.success || 0)
                    + "，失败 " + escapeHtml(data.failed || 0)
                    + "，新增 " + escapeHtml(data.created || 0)
                    + "，更新 " + escapeHtml(data.updated || 0);
                showFeedback(feedbackId, summary, true);
                if (Array.isArray(data.errors) && data.errors.length) {
                    const reportHint = data.errorReportUrl ? ("；失败报告：" + data.errorReportUrl) : "";
                    showFeedback(feedbackId, summary + "。部分失败：" + data.errors.join("；") + reportHint, false);
                }
                if (fileInput) {
                    fileInput.value = "";
                }
                await reloadFn();
                await loadOverview();
            } catch (error) {
                showFeedback(feedbackId, resolveAxiosError(error), false);
            }
        }

        function bindDeleteButtons(feedbackId, reloadFn) {
            document.querySelectorAll("[data-delete-user]").forEach((button) => {
                button.addEventListener("click", async function () {
                    if (!window.confirm("确认删除这个账号吗？")) {
                        return;
                    }
                    try {
                        await requestJson("/api/super/users/" + button.dataset.deleteUser + "/delete", { method: "POST" });
                        showFeedback(feedbackId, "账号已删除。", true);
                        if (state.editingClientId === Number(button.dataset.deleteUser)) {
                            closeModal("client-user-modal");
                        }
                        if (state.editingAdminId === Number(button.dataset.deleteUser)) {
                            closeModal("admin-user-modal");
                        }
                        await reloadFn();
                        await loadOverview();
                    } catch (error) {
                        showFeedback(feedbackId, error.message, false);
                    }
                });
            });
        }

        async function saveClientUser() {
            try {
                const username = document.getElementById("client-username-input").value.trim();
                const phone = document.getElementById("client-phone-input").value.trim();
                if (!validateUserForm(username, phone, "client-feedback")) {
                    return;
                }
                await requestJson("/api/super/users", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: JSON.stringify({
                        id: state.editingClientId,
                        username: username,
                        phone: phone,
                        password: document.getElementById("client-password-input").value.trim(),
                        enabled: document.getElementById("client-enabled-input").value === "true",
                        avatarUrl: document.getElementById("client-avatar-input").value.trim(),
                        roleCode: "ROLE_USER"
                    })
                });
                showFeedback("client-feedback", state.editingClientId ? "学生端用户已更新。" : "学生端用户已创建。", true);
                resetClientForm();
                closeModal("client-user-modal", false);
                await loadClientUsers();
                await loadOverview();
            } catch (error) {
                showFeedback("client-feedback", error.message, false);
            }
        }

        async function saveAdminUser() {
            try {
                const username = document.getElementById("admin-user-username-input").value.trim();
                const phone = document.getElementById("admin-user-phone-input").value.trim();
                if (!validateUserForm(username, phone, "admin-user-feedback")) {
                    return;
                }
                await requestJson("/api/super/users", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: JSON.stringify({
                        id: state.editingAdminId,
                        username: username,
                        phone: phone,
                        password: document.getElementById("admin-user-password-input").value.trim(),
                        enabled: document.getElementById("admin-user-enabled-input").value === "true",
                        avatarUrl: document.getElementById("admin-user-avatar-input").value.trim(),
                        roleCode: document.getElementById("admin-user-role-input").value
                    })
                });
                showFeedback("admin-user-feedback", state.editingAdminId ? "管理端账号已更新。" : "管理端账号已创建。", true);
                resetAdminForm();
                closeModal("admin-user-modal", false);
                await loadAdminUsers();
                await loadOverview();
            } catch (error) {
                showFeedback("admin-user-feedback", error.message, false);
            }
        }

        bindModalDismiss();
        registerPanelModal({
            modalId: "client-user-modal",
            panelId: "client-form-panel",
            triggerIds: ["open-client-user-modal"],
            beforeOpen: resetClientForm,
            reset: resetClientForm
        });
        registerPanelModal({
            modalId: "admin-user-modal",
            panelId: "admin-user-form-panel",
            triggerIds: ["open-admin-user-modal"],
            beforeOpen: resetAdminForm,
            reset: resetAdminForm
        });

        document.getElementById("search-clients").addEventListener("click", function () {
            runGuarded("searchClientsRunning", "search-clients", "查询中...", loadClientUsers, "client-feedback");
        });
        document.getElementById("search-admins").addEventListener("click", function () {
            runGuarded("searchAdminsRunning", "search-admins", "查询中...", loadAdminUsers, "admin-user-feedback");
        });
        document.getElementById("client-keyword").addEventListener("keydown", function (event) {
            if (event.key === "Enter") {
                loadClientUsers();
            }
        });
        document.getElementById("admin-keyword-super").addEventListener("keydown", function (event) {
            if (event.key === "Enter") {
                loadAdminUsers();
            }
        });
        document.getElementById("select-all-clients").addEventListener("change", function () {
            state.selectedClientIds = this.checked ? state.clientUsers.map((item) => Number(item.id)) : [];
            loadClientUsers().catch((error) => showFeedback("client-feedback", error.message, false));
        });
        document.getElementById("select-all-admins").addEventListener("change", function () {
            state.selectedAdminIds = this.checked ? state.adminUsers.map((item) => Number(item.id)) : [];
            loadAdminUsers().catch((error) => showFeedback("admin-user-feedback", error.message, false));
        });
        document.getElementById("batch-enable-clients").addEventListener("click", function () {
            runGuarded("batchEnableClientsRunning", "batch-enable-clients", "处理中...", function () {
                return batchSetEnabled(state.clientUsers, state.selectedClientIds.slice(), true, "client-feedback", loadClientUsers);
            }, "client-feedback");
        });
        document.getElementById("batch-disable-clients").addEventListener("click", function () {
            runGuarded("batchDisableClientsRunning", "batch-disable-clients", "处理中...", function () {
                return batchSetEnabled(state.clientUsers, state.selectedClientIds.slice(), false, "client-feedback", loadClientUsers);
            }, "client-feedback");
        });
        document.getElementById("batch-delete-clients").addEventListener("click", function () {
            runGuarded("batchDeleteClientsRunning", "batch-delete-clients", "处理中...", function () {
                return batchDeleteUsers(state.selectedClientIds.slice(), "client-feedback", loadClientUsers);
            }, "client-feedback");
        });
        document.getElementById("batch-enable-admins").addEventListener("click", function () {
            runGuarded("batchEnableAdminsRunning", "batch-enable-admins", "处理中...", function () {
                return batchSetEnabled(state.adminUsers, state.selectedAdminIds.slice(), true, "admin-user-feedback", loadAdminUsers);
            }, "admin-user-feedback");
        });
        document.getElementById("batch-disable-admins").addEventListener("click", function () {
            runGuarded("batchDisableAdminsRunning", "batch-disable-admins", "处理中...", function () {
                return batchSetEnabled(state.adminUsers, state.selectedAdminIds.slice(), false, "admin-user-feedback", loadAdminUsers);
            }, "admin-user-feedback");
        });
        document.getElementById("batch-delete-admins").addEventListener("click", function () {
            runGuarded("batchDeleteAdminsRunning", "batch-delete-admins", "处理中...", function () {
                return batchDeleteUsers(state.selectedAdminIds.slice(), "admin-user-feedback", loadAdminUsers);
            }, "admin-user-feedback");
        });
        document.getElementById("import-clients-btn").addEventListener("click", function () {
            runGuarded("importClientsRunning", "import-clients-btn", "导入中...", function () {
                return importUsers("import-clients-file", "ROLE_USER", "client-feedback", loadClientUsers);
            }, "client-feedback");
        });
        document.getElementById("import-admins-btn").addEventListener("click", function () {
            runGuarded("importAdminsRunning", "import-admins-btn", "导入中...", function () {
                return importUsers("import-admins-file", "ROLE_MERCHANT_ADMIN", "admin-user-feedback", loadAdminUsers);
            }, "admin-user-feedback");
        });
        document.getElementById("save-client-user").addEventListener("click", function () {
            runGuarded("saveClientRunning", "save-client-user", "保存中...", saveClientUser, "client-feedback");
        });
        document.getElementById("save-admin-user").addEventListener("click", function () {
            runGuarded("saveAdminRunning", "save-admin-user", "保存中...", saveAdminUser, "admin-user-feedback");
        });
        document.getElementById("cancel-client-edit").addEventListener("click", function () {
            closeModal("client-user-modal");
        });
        document.getElementById("cancel-admin-user-edit").addEventListener("click", function () {
            closeModal("admin-user-modal");
        });
        document.getElementById("refresh-super-overview").addEventListener("click", function () {
            runGuarded("refreshOverviewRunning", "refresh-super-overview", "刷新中...", function () {
                return Promise.all([loadOverview(), loadClientUsers(), loadAdminUsers()]);
            }, "overview-feedback");
        });
        document.getElementById("search-audit-logs").addEventListener("click", function () {
            runGuarded("searchAuditRunning", "search-audit-logs", "筛选中...", function () {
                state.auditPageNum = 1;
                return loadAuditLogsByFilter();
            }, "overview-feedback");
        });
        document.getElementById("reset-audit-logs").addEventListener("click", function () {
            document.getElementById("audit-operator-filter").value = "";
            document.getElementById("audit-optype-filter").value = "";
            document.getElementById("audit-result-filter").value = "";
            document.getElementById("audit-start-filter").value = "";
            document.getElementById("audit-end-filter").value = "";
            state.auditPageNum = 1;
            runGuarded("resetAuditRunning", "reset-audit-logs", "重置中...", loadOverview, "overview-feedback");
        });
        document.getElementById("export-audit-logs").addEventListener("click", function () {
            const query = getAuditFilterQuery();
            query.set("limit", "500");
            window.location.href = "/api/super/audit-logs/export?" + query.toString();
        });
        document.getElementById("refresh-audit-trend").addEventListener("click", loadAuditTrendByDays);
        document.getElementById("audit-prev-page").addEventListener("click", function () {
            if (state.auditPageNum > 1) {
                state.auditPageNum -= 1;
                loadAuditLogsByFilter();
            }
        });
        document.getElementById("audit-next-page").addEventListener("click", function () {
            const totalPage = Math.max(1, Math.ceil(state.auditTotal / state.auditPageSize));
            if (state.auditPageNum < totalPage) {
                state.auditPageNum += 1;
                loadAuditLogsByFilter();
            }
        });

        resetClientForm();
        resetAdminForm();
        const initialPage = document.body.dataset.superPage || "overview";
        switchSection(sectionMeta[initialPage] ? initialPage : "overview");
        bindSuperNavigation();
        Promise.all([loadOverview(), loadClientUsers(), loadAdminUsers()]);
    })();
</script>
</body>
</html>
