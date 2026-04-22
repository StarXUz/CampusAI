<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>智慧校园生活服务平台 - 用户端</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/static/css/main.css">
</head>
<body class="campus-web-body">
<div class="campus-web-shell">
    <header class="campus-web-header">
        <div class="campus-web-brand">
            <span class="campus-web-brand-mark">Campus</span>
            <div>
                <strong>智慧校园生活服务平台</strong>
                <span>用户端服务</span>
            </div>
        </div>
        <nav class="campus-web-nav">
            <button type="button" class="active" data-page="home">首页</button>
            <button type="button" data-page="dining">校园餐饮</button>
            <button type="button" data-page="payment">支付中心</button>
            <button type="button" data-page="study">自习室预约</button>
            <button type="button" data-page="activity">活动报名</button>
            <button type="button" data-page="ai">AI 助手</button>
            <button type="button" data-page="profile">我的账号</button>
        </nav>
        <div class="campus-web-user">
            <img id="client-avatar" class="campus-nav-avatar" src="/static/img/user.svg" alt="用户头像">
            <strong id="client-username">加载中...</strong>
            <span id="client-phone"></span>
        </div>
    </header>

    <div class="campus-web-workspace">
    <aside class="campus-module-sidebar" aria-label="功能模块切换">
        <div class="campus-module-sidebar-title">功能模块</div>
        <button type="button" class="active" data-page="home"><strong>首页总览</strong><span>统计与快捷入口</span></button>
        <button type="button" data-page="dining"><strong>校园餐饮</strong><span>商家、套餐与菜品</span></button>
        <button type="button" data-page="payment"><strong>支付中心</strong><span>订单与支付方式</span></button>
        <button type="button" data-page="study"><strong>自习室预约</strong><span>平面图与选座</span></button>
        <button type="button" data-page="activity"><strong>活动报名</strong><span>活动查看与报名</span></button>
        <button type="button" data-page="ai"><strong>AI 助手</strong><span>实时校园问答</span></button>
        <button type="button" data-page="profile"><strong>我的账号</strong><span>个人信息维护</span></button>
    </aside>
    <main class="campus-web-main">
        <section id="page-home" class="campus-web-panel active">
            <div class="campus-home-hero">
                <div class="campus-home-hero-main">
                    <span class="campus-hero-tag">学生服务首页</span>
                    <h1><span id="home-greeting-name">校园用户</span>，今天从这里开始办理校园生活</h1>
                    <p>点餐、选座、报名、支付与 AI 问答都收在一个工作台里，打开页面就能看到今天最该处理的事项和对应入口。</p>
                    <div class="campus-home-badges">
                        <span id="home-badge-merchants" class="campus-home-badge">今日可点餐商家 0 家</span>
                        <span id="home-badge-study" class="campus-home-badge">可预约自习室 0 个</span>
                        <span id="home-badge-orders" class="campus-home-badge">当前无待支付订单</span>
                    </div>
                </div>
                <aside class="campus-home-focus-card">
                    <span class="campus-home-focus-label">当前优先事项</span>
                    <strong id="home-priority-title">先看看今日餐饮推荐</strong>
                    <p id="home-priority-desc">选择商家后可直接进入菜品与套餐列表，适合快速演示校园点餐流程。</p>
                    <div class="campus-hero-actions campus-home-focus-actions">
                        <button id="home-primary-cta" class="campus-primary-btn" type="button" data-page-link="dining">查看今日餐饮</button>
                        <button id="home-secondary-cta" class="campus-light-btn" type="button" data-page-link="study">开始预约自习室</button>
                    </div>
                </aside>
            </div>
            <div id="home-stats" class="campus-stat-grid campus-home-stat-grid"></div>
            <div class="campus-entry-grid desktop-grid campus-home-action-grid">
                <button class="campus-entry-card" type="button" data-page-link="dining">
                    <strong>校园餐饮</strong>
                    <span>查看商家、菜品和套餐，直接发起下单。</span>
                </button>
                <button class="campus-entry-card" type="button" data-page-link="study">
                    <strong>自习室预约</strong>
                    <span>按日期、时段和座位完成预约。</span>
                </button>
                <button class="campus-entry-card" type="button" data-page-link="payment">
                    <strong>支付中心</strong>
                    <span>查看订单状态并完成支付。</span>
                </button>
                <button class="campus-entry-card" type="button" data-page-link="activity">
                    <strong>活动报名</strong>
                    <span>浏览活动并提交报名信息。</span>
                </button>
                <button class="campus-entry-card" type="button" data-page-link="ai">
                    <strong>AI 助手</strong>
                    <span>基于最新校园业务数据给出回答。</span>
                </button>
            </div>
            <div class="campus-home-grid campus-home-board">
                <article class="campus-form-card">
                    <div class="campus-section-head">
                        <h2>今日餐饮推荐</h2>
                        <button class="campus-light-btn" type="button" data-page-link="dining">进入餐饮</button>
                    </div>
                    <div id="home-package-preview" class="campus-home-package-grid"></div>
                </article>
                <article class="campus-form-card">
                    <div class="campus-section-head">
                        <h2>我的预约提醒</h2>
                        <button class="campus-light-btn" type="button" data-page-link="study">进入预约</button>
                    </div>
                    <div id="home-reservation-preview" class="campus-list-stack"></div>
                </article>
                <article class="campus-form-card">
                    <div class="campus-section-head">
                        <h2>近期活动预告</h2>
                        <button class="campus-light-btn" type="button" data-page-link="activity">查看全部</button>
                    </div>
                    <div id="home-activity-preview" class="campus-list-stack"></div>
                </article>
                <article class="campus-form-card">
                    <div class="campus-section-head">
                        <h2>我的订单状态</h2>
                        <button class="campus-light-btn" type="button" data-page-link="payment">进入支付中心</button>
                    </div>
                    <div id="home-order-preview" class="campus-list-stack"></div>
                </article>
            </div>
            <article class="campus-form-card campus-top-gap">
                <div class="campus-section-head">
                    <h2>人气商家推荐</h2>
                    <button class="campus-light-btn" type="button" data-page-link="dining">查看全部商家</button>
                </div>
                <div id="home-merchant-preview" class="campus-merchant-showcase"></div>
            </article>
        </section>

        <section id="page-dining" class="campus-web-panel" hidden>
            <div class="campus-section-head">
                <h2>校园餐饮</h2>
                <p>先选择商家，再浏览带图片、价格和热量的菜品卡片。</p>
            </div>
            <div class="campus-desk-layout">
                <aside class="campus-side-panel">
                    <div class="campus-panel-title">商家列表</div>
                    <div id="merchant-menu" class="campus-merchant-menu"></div>
                    <div class="campus-info-banner campus-top-gap">
                        <strong>下单说明</strong>
                        <span>点击右侧菜品或套餐的“立即下单”后，会跳转到独立支付中心完成订单支付。</span>
                    </div>
                </aside>
                <section class="campus-main-panel">
                    <div id="merchant-highlight" class="campus-info-banner"></div>
                    <div class="campus-section-head campus-subsection-head">
                        <h3>商家菜单概览</h3>
                        <p>展示当前商家的菜单结构、菜品数量和套餐数量。</p>
                    </div>
                    <div id="merchant-menu-board" class="campus-seat-board"></div>
                    <div class="campus-section-head campus-subsection-head">
                        <h3>菜品列表</h3>
                        <p>默认保留售罄菜品展示，方便检索与比对；售罄项会明确标记且不可下单。</p>
                    </div>
                    <div class="admin-inline-actions">
                        <input id="dish-search-input" class="admin-mini-input" type="text" placeholder="搜索菜品关键词">
                        <select id="dish-category-select" class="admin-mini-input"></select>
                        <label class="admin-checkbox"><input id="dish-include-soldout" type="checkbox" checked> 显示售罄</label>
                        <button id="dish-search-btn" class="campus-light-btn" type="button">筛选</button>
                        <button id="dish-reset-btn" class="campus-light-btn" type="button">重置</button>
                    </div>
                    <div id="dish-list" class="campus-dish-grid"></div>
                </section>
            </div>
        </section>

        <section id="page-payment" class="campus-web-panel" hidden>
            <div class="campus-section-head">
                <h2>支付中心</h2>
                <p>独立展示待支付商品、支付方式和订单记录，保障支付流程闭环可追踪。</p>
            </div>
            <div class="campus-desk-layout">
                <aside class="campus-side-panel">
                    <div class="campus-panel-title">当前待支付订单</div>
                    <div id="checkout-box" class="campus-order-box"></div>
                    <div class="campus-panel-title campus-top-gap">支付方式</div>
                    <div class="campus-pay-gallery">
                        <button type="button" class="campus-pay-poster" data-pay-pick="CAMPUS_CARD">
                            <img src="/static/img/mastercard.png" alt="校园卡">
                            <strong>校园卡支付</strong>
                        </button>
                        <button type="button" class="campus-pay-poster" data-pay-pick="WECHAT">
                            <img src="/static/img/wechat-pay.png" alt="微信支付">
                            <strong>微信支付</strong>
                        </button>
                        <button type="button" class="campus-pay-poster" data-pay-pick="ALIPAY">
                            <img src="/static/img/alipay-pay.png" alt="支付宝">
                            <strong>支付宝支付</strong>
                        </button>
                    </div>
                </aside>
                <section class="campus-main-panel">
                    <div class="campus-section-head">
                        <h3>我的订单</h3>
                        <button class="campus-light-btn" type="button" id="refresh-orders-btn">刷新订单</button>
                    </div>
                    <div id="order-list" class="campus-list-stack"></div>
                </section>
            </div>
        </section>

        <section id="page-study" class="campus-web-panel" hidden>
            <div class="campus-section-head">
                <h2>自习室预约</h2>
                <p>左侧选择日期与时段，右侧平面图选座并实时反馈预约状态。</p>
            </div>
            <div class="campus-desk-layout campus-study-layout">
                <aside class="campus-side-panel">
                    <div class="campus-panel-title">自习室选择</div>
                    <div id="room-cards" class="campus-room-list"></div>
                    <label class="campus-field">
                        <span>预约日期</span>
                        <input id="study-date" type="date">
                    </label>
                    <div class="campus-panel-title">预约时长</div>
                    <div id="duration-chips" class="campus-chip-row"></div>
                    <div class="campus-panel-title">时间段</div>
                    <div id="slot-chips" class="campus-chip-grid"></div>
                    <div id="study-room-summary" class="campus-info-banner"></div>
                    <button id="reserve-btn" class="campus-primary-btn full-width" type="button">确认预约</button>
                    <p id="reserve-message" class="campus-inline-tip">请选择日期、时间段和座位后提交。</p>
                </aside>
                <section class="campus-main-panel">
                    <div class="campus-panel-title">座位图</div>
                    <div class="campus-section-head campus-subsection-head">
                        <h3>分区座位导航</h3>
                        <p>按分区查看座位分布，点击即可选中。</p>
                    </div>
                    <div id="study-floorplan" class="campus-seat-board"></div>
                    <div id="seat-selection-summary" class="campus-seat-selection-summary"></div>
                    <div class="campus-section-head campus-subsection-head">
                        <h3>我的预约</h3>
                        <p>展示最近预约记录、时间段和预约凭证。</p>
                    </div>
                    <div id="reservation-list" class="campus-list-stack"></div>
                </section>
            </div>
        </section>

        <section id="page-activity" class="campus-web-panel" hidden>
            <div class="campus-section-head">
                <h2>活动报名</h2>
                <p>活动与报名信息分区展示，形成“选择-填写-提交-结果”完整链路。</p>
            </div>
            <div class="campus-desk-layout campus-activity-layout">
                <section class="campus-main-panel">
                    <div class="campus-panel-title">全部活动</div>
                    <div id="all-activities" class="campus-list-stack"></div>
                </section>
                <aside class="campus-side-panel campus-activity-side-panel">
                    <div class="campus-panel-title">报名信息</div>
                    <p id="activity-selected-tip" class="campus-inline-tip">请先从左侧选择一个活动。</p>
                    <div class="campus-form-stack">
                        <label class="campus-field">
                            <span>姓名</span>
                            <input id="signup-real-name" type="text" placeholder="请输入姓名">
                        </label>
                        <label class="campus-field">
                            <span>学号</span>
                            <input id="signup-student-no" type="text" placeholder="请输入学号">
                        </label>
                        <label class="campus-field">
                            <span>联系电话</span>
                            <input id="signup-phone" type="text" placeholder="请输入手机号">
                        </label>
                    </div>
                    <button id="submit-signup" class="campus-primary-btn full-width" type="button">提交报名</button>
                    <p id="activity-feedback" class="campus-inline-tip">提交后会自动刷新到“我的报名”。</p>
                    <div class="campus-section-head campus-subsection-head">
                        <h3>我的报名</h3>
                        <p>可在这里查看和取消报名。</p>
                    </div>
                    <div id="my-activities" class="campus-list-stack"></div>
                </aside>
            </div>
        </section>

        <section id="page-ai" class="campus-web-panel" hidden>
            <div class="campus-section-head">
                <h2>AI 智能助手</h2>
                <p>保持接口独立，前端只负责场景和问题输入。</p>
            </div>
            <div class="campus-quick-prompts">
                <button class="campus-chip" type="button" data-ai-prompt="帮我推荐适合晚餐的减脂套餐">减脂晚餐</button>
                <button class="campus-chip" type="button" data-ai-prompt="今晚图书馆附近有哪些轻食推荐">附近轻食</button>
                <button class="campus-chip" type="button" data-ai-prompt="帮我总结自习室预约规则">预约规则</button>
            </div>
            <div class="campus-ai-chat-wrap">
                <div id="ai-chat-log" class="campus-ai-chat-log">
                    <article class="campus-ai-msg campus-ai-msg-system">
                        <div class="campus-ai-bubble">你好，我是校园智能助手。你可以问我点餐推荐、座位预约、活动报名或订单问题。</div>
                        <time>系统</time>
                    </article>
                </div>
                <div class="campus-ai-box desktop-ai-box">
                    <textarea id="ai-question" rows="2" placeholder="请输入想问的问题，例如：帮我推荐今晚高蛋白低脂晚餐" autocomplete="off" spellcheck="false"></textarea>
                    <div class="campus-ai-action-row">
                        <button id="ai-clear" class="campus-light-btn" type="button">清空对话</button>
                        <button id="ai-submit" class="campus-primary-btn" type="button">发送</button>
                    </div>
                </div>
            </div>
        </section>

        <section id="page-profile" class="campus-web-panel" hidden>
            <div class="campus-section-head">
                <h2>我的账号</h2>
                <div class="admin-inline-actions">
                    <p>展示当前登录用户及个人业务记录，可直接维护个人资料。</p>
                    <button id="open-profile-edit-modal" class="campus-primary-btn" type="button">编辑个人资料</button>
                </div>
            </div>
            <div class="campus-profile-card">
                <div class="campus-profile-row"><span>用户名</span><strong id="profile-username">-</strong></div>
                <div class="campus-profile-row"><span>手机号</span><strong id="profile-phone">-</strong></div>
                <div class="campus-profile-row"><span>当前入口</span><strong>网页端用户服务</strong></div>
                <div class="campus-profile-row"><span>我的活动</span><strong id="profile-activity-count">0</strong></div>
                <div class="campus-profile-row"><span>我的预约</span><strong id="profile-reservation-count">0</strong></div>
                <div class="campus-profile-row"><span>我的订单</span><strong id="profile-order-count">0</strong></div>
            </div>
            <article id="profile-edit-panel" class="campus-form-card campus-top-gap">
                <div class="campus-section-head">
                    <h3>编辑个人资料</h3>
                    <p>可修改姓名、手机号和头像。</p>
                </div>
                <div class="campus-form-stack">
                    <label class="campus-field">
                        <span>姓名</span>
                        <input id="profile-edit-username" type="text" placeholder="请输入姓名">
                    </label>
                    <label class="campus-field">
                        <span>手机号</span>
                        <input id="profile-edit-phone" type="text" placeholder="请输入手机号">
                    </label>
                    <label class="campus-field">
                        <span>头像地址</span>
                        <input id="profile-edit-avatar" type="text" placeholder="可直接填写头像地址">
                    </label>
                    <label class="campus-field">
                        <span>上传头像</span>
                        <input id="profile-avatar-file" type="file" accept="image/*">
                    </label>
                </div>
                <div class="admin-inline-actions">
                    <button id="upload-profile-avatar-btn" class="campus-light-btn" type="button">上传头像</button>
                    <button id="save-profile-btn" class="campus-primary-btn" type="button">保存资料</button>
                </div>
                <p id="profile-feedback" class="campus-inline-tip"></p>
            </article>
            <div class="campus-profile-actions">
                <button type="button" class="campus-light-btn" onclick="window.location.href='/login'">返回登录页</button>
                <button id="logout-btn" type="button" class="campus-primary-btn">退出登录</button>
            </div>
        </section>
    </main>
    </div>
</div>

<script src="/static/vendor/axios/axios.min.js"></script>
<script>
    (function () {
        const ORDER_PAY_TIMEOUT_SECONDS = 15 * 60;
        const state = {
            currentUser: null,
                currentPage: "home",
                merchants: [],
            packages: [],
            selectedMerchantPackages: [],
            selectedMerchantDishes: [],
            dishCategories: [],
            selectedMerchantId: null,
            dishFilter: {
                keyword: "",
                categoryId: "",
                includeSoldOut: true
            },
            studyRooms: [],
            selectedRoomId: null,
            selectedDuration: 2,
            selectedDate: new Date().toISOString().slice(0, 10),
            selectedSlot: null,
            selectedSeatId: null,
            selectedStudyFloor: "1F",
            rescheduleReservationId: null,
            myReservations: [],
            activities: [],
            currentActivityId: null,
            myActivities: [],
            myOrders: [],
            checkout: {
                orderId: null,
                merchantId: null,
                itemType: null,
                itemName: "",
                totalAmount: "",
                payChannel: "CAMPUS_CARD",
                status: null
            },
            loading: {
                reserve: false,
                activity: false,
                checkout: false,
                profile: false,
                cancelReservationId: null,
                orderSync: false
            },
            orderCountdownTimer: null,
            orderSyncTimer: null
        };

        function escapeHtml(value) {
            return String(value == null ? "" : value)
                .replace(/&/g, "&amp;")
                .replace(/</g, "&lt;")
                .replace(/>/g, "&gt;")
                .replace(/"/g, "&quot;")
                .replace(/'/g, "&#39;");
        }

        function inferMerchantLogo(name, canteenName) {
            const text = String((name || "") + " " + (canteenName || ""));
            if (text.indexOf("咖啡") >= 0 || text.indexOf("烘焙") >= 0) {
                return "/static/img/coffee.jpg";
            }
            if (text.indexOf("沙拉") >= 0 || text.indexOf("轻食") >= 0 || text.indexOf("轻卡") >= 0) {
                return "/static/img/light-food.jpg";
            }
            if (text.indexOf("盖饭") >= 0) {
                return "/static/img/dishes/beef-rice-bowl.jpg";
            }
            if (text.indexOf("川") >= 0 || text.indexOf("湘") >= 0 || text.indexOf("风味") >= 0) {
                return "/static/img/night-food.jpg";
            }
            if (text.indexOf("面") >= 0 || text.indexOf("汤") >= 0) {
                return "/static/img/dishes/beef-brisket-noodles.jpg";
            }
            return "/static/img/light-food.jpg";
        }

        function resolveMerchantLogoUrl(merchant) {
            const fallback = inferMerchantLogo(merchant && merchant.name, merchant && merchant.canteenName);
            const current = String(merchant && merchant.logoUrl ? merchant.logoUrl : "").trim();
            if (!current) {
                return fallback;
            }
            if (/\/static\/img\/dish-\d+\.jpg$/i.test(current)) {
                return fallback;
            }
            const nameText = String(merchant && merchant.name ? merchant.name : "");
            if ((nameText.indexOf("咖啡") >= 0 || nameText.indexOf("烘焙") >= 0) && current.indexOf("coffee") < 0) {
                return "/static/img/coffee.jpg";
            }
            if ((nameText.indexOf("沙拉") >= 0 || nameText.indexOf("轻食") >= 0 || nameText.indexOf("轻卡") >= 0)
                && current.indexOf("coffee") >= 0) {
                return "/static/img/light-food.jpg";
            }
            return current;
        }

        function normalizeApiErrorMessage(message, statusCode) {
            const raw = String(message || "");
            if (statusCode === 401) {
                return "登录状态已失效，请重新登录后再试。";
            }
            if (statusCode === 403) {
                return "你没有当前操作权限，请联系管理员。";
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
                headers: { "X-Requested-With": "XMLHttpRequest" }
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
            return "网络异常，请检查服务是否已启动或连接是否正常。";
        }

        async function getJson(url, options) {
            try {
                const response = await axios(buildAxiosConfig(url, options));
                if (response.status === 401) {
                    window.location.href = "/login?clientRequired=1";
                    return null;
                }
                const data = response.data;
                if (!data) {
                    return { success: false, message: "接口返回为空", data: null };
                }
                if (data.success === false) {
                    const msg = normalizeApiErrorMessage(data.message, response.status || 400);
                    data.message = msg;
                }
                return data;
            } catch (error) {
                if (error && error.response && error.response.status === 401) {
                    window.location.href = "/login?clientRequired=1";
                    return null;
                }
                return {
                    success: false,
                    message: resolveAxiosError(error),
                    data: null
                };
            }
        }

        async function runWithButton(buttonId, busyText, action) {
            const button = document.getElementById(buttonId);
            if (!button) {
                return action();
            }
            if (button.dataset.running === "1") {
                return;
            }
            const originalText = button.textContent;
            button.dataset.running = "1";
            button.disabled = true;
            if (busyText) {
                button.textContent = busyText;
            }
            try {
                await action();
            } finally {
                button.disabled = false;
                button.textContent = originalText;
                button.dataset.running = "0";
            }
        }

        function getCurrentRoom() {
            return state.studyRooms.find((item) => item.id === state.selectedRoomId) || null;
        }

        function getPageRows(pageData) {
            if (!pageData) {
                return [];
            }
            if (Array.isArray(pageData.records)) {
                return pageData.records;
            }
            if (Array.isArray(pageData.list)) {
                return pageData.list;
            }
            return [];
        }

        function formatDateTime(value) {
            if (!value) {
                return "-";
            }
            if (Array.isArray(value)) {
                const parts = value.slice(0, 5).map((item) => String(item).padStart(2, "0"));
                return parts[0] + "-" + parts[1] + "-" + parts[2] + " " + parts[3] + ":" + parts[4];
            }
            return String(value).replace("T", " ");
        }

        function formatDateOnly(value) {
            if (!value) {
                return "-";
            }
            if (Array.isArray(value)) {
                const parts = value.slice(0, 3).map((item) => String(item).padStart(2, "0"));
                return parts[0] + "-" + parts[1] + "-" + parts[2];
            }
            return String(value).split("T")[0];
        }

        function formatTimeOnly(value) {
            if (!value) {
                return "-";
            }
            if (Array.isArray(value)) {
                const parts = value.slice(0, 2).map((item) => String(item).padStart(2, "0"));
                return parts[0] + ":" + parts[1];
            }
            return String(value).slice(0, 5);
        }

        function toTimestamp(value) {
            if (!value) {
                return NaN;
            }
            if (Array.isArray(value)) {
                const parts = value.map((item) => Number(item));
                const year = parts[0] || 1970;
                const month = (parts[1] || 1) - 1;
                const date = parts[2] || 1;
                const hour = parts[3] || 0;
                const minute = parts[4] || 0;
                const second = parts[5] || 0;
                return new Date(year, month, date, hour, minute, second).getTime();
            }
            const text = String(value);
            const normalized = text.indexOf("T") >= 0 ? text : text.replace(" ", "T");
            return new Date(normalized).getTime();
        }

        function getOrderRemainingSeconds(order) {
            if (!order || order.status !== "UNPAID") {
                return null;
            }
            const createdTime = toTimestamp(order.createdAt);
            if (Number.isNaN(createdTime)) {
                return null;
            }
            const deadline = createdTime + ORDER_PAY_TIMEOUT_SECONDS * 1000;
            return Math.floor((deadline - Date.now()) / 1000);
        }

        function formatCountdown(seconds) {
            const safe = Math.max(0, Number(seconds || 0));
            const minute = Math.floor(safe / 60);
            const second = safe % 60;
            return String(minute).padStart(2, "0") + ":" + String(second).padStart(2, "0");
        }

        function formatNowDateTime() {
            const now = new Date();
            const y = now.getFullYear();
            const m = String(now.getMonth() + 1).padStart(2, "0");
            const d = String(now.getDate()).padStart(2, "0");
            const hh = String(now.getHours()).padStart(2, "0");
            const mm = String(now.getMinutes()).padStart(2, "0");
            const ss = String(now.getSeconds()).padStart(2, "0");
            return y + "-" + m + "-" + d + " " + hh + ":" + mm + ":" + ss;
        }

        function buildOrderCountdownText(order) {
            const remaining = getOrderRemainingSeconds(order);
            if (remaining == null) {
                return "待支付，超时将自动取消";
            }
            if (remaining <= 0) {
                return "订单超时处理中，请稍后刷新";
            }
            return "剩余支付时间：" + formatCountdown(remaining);
        }

        function refreshOrderCountdownTexts() {
            document.querySelectorAll("[data-order-countdown-id]").forEach((element) => {
                const orderId = Number(element.dataset.orderCountdownId);
                const order = state.myOrders.find((item) => Number(item.id) === orderId);
                if (!order) {
                    return;
                }
                const remaining = getOrderRemainingSeconds(order);
                element.textContent = buildOrderCountdownText(order);
                element.classList.toggle("warn", remaining != null && remaining > 0 && remaining <= 120);
            });
        }

        function startOrderCountdownTicker() {
            if (state.orderCountdownTimer) {
                return;
            }
            state.orderCountdownTimer = setInterval(function () {
                refreshOrderCountdownTexts();
            }, 1000);
        }

        function startOrderSyncTicker() {
            if (state.orderSyncTimer) {
                return;
            }
            state.orderSyncTimer = setInterval(async function () {
                if (state.loading.orderSync) {
                    return;
                }
                if (!state.myOrders.some((item) => item.status === "UNPAID")) {
                    return;
                }
                state.loading.orderSync = true;
                try {
                    await loadMyOrders();
                    renderCheckout();
                } catch (error) {
                } finally {
                    state.loading.orderSync = false;
                }
            }, 30000);
        }

        function reservationStatusLabel(value) {
            if (value === "BOOKED") {
                return "已预约";
            }
            if (value === "CANCELLED") {
                return "已取消";
            }
            return value || "未知状态";
        }

        function switchPage(page) {
            state.currentPage = page;
            document.querySelectorAll("[data-page]").forEach((button) => {
                button.classList.toggle("active", button.dataset.page === page);
            });
            document.querySelectorAll(".campus-web-panel").forEach((panel) => {
                panel.hidden = panel.id !== "page-" + page;
                panel.classList.toggle("active", panel.id === "page-" + page);
            });
        }

        function updateHomeStats() {
            const bookedCount = state.myReservations.filter((item) => item.status === "BOOKED").length;
            const registeredCount = state.myActivities.filter((item) => item.status === "REGISTERED").length;
            const unpaidCount = state.myOrders.filter((item) => item.status === "UNPAID").length;
            document.getElementById("home-stats").innerHTML = [
                { label: "营业商家", value: state.merchants.length, note: "今日可点餐" },
                { label: "自习室", value: state.studyRooms.length, note: "可预约空间" },
                { label: "我的报名", value: registeredCount, note: "待参加活动" },
                { label: "待支付订单", value: unpaidCount, note: "支付中心可处理" }
            ].map((item) => {
                return "<div class='campus-stat-card campus-home-stat-card'><span>" + escapeHtml(item.label) + "</span><strong>" + escapeHtml(item.value) + "</strong><em>" + escapeHtml(item.note) + "</em></div>";
            }).join("");
            document.getElementById("profile-activity-count").textContent = String(registeredCount);
            document.getElementById("profile-reservation-count").textContent = String(bookedCount);
            document.getElementById("profile-order-count").textContent = String(state.myOrders.length);
            if (state.currentUser) {
                document.getElementById("home-greeting-name").textContent = state.currentUser.username || "校园用户";
            }
            document.getElementById("home-badge-merchants").textContent = "今日可点餐商家 " + state.merchants.length + " 家";
            document.getElementById("home-badge-study").textContent = "可预约自习室 " + state.studyRooms.length + " 个";
            document.getElementById("home-badge-orders").textContent = unpaidCount > 0
                ? "有 " + unpaidCount + " 笔订单待支付"
                : "当前无待支付订单";
            updateHomePriority(unpaidCount, bookedCount, registeredCount);
        }

        function updateHomeHighlights() {
            const activityHost = document.getElementById("home-activity-preview");
            const reservationHost = document.getElementById("home-reservation-preview");
            const orderHost = document.getElementById("home-order-preview");
            const activities = state.activities.slice(0, 3);
            const reservations = state.myReservations.slice(0, 2);
            const orders = state.myOrders.slice(0, 3);
            activityHost.innerHTML = activities.length ? activities.map((activity) => {
                return "<div class='campus-list-card compact with-poster'>"
                    + "<img class='campus-activity-poster' src='" + escapeHtml(activity.posterUrl || "/static/img/activity-1.svg") + "' alt='" + escapeHtml(activity.title) + "'>"
                    + "<div><strong>" + escapeHtml(activity.title) + "</strong>"
                    + "<p>" + escapeHtml(activity.location) + " / " + escapeHtml(formatDateTime(activity.startTime)) + "</p></div></div>";
            }).join("") : "<div class='campus-empty-card'>近期暂无活动，稍后可去活动页刷新查看。</div>";
            reservationHost.innerHTML = reservations.length ? reservations.map((item) => {
                return "<div class='campus-list-card compact'>"
                    + "<div><strong>" + escapeHtml(item.studyRoomName || "自习室") + "</strong>"
                    + "<p>" + escapeHtml(formatDateOnly(item.reservationDate)) + " / " + escapeHtml(formatTimeOnly(item.startTime)) + "-" + escapeHtml(formatTimeOnly(item.endTime)) + " / 座位 " + escapeHtml(item.seatCode || item.seatId) + "</p>"
                    + "<span class='campus-card-meta'>" + escapeHtml(reservationStatusLabel(item.status)) + "</span></div></div>";
            }).join("") : "<div class='campus-empty-card'>你还没有预约记录，可以先去自习室模块选择时间段和座位。</div>";
            const homePackageHost = document.getElementById("home-package-preview");
            if (homePackageHost) {
                homePackageHost.innerHTML = state.packages.slice(0, 3).length
                    ? state.packages.slice(0, 3).map((item) => {
                        return "<article class='campus-package-card'>"
                            + "<span class='campus-status-tag'>" + escapeHtml(item.theme || "套餐") + "</span>"
                            + "<strong>" + escapeHtml(item.name) + "</strong>"
                            + "<p>" + escapeHtml(item.description || "均衡搭配套餐，适合校园日常用餐场景。") + "</p>"
                            + "<div class='campus-dish-meta'><span>" + escapeHtml(item.status || "ONLINE") + "</span><b>￥" + escapeHtml(item.price) + "</b></div>"
                            + "</article>";
                    }).join("")
                    : "<div class='campus-empty-card'>当前商家还没有套餐，可去后台端继续添加。</div>";
            }
            if (orderHost) {
                orderHost.innerHTML = orders.length ? orders.map((order) => {
                    const action = order.status === "UNPAID"
                        ? "<button class='campus-light-btn' type='button' data-home-pay-order='" + order.id + "'>继续支付</button>"
                        : "<span class='campus-status-tag" + (order.status === "REFUND" ? " muted" : "") + "'>" + escapeHtml(orderStatusLabel(order.status)) + "</span>";
                    return "<div class='campus-list-card compact campus-home-order-card'>"
                        + "<div><strong>" + escapeHtml(order.itemName) + "</strong>"
                        + "<p>" + escapeHtml(order.merchantName || ("商家 #" + order.merchantId)) + " / ￥" + escapeHtml(order.totalAmount) + "</p>"
                        + "<span class='campus-card-meta'>支付方式：" + escapeHtml(paymentChannelLabel(order.payChannel)) + " / 状态：" + escapeHtml(orderStatusLabel(order.status)) + "</span></div>"
                        + action + "</div>";
                }).join("") : "<div class='campus-empty-card'>当前还没有订单记录，可以先去餐饮页选择一份餐品。</div>";
            }
            document.getElementById("home-merchant-preview").innerHTML = state.merchants.slice(0, 4).length
                ? state.merchants.slice(0, 4).map((merchant) => {
                    return "<button type='button' class='campus-merchant-preview-card' data-home-merchant='" + merchant.id + "'>"
                        + "<img src='" + escapeHtml(resolveMerchantLogoUrl(merchant)) + "' alt='" + escapeHtml(merchant.name) + "'>"
                        + "<div><strong>" + escapeHtml(merchant.name) + "</strong>"
                        + "<p>" + escapeHtml(merchant.canteenName) + "</p>"
                        + "<span>" + escapeHtml(merchant.recommended ? "推荐商家" : "校园商家") + "</span></div>"
                        + "</button>";
                }).join("")
                : "<div class='campus-empty-card'>当前还没有可展示的商家。</div>";
            document.querySelectorAll("[data-home-merchant]").forEach((button) => {
                button.addEventListener("click", async function () {
                    state.selectedMerchantId = Number(button.dataset.homeMerchant);
                    switchPage("dining");
                    renderMerchantMenu();
                    renderMerchantHighlight();
                    await Promise.all([loadPackages(), loadDishes()]);
                });
            });
            document.querySelectorAll("[data-home-pay-order]").forEach((button) => {
                button.addEventListener("click", function () {
                    reuseOrder(Number(button.dataset.homePayOrder));
                });
            });
        }

        function updateHomePriority(unpaidCount, bookedCount, registeredCount) {
            const title = document.getElementById("home-priority-title");
            const desc = document.getElementById("home-priority-desc");
            const primary = document.getElementById("home-primary-cta");
            const secondary = document.getElementById("home-secondary-cta");
            if (!title || !desc || !primary || !secondary) {
                return;
            }
            if (unpaidCount > 0) {
                title.textContent = "先处理待支付订单";
                desc.textContent = "你有 " + unpaidCount + " 笔订单待支付，进入支付中心即可继续付款并查看状态变化。";
                primary.textContent = "进入支付中心";
                primary.dataset.pageLink = "payment";
                secondary.textContent = "查看今日餐饮";
                secondary.dataset.pageLink = "dining";
                return;
            }
            if (bookedCount > 0) {
                title.textContent = "查看今天的预约安排";
                desc.textContent = "你当前有 " + bookedCount + " 条有效预约，适合先确认时段、座位和签到安排。";
                primary.textContent = "查看我的预约";
                primary.dataset.pageLink = "study";
                secondary.textContent = "浏览活动报名";
                secondary.dataset.pageLink = "activity";
                return;
            }
            if (registeredCount > 0) {
                title.textContent = "看看即将参加的活动";
                desc.textContent = "你已有 " + registeredCount + " 条报名记录，可以先确认活动时间、地点和报名状态。";
                primary.textContent = "进入活动报名";
                primary.dataset.pageLink = "activity";
                secondary.textContent = "去问 AI 助手";
                secondary.dataset.pageLink = "ai";
                return;
            }
            title.textContent = "先看看今日餐饮推荐";
            desc.textContent = "当前没有待处理事务，适合从餐饮推荐或自习室预约开始体验完整的学生端流程。";
            primary.textContent = "查看今日餐饮";
            primary.dataset.pageLink = "dining";
            secondary.textContent = "开始预约自习室";
            secondary.dataset.pageLink = "study";
        }

        function paymentChannelLabel(value) {
            if (value === "WECHAT") {
                return "微信支付";
            }
            if (value === "ALIPAY") {
                return "支付宝";
            }
            if (value === "CAMPUS_CARD") {
                return "校园卡";
            }
            return value || "未选择";
        }

        function orderStatusLabel(value) {
            if (value === "UNPAID") {
                return "待支付";
            }
            if (value === "PAID") {
                return "已支付";
            }
            if (value === "REFUND") {
                return "已退款";
            }
            return value || "处理中";
        }

        function selectCheckoutItem(item) {
            state.checkout = {
                orderId: null,
                merchantId: item.merchantId,
                itemType: item.itemType,
                itemName: item.itemName,
                totalAmount: item.totalAmount,
                payChannel: "CAMPUS_CARD",
                status: "READY"
            };
            switchPage("payment");
            renderCheckoutBox();
        }

        function pickPayChannel(value) {
            state.checkout.payChannel = value;
            syncPayPosterActive();
            renderCheckoutBox();
        }

        function syncPayPosterActive() {
            document.querySelectorAll("[data-pay-pick]").forEach((button) => {
                button.classList.toggle("active", button.dataset.payPick === state.checkout.payChannel);
            });
        }

        function reuseOrder(orderId) {
            const order = state.myOrders.find((item) => item.id === orderId);
            if (!order) {
                return;
            }
            state.checkout = {
                orderId: order.id,
                merchantId: order.merchantId,
                itemType: order.itemType,
                itemName: order.itemName,
                totalAmount: order.totalAmount,
                payChannel: order.payChannel || "CAMPUS_CARD",
                status: order.status
            };
            switchPage("payment");
            renderCheckoutBox();
        }

        function renderCheckoutBox() {
            const host = document.getElementById("checkout-box");
            const checkout = state.checkout;
            syncPayPosterActive();
            if (!host) {
                return;
            }
            if (!checkout.itemName) {
                host.innerHTML = "<div class='campus-empty-card'>先从右侧菜品或套餐点击“立即下单”，再选择支付方式完成付款。</div>";
                return;
            }
            const isCreated = Boolean(checkout.orderId);
            const statusText = checkout.status ? orderStatusLabel(checkout.status) : "待创建";
            const currentOrder = isCreated ? state.myOrders.find((item) => Number(item.id) === Number(checkout.orderId)) : null;
            host.innerHTML = "<div class='campus-order-summary'>"
                + "<strong>" + escapeHtml(checkout.itemName) + "</strong>"
                + "<p>" + escapeHtml(checkout.itemType === "PACKAGE" ? "套餐订单" : "菜品订单") + " / 金额 ￥" + escapeHtml(checkout.totalAmount) + "</p>"
                + "<span class='campus-card-meta'>订单状态：" + escapeHtml(statusText) + "</span>"
                + (currentOrder && currentOrder.status === "UNPAID"
                    ? "<span id='checkout-countdown' class='campus-order-countdown campus-order-countdown-inline'>" + escapeHtml(buildOrderCountdownText(currentOrder)) + "</span>"
                    : "")
                + "</div>"
                + "<div class='campus-info-banner'>"
                + "<strong>当前支付方式</strong><span>" + escapeHtml(paymentChannelLabel(checkout.payChannel || "CAMPUS_CARD")) + "（可在下方“支付方式”海报区切换）</span>"
                + "</div>"
                + "<div class='campus-order-actions'>"
                + "<button id='checkout-submit-btn' class='campus-primary-btn full-width' type='button'>" + (isCreated ? "确认支付" : "提交订单") + "</button>"
                + "</div>"
                + "<p id='checkout-feedback' class='campus-inline-tip'>" + (isCreated ? "订单已创建，选择支付方式后确认付款。" : "选中餐品后可在这里提交订单。") + "</p>";
            document.getElementById("checkout-submit-btn").addEventListener("click", submitCheckout);
            if (currentOrder && currentOrder.status === "UNPAID") {
                const countdownNode = document.getElementById("checkout-countdown");
                if (countdownNode) {
                    const left = getOrderRemainingSeconds(currentOrder);
                    countdownNode.classList.toggle("warn", left != null && left > 0 && left <= 120);
                }
            }
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

        function resetProfileForm() {
            const currentUser = state.currentUser || {};
            document.getElementById("profile-edit-username").value = currentUser.username || "";
            document.getElementById("profile-edit-phone").value = currentUser.phone || "";
            document.getElementById("profile-edit-avatar").value = currentUser.avatarUrl || "/static/img/user.svg";
            document.getElementById("profile-avatar-file").value = "";
            document.getElementById("profile-feedback").textContent = "";
        }

        function bindEvents() {
            document.querySelectorAll("[data-page]").forEach((button) => {
                button.addEventListener("click", function () {
                    switchPage(button.dataset.page);
                });
            });
            document.querySelectorAll("[data-page-link]").forEach((button) => {
                button.addEventListener("click", function () {
                    switchPage(button.dataset.pageLink);
                });
            });
            document.getElementById("study-date").addEventListener("change", function () {
                state.selectedDate = this.value;
                loadSeats();
            });
            document.getElementById("reserve-btn").addEventListener("click", reserveSeat);
            document.getElementById("submit-signup").addEventListener("click", submitActivitySignup);
            document.getElementById("ai-submit").addEventListener("click", function () {
                runWithButton("ai-submit", "思考中...", askAi);
            });
            document.getElementById("ai-clear").addEventListener("click", resetAiChat);
            document.getElementById("ai-question").addEventListener("keydown", function (event) {
                if (event.key === "Enter" && !event.shiftKey) {
                    event.preventDefault();
                    runWithButton("ai-submit", "思考中...", askAi);
                }
            });
            document.getElementById("refresh-orders-btn").addEventListener("click", function () {
                runWithButton("refresh-orders-btn", "刷新中...", loadMyOrders);
            });
            document.getElementById("dish-search-btn").addEventListener("click", function () {
                runWithButton("dish-search-btn", "筛选中...", function () {
                    state.dishFilter.keyword = document.getElementById("dish-search-input").value.trim();
                    state.dishFilter.categoryId = document.getElementById("dish-category-select").value;
                    state.dishFilter.includeSoldOut = document.getElementById("dish-include-soldout").checked;
                    return loadDishes();
                });
            });
            document.getElementById("dish-reset-btn").addEventListener("click", function () {
                runWithButton("dish-reset-btn", "重置中...", function () {
                    state.dishFilter.keyword = "";
                    state.dishFilter.categoryId = "";
                    state.dishFilter.includeSoldOut = true;
                    document.getElementById("dish-search-input").value = "";
                    document.getElementById("dish-category-select").value = "";
                    document.getElementById("dish-include-soldout").checked = true;
                    return loadDishes();
                });
            });
            document.getElementById("upload-profile-avatar-btn").addEventListener("click", function () {
                runWithButton("upload-profile-avatar-btn", "上传中...", uploadProfileAvatar);
            });
            document.getElementById("save-profile-btn").addEventListener("click", function () {
                runWithButton("save-profile-btn", "保存中...", saveProfile);
            });
            document.getElementById("logout-btn").addEventListener("click", async function () {
                await getJson("/api/auth/logout", { method: "POST" });
                window.location.href = "/login";
            });
            document.querySelectorAll("[data-ai-prompt]").forEach((button) => {
                button.addEventListener("click", function () {
                    document.getElementById("ai-question").value = button.dataset.aiPrompt;
                    runWithButton("ai-submit", "思考中...", askAi);
                });
            });
            document.querySelectorAll("[data-pay-pick]").forEach((button) => {
                button.addEventListener("click", function () {
                    pickPayChannel(button.dataset.payPick);
                });
            });
        }

        async function bootstrap() {
            const me = await getJson("/api/auth/me");
            if (!me || !me.success) {
                window.location.href = "/login?clientRequired=1";
                return;
            }
            state.currentUser = me.data;
            document.getElementById("client-avatar").src = me.data.avatarUrl || "/static/img/user.svg";
            document.getElementById("client-username").textContent = me.data.username || "校园用户";
            document.getElementById("client-phone").textContent = me.data.phone || "";
            document.getElementById("profile-username").textContent = me.data.username || "-";
            document.getElementById("profile-phone").textContent = me.data.phone || "-";
            document.getElementById("signup-phone").value = me.data.phone || "";
            document.getElementById("profile-edit-username").value = me.data.username || "";
            document.getElementById("profile-edit-phone").value = me.data.phone || "";
            document.getElementById("profile-edit-avatar").value = me.data.avatarUrl || "/static/img/user.svg";
            document.getElementById("study-date").value = state.selectedDate;
            updateReserveButtonLabel();

            bindModalDismiss();
            registerPanelModal({
                modalId: "profile-edit-modal",
                panelId: "profile-edit-panel",
                triggerIds: ["open-profile-edit-modal"],
                beforeOpen: resetProfileForm,
                reset: resetProfileForm
            });
            bindEvents();
            await loadMerchants();
            await loadStudyRooms();
            await loadActivities();
            await loadMyActivities();
            await loadMyReservations();
            await loadMyOrders();
            startOrderCountdownTicker();
            startOrderSyncTicker();
            renderCheckoutBox();
            updateHomeStats();
            updateHomeHighlights();
        }

        function updateReserveButtonLabel() {
            const reserveButton = document.getElementById("reserve-btn");
            if (!reserveButton) {
                return;
            }
            reserveButton.textContent = state.rescheduleReservationId ? "确认改期" : "确认预约";
        }

        function setReserveLoading(loading) {
            const reserveButton = document.getElementById("reserve-btn");
            if (!reserveButton) {
                return;
            }
            reserveButton.disabled = loading;
            if (loading) {
                reserveButton.textContent = state.rescheduleReservationId ? "改期提交中..." : "预约提交中...";
                return;
            }
            updateReserveButtonLabel();
        }

        async function loadMerchants() {
            const result = await getJson("/api/client/merchants");
            state.merchants = result && result.success ? result.data : [];
            if (state.merchants.length > 0) {
                state.selectedMerchantId = state.selectedMerchantId || state.merchants[0].id;
                renderMerchantMenu();
                renderMerchantHighlight();
                await loadDishCategories();
                await Promise.all([loadPackages(), loadDishes()]);
            } else {
                renderMerchantMenu();
            }
            updateHomeStats();
        }

        async function loadDishCategories() {
            if (!state.selectedMerchantId) {
                state.dishCategories = [];
            } else {
                const result = await getJson("/api/client/merchants/" + state.selectedMerchantId + "/categories");
                state.dishCategories = result && result.success ? result.data : [];
            }
            const select = document.getElementById("dish-category-select");
            const current = state.dishFilter.categoryId || "";
            select.innerHTML = "<option value=''>全部分类</option>" + state.dishCategories.map((item) => {
                return "<option value='" + escapeHtml(item.id) + "'>" + escapeHtml(item.name) + "</option>";
            }).join("");
            if (current) {
                select.value = current;
            }
        }

        function renderMerchantMenu() {
            const host = document.getElementById("merchant-menu");
            host.innerHTML = state.merchants.map((merchant) => {
                const active = merchant.id === state.selectedMerchantId ? " active" : "";
                return "<button type='button' class='campus-side-link" + active + "' data-merchant-id='" + merchant.id + "'>"
                    + "<strong>" + escapeHtml(merchant.name) + "</strong>"
                    + "<span>" + escapeHtml(merchant.canteenName) + "</span></button>";
            }).join("");
            host.querySelectorAll("[data-merchant-id]").forEach((button) => {
                button.addEventListener("click", async function () {
                    state.selectedMerchantId = Number(button.dataset.merchantId);
                    renderMerchantMenu();
                    renderMerchantHighlight();
                    await loadDishCategories();
                    await Promise.all([loadPackages(), loadDishes()]);
                });
            });
        }

        function renderMerchantHighlight() {
            const current = state.merchants.find((item) => item.id === state.selectedMerchantId);
            document.getElementById("merchant-highlight").innerHTML = current
                ? "<strong>" + escapeHtml(current.name) + "</strong><span>" + escapeHtml(current.canteenName) + " / 联系方式：" + escapeHtml(current.contactPhone) + "</span>"
                : "请选择一个商家。";
        }

        function renderMerchantMenuBoard() {
            const host = document.getElementById("merchant-menu-board");
            if (!host) {
                return;
            }
            const current = state.merchants.find((item) => item.id === state.selectedMerchantId);
            if (!current) {
                host.innerHTML = "<div class='campus-empty-card'>请先选择商家。</div>";
                return;
            }
            const dishes = state.selectedMerchantDishes || [];
            const packages = state.selectedMerchantPackages || [];
            const soldOutCount = dishes.filter((item) => !item.onSale).length;
            host.innerHTML = "<div class='campus-zone-card'>"
                + "<div class='campus-zone-head'><strong>" + escapeHtml(current.name) + "</strong><span>菜单总览</span></div>"
                + "<div class='campus-zone-body'>"
                + "<span class='campus-zone-merchant'>菜品 " + escapeHtml(dishes.length) + " 项</span>"
                + "<span class='campus-zone-merchant'>售罄 " + escapeHtml(soldOutCount) + " 项</span>"
                + "<span class='campus-zone-merchant'>套餐 " + escapeHtml(packages.length) + " 项</span>"
                + "<span class='campus-zone-merchant'>位置：" + escapeHtml(current.canteenName || "-") + "</span>"
                + "</div>"
                + "</div>";
        }

        function resolveSeatFloor(seat, index, total) {
            const direct = seat && (seat.floorNo || seat.floor || seat.level || seat.floorName);
            if (direct != null && String(direct).trim()) {
                const text = String(direct).toUpperCase();
                if (text.includes("3")) return "3F";
                if (text.includes("2")) return "2F";
                return "1F";
            }
            const zoneText = String((seat && seat.zoneName) || "").toUpperCase();
            if (zoneText.includes("三") || zoneText.includes("3")) return "3F";
            if (zoneText.includes("二") || zoneText.includes("2")) return "2F";
            if (zoneText.includes("一") || zoneText.includes("1")) return "1F";
            const chunk = Math.ceil(Math.max(total, 1) / 3);
            if (index >= chunk * 2) return "3F";
            if (index >= chunk) return "2F";
            return "1F";
        }

        function buildFloorCinemaLayout(floor, seats) {
            const sorted = (seats || []).slice().sort((a, b) => seatOrderValue(a) - seatOrderValue(b));
            if (floor === "1F") {
                return { sorted: sorted, columns: 14, aisleEvery: 7 };
            }
            if (floor === "2F") {
                return { sorted: sorted, columns: 16, aisleEvery: 8 };
            }
            return { sorted: sorted, columns: 12, aisleEvery: 6 };
        }

        function seatLabelText(seat, fallbackIndex) {
            if (seat && seat.seatCode && String(seat.seatCode).trim()) {
                return String(seat.seatCode).trim();
            }
            return "S" + String(fallbackIndex + 1).padStart(3, "0");
        }

        function seatNumberText(seat, rowIndex, seatIndex) {
            const label = seatLabelText(seat, rowIndex * 100 + seatIndex);
            const matched = label.match(/(\d+)(?!.*\d)/);
            if (matched) {
                return String(Number(matched[1]));
            }
            return String(seatIndex + 1);
        }

        function renderStudyCinemaByFloor(rows) {
            const host = document.getElementById("study-floorplan");
            if (!host) {
                return;
            }
            if (!rows.length) {
                host.innerHTML = "<div class='campus-empty-card'>当前时段暂无可用座位。</div>";
                return;
            }
            const floors = { "1F": [], "2F": [], "3F": [] };
            rows.forEach((seat, index) => {
                floors[resolveSeatFloor(seat, index, rows.length)].push(seat);
            });
            if (!floors[state.selectedStudyFloor] || !floors[state.selectedStudyFloor].length) {
                state.selectedStudyFloor = Object.keys(floors).find((key) => floors[key].length) || "1F";
            }
            const floorStats = Object.keys(floors).map((floor) => {
                const list = floors[floor];
                return {
                    floor: floor,
                    total: list.length,
                    free: list.filter((item) => item.status === "FREE").length,
                    booked: list.filter((item) => item.status !== "FREE").length
                };
            });
            const current = floors[state.selectedStudyFloor] || [];
            const layout = buildFloorCinemaLayout(state.selectedStudyFloor, current);
            const rowsHtml = [];
            for (let offset = 0; offset < layout.sorted.length; offset += layout.columns) {
                const rowSeats = layout.sorted.slice(offset, offset + layout.columns);
                const rowNumber = Math.floor(offset / layout.columns) + 1;
                const filledSeats = rowSeats.slice();
                while (filledSeats.length < layout.columns) {
                    filledSeats.push(null);
                }
                const seatNodes = filledSeats.map((seat, index) => {
                    if (!seat) {
                        return "<button type='button' class='campus-study-seat-btn placeholder' disabled aria-hidden='true'><span>--</span></button>";
                    }
                    const busy = seat.status !== "FREE";
                    const active = seat.id === state.selectedSeatId ? " active" : "";
                    const cls = busy ? " booked" : " free";
                    const label = seatLabelText(seat, offset + index);
                    const seatNo = seatNumberText(seat, rowNumber - 1, index);
                    const hint = state.selectedStudyFloor + " " + rowNumber + "排-" + seatNo + "座";
                    return "<button type='button' class='campus-study-seat-btn" + cls + active + "' data-floor-seat='" + seat.id + "' " + (busy ? "disabled" : "") + " title='" + escapeHtml(hint + "（" + label + "）") + "'>"
                        + "<span>" + escapeHtml(seatNo) + "</span></button>";
                }).join("");
                rowsHtml.push("<div class='campus-cinema-row'><span class='campus-cinema-row-no'>" + String(rowNumber) + "排</span>"
                    + "<div class='campus-study-seat-grid campus-cinema-seat-grid' style='--seat-cols:" + layout.columns + ";'>" + seatNodes + "</div></div>");
            }
            const summary = floorStats.find((item) => item.floor === state.selectedStudyFloor) || { free: 0, total: 0 };
            host.innerHTML = "<div class='campus-cinema-wrap'>"
                + "<div class='campus-cinema-screen'>屏幕（阅读主区）</div>"
                + "<div class='campus-cinema-floor-tabs'>"
                + floorStats.map((item) => {
                    const active = item.floor === state.selectedStudyFloor ? " active" : "";
                    return "<button type='button' class='campus-chip" + active + "' data-floor-tab='" + item.floor + "'>"
                        + item.floor + " · 空闲 " + item.free + " / 已约 " + item.booked + "</button>";
                }).join("")
                + "</div>"
                + "<div class='campus-cinema-meta'>"
                + "<span>左侧显示排号，座位内显示座号（悬停可看完整编号）。</span>"
                + "<span>当前楼层： " + escapeHtml(state.selectedStudyFloor) + " · 可选 " + escapeHtml(summary.free) + " / 总计 " + escapeHtml(summary.total) + "</span>"
                + "</div>"
                + "<div class='campus-cinema-map'>" + rowsHtml.join("") + "</div>"
                + "</div>";
            host.querySelectorAll("[data-floor-tab]").forEach((button) => {
                button.addEventListener("click", function () {
                    state.selectedStudyFloor = button.dataset.floorTab;
                    renderStudyCinemaByFloor(rows);
                });
            });
            host.querySelectorAll("[data-floor-seat]").forEach((button) => {
                button.addEventListener("click", function () {
                    state.selectedSeatId = Number(button.dataset.floorSeat);
                    renderSeatSelectionSummary(rows);
                    renderStudyCinemaByFloor(rows);
                });
            });
        }

        async function loadDishes() {
            if (!state.selectedMerchantId) {
                return;
            }
            const query = new URLSearchParams();
            query.set("pageNum", "1");
            query.set("pageSize", "80");
            if (state.dishFilter.keyword) {
                query.set("keyword", state.dishFilter.keyword);
            }
            if (state.dishFilter.categoryId) {
                query.set("categoryId", state.dishFilter.categoryId);
            }
            query.set("includeSoldOut", state.dishFilter.includeSoldOut ? "true" : "false");
            const result = await getJson("/api/client/merchants/" + state.selectedMerchantId + "/dishes?" + query.toString());
            const rows = result && result.success ? getPageRows(result.data) : [];
            state.selectedMerchantDishes = rows;
            renderMerchantMenuBoard();
            document.getElementById("dish-list").innerHTML = rows.length ? rows.map((dish) => {
                const soldOut = dish.onSale === false;
                return "<article class='campus-dish-tile" + (soldOut ? " sold-out" : "") + "'>"
                    + "<div class='campus-dish-photo'><img src='" + escapeHtml(dish.imageUrl || "/static/img/dishes/chicken-breast-bowl.jpg") + "' alt='" + escapeHtml(dish.name) + "'></div>"
                    + "<div class='campus-dish-info'>"
                    + (soldOut ? "<span class='campus-soldout-badge'>已售罄</span>" : "<span class='campus-soldout-badge available'>在售</span>")
                    + "<strong>" + escapeHtml(dish.name) + "</strong>"
                    + "<p>" + escapeHtml(dish.description) + "</p>"
                    + "<div class='campus-dish-meta'><span>" + (soldOut ? "已售罄" : ("热量 " + escapeHtml(dish.calories) + " kcal")) + "</span><b>￥" + escapeHtml(dish.price) + "</b></div>"
                    + "<button class='campus-primary-btn full-width campus-top-gap-small' type='button' data-buy-dish='" + dish.id + "' data-dish-name='" + escapeHtml(dish.name) + "' data-dish-price='" + escapeHtml(dish.price) + "' " + (soldOut ? "disabled" : "") + ">" + (soldOut ? "暂不可下单" : "立即下单") + "</button></div></article>";
            }).join("") : "<div class='campus-empty-card'>当前筛选条件下暂无菜品，请调整筛选条件或去后台补充。</div>";
            document.querySelectorAll("[data-buy-dish]").forEach((button) => {
                button.addEventListener("click", function () {
                    if (button.disabled) {
                        return;
                    }
                    selectCheckoutItem({
                        merchantId: state.selectedMerchantId,
                        itemType: "DISH",
                        itemName: button.dataset.dishName,
                        totalAmount: button.dataset.dishPrice
                    });
                });
            });
        }

        async function loadPackages() {
            if (!state.selectedMerchantId) {
                return;
            }
            const result = await getJson("/api/client/merchants/" + state.selectedMerchantId + "/packages");
            const rows = result && result.success ? result.data : [];
            state.packages = rows;
            state.selectedMerchantPackages = rows;
            renderMerchantMenuBoard();
            const packageHost = document.getElementById("merchant-packages");
            if (packageHost) {
                packageHost.innerHTML = rows.length ? rows.map((item) => {
                    return "<article class='campus-package-card'>"
                        + "<span class='campus-status-tag'>" + escapeHtml(item.theme || "套餐") + "</span>"
                        + "<strong>" + escapeHtml(item.name) + "</strong>"
                        + "<p>" + escapeHtml(item.description || "标准化套餐组合，满足校园日常用餐需求。") + "</p>"
                        + "<div class='campus-dish-meta'><span>" + escapeHtml(item.status || "ONLINE") + "</span><b>￥" + escapeHtml(item.price) + "</b></div>"
                        + "<button class='campus-primary-btn full-width campus-top-gap-small' type='button' data-buy-package='" + item.id + "' data-package-name='" + escapeHtml(item.name) + "' data-package-price='" + escapeHtml(item.price) + "'>立即下单</button>"
                        + "</article>";
                }).join("") : "<div class='campus-empty-card'>当前商家还没有套餐，可以去后台端新增。</div>";
                packageHost.querySelectorAll("[data-buy-package]").forEach((button) => {
                    button.addEventListener("click", function () {
                        selectCheckoutItem({
                            merchantId: state.selectedMerchantId,
                            itemType: "PACKAGE",
                            itemName: button.dataset.packageName,
                            totalAmount: button.dataset.packagePrice
                        });
                    });
                });
            }
            updateHomeHighlights();
        }

        async function loadStudyRooms() {
            const result = await getJson("/api/client/study-rooms");
            state.studyRooms = result && result.success ? result.data : [];
            if (state.studyRooms.length > 0) {
                state.selectedRoomId = state.selectedRoomId || state.studyRooms[0].id;
            }
            renderRoomCards();
            renderDurationChips();
            renderTimeSlots();
            await loadSeats();
            updateHomeStats();
        }

        function renderRoomCards() {
            const host = document.getElementById("room-cards");
            host.innerHTML = state.studyRooms.map((room) => {
                const active = room.id === state.selectedRoomId ? " active" : "";
                return "<button type='button' class='campus-room-card" + active + "' data-room-id='" + room.id + "'>"
                    + "<strong>" + escapeHtml(room.name) + "</strong>"
                    + "<span>" + escapeHtml(room.location) + "</span>"
                    + "<em>" + escapeHtml(formatTimeOnly(room.openTime)) + " - " + escapeHtml(formatTimeOnly(room.closeTime)) + "</em></button>";
            }).join("");
            host.querySelectorAll("[data-room-id]").forEach((button) => {
                button.addEventListener("click", async function () {
                    state.selectedRoomId = Number(button.dataset.roomId);
                    const room = getCurrentRoom();
                    state.selectedDuration = Math.min(state.selectedDuration, Number(room.maxHours || 2));
                    state.selectedSlot = null;
                    state.selectedSeatId = null;
                    renderRoomCards();
                    renderDurationChips();
                    renderTimeSlots();
                    await loadSeats();
                });
            });
            renderStudyRoomSummary();
        }

        function renderStudyRoomSummary() {
            const room = getCurrentRoom();
            document.getElementById("study-room-summary").innerHTML = room
                ? "<strong>" + escapeHtml(room.name) + "</strong><span>地点：" + escapeHtml(room.location) + " / 开放 " + escapeHtml(formatTimeOnly(room.openTime)) + "-" + escapeHtml(formatTimeOnly(room.closeTime)) + " / 单次最多 " + escapeHtml(room.maxHours) + " 小时</span>"
                : "请选择自习室。";
        }

        function renderDurationChips() {
            const room = getCurrentRoom();
            const maxHours = room ? Number(room.maxHours || 1) : 1;
            if (state.selectedDuration > maxHours) {
                state.selectedDuration = maxHours;
            }
            document.getElementById("duration-chips").innerHTML = Array.from({ length: maxHours }, function (_, index) {
                const hour = index + 1;
                const active = hour === state.selectedDuration ? " campus-chip-active" : "";
                return "<button type='button' class='campus-chip" + active + "' data-duration='" + hour + "'>" + hour + " 小时</button>";
            }).join("");
            document.querySelectorAll("[data-duration]").forEach((button) => {
                button.addEventListener("click", async function () {
                    state.selectedDuration = Number(button.dataset.duration);
                    state.selectedSlot = null;
                    state.selectedSeatId = null;
                    renderDurationChips();
                    renderTimeSlots();
                    await loadSeats();
                });
            });
        }

        function addHours(timeText, hours) {
            const parts = timeText.split(":").map(Number);
            const total = parts[0] * 60 + parts[1] + hours * 60;
            const hour = Math.floor(total / 60);
            const minute = total % 60;
            return String(hour).padStart(2, "0") + ":" + String(minute).padStart(2, "0");
        }

        function renderTimeSlots() {
            const room = getCurrentRoom();
            if (!room) {
                document.getElementById("slot-chips").innerHTML = "";
                return;
            }
            const open = formatTimeOnly(room.openTime);
            const close = formatTimeOnly(room.closeTime);
            const openHour = Number(open.slice(0, 2));
            const closeHour = Number(close.slice(0, 2));
            const slots = [];
            for (let hour = openHour; hour + state.selectedDuration <= closeHour; hour++) {
                const start = String(hour).padStart(2, "0") + ":00";
                const end = addHours(start, state.selectedDuration);
                slots.push({ start: start, end: end, label: start + " - " + end });
            }
            if (!state.selectedSlot && slots.length > 0) {
                state.selectedSlot = slots[0];
            }
            const host = document.getElementById("slot-chips");
            host.innerHTML = slots.map((slot) => {
                const active = state.selectedSlot && slot.start === state.selectedSlot.start ? " campus-chip-active" : "";
                return "<button type='button' class='campus-chip" + active + "' data-slot-start='" + slot.start + "' data-slot-end='" + slot.end + "'>" + escapeHtml(slot.label) + "</button>";
            }).join("");
            host.querySelectorAll("[data-slot-start]").forEach((button) => {
                button.addEventListener("click", async function () {
                    state.selectedSlot = {
                        start: button.dataset.slotStart,
                        end: button.dataset.slotEnd
                    };
                    state.selectedSeatId = null;
                    renderTimeSlots();
                    await loadSeats();
                });
            });
        }

        function renderSeatSelectionSummary(rows) {
            const room = getCurrentRoom();
            const summary = document.getElementById("seat-selection-summary");
            if (!room) {
                summary.innerHTML = "<strong>预约摘要</strong><span>请先选择自习室。</span>";
                return;
            }
            const currentSeat = rows.find((item) => item.id === state.selectedSeatId);
            const slotLabel = state.selectedSlot
                ? state.selectedSlot.start + " - " + state.selectedSlot.end
                : formatTimeOnly(room.openTime) + " - " + addHours(formatTimeOnly(room.openTime), state.selectedDuration);
            const seatLabel = currentSeat
                ? currentSeat.seatCode + " · " + (currentSeat.zoneName || "学习区")
                : "请在下方选择一个绿色座位";
            summary.innerHTML = "<strong>当前预约摘要</strong>"
                + "<div class='campus-seat-selection-meta'>"
                + "<span>日期：" + escapeHtml(state.selectedDate) + "</span>"
                + "<span>时段：" + escapeHtml(slotLabel) + "</span>"
                + "<span>座位：" + escapeHtml(seatLabel) + "</span>"
                + (state.rescheduleReservationId
                    ? "<span>改期单号：#" + escapeHtml(state.rescheduleReservationId) + "</span>"
                    : "")
                + "</div>";
        }

        async function useReservationForReschedule(reservationId) {
            const record = state.myReservations.find((item) => item.id === reservationId);
            if (!record || record.status !== "BOOKED") {
                return;
            }
            state.rescheduleReservationId = reservationId;
            state.selectedRoomId = Number(record.studyRoomId);
            state.selectedDate = formatDateOnly(record.reservationDate);
            document.getElementById("study-date").value = state.selectedDate;
            const start = formatTimeOnly(record.startTime);
            const end = formatTimeOnly(record.endTime);
            const startHour = Number(start.slice(0, 2));
            const endHour = Number(end.slice(0, 2));
            const duration = Math.max(1, endHour - startHour);
            const room = getCurrentRoom();
            state.selectedDuration = room ? Math.min(duration, Number(room.maxHours || duration)) : duration;
            state.selectedSlot = { start: start, end: end };
            state.selectedSeatId = Number(record.seatId);
            renderRoomCards();
            renderDurationChips();
            renderTimeSlots();
            await loadSeats();
            updateReserveButtonLabel();
            document.getElementById("reserve-message").textContent = "已载入原预约，可重新选择日期/时段/座位后提交改期。";
            switchPage("study");
        }

        function seatOrderValue(seat) {
            const code = String(seat && seat.seatCode ? seat.seatCode : "");
            const matched = code.match(/(\d+)(?!.*\d)/);
            if (matched) {
                return Number(matched[1]);
            }
            return Number(seat && seat.id ? seat.id : 0);
        }

        async function loadSeats() {
            const room = getCurrentRoom();
            if (!room) {
                return;
            }
            const query = new URLSearchParams({
                reservationDate: state.selectedDate,
                startTime: state.selectedSlot ? state.selectedSlot.start : formatTimeOnly(room.openTime),
                endTime: state.selectedSlot ? state.selectedSlot.end : addHours(formatTimeOnly(room.openTime), state.selectedDuration)
            });
            const result = await getJson("/api/client/study-rooms/" + room.id + "/seats?" + query.toString());
            const rows = result && result.success ? result.data : [];
            if (!rows.some((item) => item.id === state.selectedSeatId && item.status === "FREE")) {
                const firstFree = rows.find((item) => item.status === "FREE");
                state.selectedSeatId = firstFree ? firstFree.id : null;
            }
            renderSeatSelectionSummary(rows);
            renderStudyCinemaByFloor(rows);
        }

        async function reserveSeat() {
            if (state.loading.reserve) {
                return;
            }
            if (!state.selectedSlot) {
                document.getElementById("reserve-message").textContent = "请先选择时间段。";
                return;
            }
            if (!state.selectedSeatId) {
                document.getElementById("reserve-message").textContent = "请先选择可预约的座位。";
                return;
            }
            const payload = {
                roomId: state.selectedRoomId,
                seatId: state.selectedSeatId,
                reservationDate: state.selectedDate,
                startTime: state.selectedSlot.start,
                endTime: state.selectedSlot.end
            };
            state.loading.reserve = true;
            setReserveLoading(true);
            document.getElementById("reserve-message").textContent = state.rescheduleReservationId
                ? "改期提交中，请勿重复点击..."
                : "预约提交中，请勿重复点击...";
            try {
                const requestUrl = state.rescheduleReservationId
                    ? "/api/client/study-rooms/reservations/" + state.rescheduleReservationId + "/reschedule"
                    : "/api/client/study-rooms/reserve";
                const result = await getJson(requestUrl, {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: JSON.stringify(payload)
                });
                document.getElementById("reserve-message").textContent = result && result.success
                    ? (state.rescheduleReservationId ? "改期成功，预约信息已更新。" : "预约成功，凭证：" + result.data.voucherCode)
                    : (result ? result.message : "预约失败，请重新登录");
                if (result && result.success) {
                    state.rescheduleReservationId = null;
                    updateReserveButtonLabel();
                    await Promise.all([loadMyReservations(), loadSeats()]);
                    updateHomeStats();
                }
            } finally {
                state.loading.reserve = false;
                setReserveLoading(false);
            }
        }

        async function cancelReservation(reservationId, triggerButton) {
            if (state.loading.cancelReservationId === reservationId) {
                return;
            }
            state.loading.cancelReservationId = reservationId;
            const button = triggerButton || null;
            const originalText = button ? button.textContent : "";
            if (button) {
                button.disabled = true;
                button.textContent = "取消中...";
            }
            document.getElementById("reserve-message").textContent = "正在取消预约，请稍候...";
            try {
                const result = await getJson("/api/client/study-rooms/reservations/" + reservationId + "/cancel", {
                    method: "POST"
                });
                document.getElementById("reserve-message").textContent = result ? result.message : "取消失败";
                if (result && result.success) {
                    if (state.rescheduleReservationId === reservationId) {
                        state.rescheduleReservationId = null;
                        updateReserveButtonLabel();
                    }
                    await Promise.all([loadMyReservations(), loadSeats()]);
                    updateHomeStats();
                }
            } finally {
                if (button) {
                    button.disabled = false;
                    button.textContent = originalText || "取消预约";
                }
                state.loading.cancelReservationId = null;
            }
        }

        async function loadMyReservations() {
            const result = await getJson("/api/client/study-rooms/reservations/mine");
            const rows = result && result.success ? result.data : [];
            state.myReservations = rows;
            if (state.rescheduleReservationId && !rows.some((item) => item.id === state.rescheduleReservationId && item.status === "BOOKED")) {
                state.rescheduleReservationId = null;
                updateReserveButtonLabel();
            }
            document.getElementById("reservation-list").innerHTML = rows.length ? rows.map((item) => {
                const isBooked = item.status === "BOOKED";
                const action = isBooked
                    ? "<div class='admin-inline-actions'>"
                        + "<button class='campus-light-btn' type='button' data-reschedule-id='" + item.id + "'>改期</button>"
                        + "<button class='campus-light-btn' type='button' data-cancel-reservation-id='" + item.id + "'>取消预约</button>"
                        + "</div>"
                    : "<span class='campus-status-tag muted'>已取消</span>";
                return "<div class='campus-list-card'>"
                    + "<div><strong>" + escapeHtml(item.studyRoomName || ("自习室 " + item.studyRoomId)) + "</strong>"
                    + "<p>座位 " + escapeHtml(item.seatCode || item.seatId) + " / " + escapeHtml(formatDateOnly(item.reservationDate)) + " / " + escapeHtml(formatTimeOnly(item.startTime)) + "-" + escapeHtml(formatTimeOnly(item.endTime)) + "</p>"
                    + "<span class='campus-card-meta'>凭证：" + escapeHtml(item.voucherCode) + " / " + escapeHtml(reservationStatusLabel(item.status)) + "</span></div>"
                    + action
                    + "</div>";
            }).join("") : "<div class='campus-empty-card'>当前还没有预约记录，先去上方完成一次预约。</div>";
            document.querySelectorAll("[data-cancel-reservation-id]").forEach((button) => {
                button.addEventListener("click", function () {
                    cancelReservation(Number(button.dataset.cancelReservationId), button);
                });
            });
            document.querySelectorAll("[data-reschedule-id]").forEach((button) => {
                button.addEventListener("click", function () {
                    useReservationForReschedule(Number(button.dataset.rescheduleId));
                });
            });
            updateHomeStats();
            updateHomeHighlights();
        }

        async function loadActivities() {
            const result = await getJson("/api/client/activities");
            const rows = result && result.success ? result.data : [];
            state.activities = rows;
            document.getElementById("all-activities").innerHTML = rows.length ? rows.map((activity) => {
                return "<div class='campus-list-card with-poster activity-list-card" + (state.currentActivityId === activity.id ? " is-selected" : "") + "' data-act-card-id='" + activity.id + "'>"
                    + "<img class='campus-activity-poster' src='" + escapeHtml(activity.posterUrl || "/static/img/activity-1.svg") + "' alt='" + escapeHtml(activity.title) + "'>"
                    + "<div class='activity-card-info'><strong class='activity-card-title'>" + escapeHtml(activity.title) + "</strong>"
                    + "<p>" + escapeHtml(activity.summary) + "</p>"
                    + "<span class='campus-card-meta'>" + escapeHtml(activity.location) + " / " + escapeHtml(formatDateTime(activity.startTime)) + "</span></div>"
                    + "<button class='campus-light-btn activity-card-action' type='button' data-activity-id='" + activity.id + "'>" + (state.currentActivityId === activity.id ? "已选择" : "选择报名") + "</button></div>";
            }).join("") : "<div class='campus-empty-card'>当前还没有可报名活动。</div>";
            document.querySelectorAll("[data-activity-id]").forEach((button) => {
                button.addEventListener("click", function () {
                    selectActivity(Number(button.dataset.activityId));
                });
            });
            updateHomeHighlights();
        }

        function selectActivity(activityId) {
            state.currentActivityId = activityId;
            const matched = state.activities.find((item) => item.id === activityId);
            document.getElementById("activity-selected-tip").textContent = matched
                ? "当前选中：" + matched.title + "（" + (matched.location || "校园活动") + " / " + formatDateTime(matched.startTime) + "）"
                : "当前已选中一个活动。";
            document.querySelectorAll("[data-act-card-id]").forEach((card) => {
                card.classList.toggle("is-selected", Number(card.dataset.actCardId) === activityId);
                const button = card.querySelector("[data-activity-id]");
                if (button) {
                    button.textContent = Number(card.dataset.actCardId) === activityId ? "已选择" : "选择报名";
                }
            });
            if (!document.getElementById("signup-phone").value.trim()) {
                document.getElementById("signup-phone").value = state.currentUser.phone || "";
            }
        }

        async function submitActivitySignup() {
            if (state.loading.activity) {
                return;
            }
            if (!state.currentActivityId) {
                document.getElementById("activity-feedback").textContent = "请先从左侧活动列表选择一个活动。";
                return;
            }
            const payload = {
                activityId: state.currentActivityId,
                realName: document.getElementById("signup-real-name").value.trim(),
                studentNo: document.getElementById("signup-student-no").value.trim(),
                contactPhone: document.getElementById("signup-phone").value.trim()
            };
            state.loading.activity = true;
            try {
                const result = await getJson("/api/client/activities/signup", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: JSON.stringify(payload)
                });
                document.getElementById("activity-feedback").textContent = result ? result.message : "报名失败";
                await loadMyActivities();
                updateHomeStats();
            } finally {
                state.loading.activity = false;
            }
        }

        async function loadMyActivities() {
            const result = await getJson("/api/client/activities/mine");
            const rows = result && result.success ? result.data : [];
            state.myActivities = rows;
            document.getElementById("my-activities").innerHTML = rows.length ? rows.map((registration) => {
                const activity = state.activities.find((item) => item.id === registration.activityId);
                const action = registration.status === "REGISTERED"
                    ? "<button class='campus-light-btn' type='button' data-cancel-id='" + registration.activityId + "'>取消报名</button>"
                    : "<span class='campus-status-tag muted'>已取消</span>";
                return "<div class='campus-list-card activity-my-card'>"
                    + "<div><strong>" + escapeHtml(activity ? activity.title : ("活动 #" + registration.activityId)) + "</strong>"
                    + "<p>" + escapeHtml(registration.realName) + " / " + escapeHtml(registration.studentNo) + " / " + escapeHtml(registration.status === "REGISTERED" ? "已报名" : "已取消") + "</p>"
                    + "<span class='campus-card-meta'>" + escapeHtml(activity ? activity.location : "校园活动") + "</span></div>"
                    + action + "</div>";
            }).join("") : "<div class='campus-empty-card'>当前还没有报名记录，先从左侧选择一个活动。</div>";
            document.querySelectorAll("[data-cancel-id]").forEach((button) => {
                button.addEventListener("click", function () {
                    cancelSignUp(Number(button.dataset.cancelId));
                });
            });
            updateHomeStats();
            updateHomeHighlights();
        }

        async function cancelSignUp(activityId) {
            const result = await getJson("/api/client/activities/" + activityId + "/cancel", { method: "POST" });
            document.getElementById("activity-feedback").textContent = result ? result.message : "取消失败";
            await loadMyActivities();
            updateHomeStats();
        }

        async function loadMyOrders() {
            const result = await getJson("/api/client/orders/mine");
            const rows = result && result.success ? result.data : [];
            state.myOrders = rows;
            document.getElementById("order-list").innerHTML = rows.length ? rows.map((order) => {
                const action = order.status === "UNPAID"
                    ? "<button class='campus-light-btn' type='button' data-pay-order='" + order.id + "'>继续支付</button>"
                    : "<span class='campus-status-tag" + (order.status === "REFUND" ? " muted" : "") + "'>" + escapeHtml(orderStatusLabel(order.status)) + "</span>";
                const countdown = order.status === "UNPAID"
                    ? "<span class='campus-card-meta campus-order-countdown' data-order-countdown-id='" + order.id + "'>" + escapeHtml(buildOrderCountdownText(order)) + "</span>"
                    : "";
                return "<div class='campus-list-card'>"
                    + "<div><strong>" + escapeHtml(order.itemName) + "</strong>"
                    + "<p>" + escapeHtml(order.merchantName || ("商家 #" + order.merchantId)) + " / " + escapeHtml(order.itemType === "PACKAGE" ? "套餐订单" : "菜品订单") + "</p>"
                    + "<span class='campus-card-meta'>金额：￥" + escapeHtml(order.totalAmount) + " / 支付方式：" + escapeHtml(paymentChannelLabel(order.payChannel)) + " / 状态：" + escapeHtml(orderStatusLabel(order.status)) + "</span>"
                    + countdown
                    + "</div>"
                    + action + "</div>";
            }).join("") : "<div class='campus-empty-card'>当前还没有订单，去餐饮页选一份餐品试试支付流程。</div>";
            document.querySelectorAll("[data-pay-order]").forEach((button) => {
                button.addEventListener("click", function () {
                    reuseOrder(Number(button.dataset.payOrder));
                });
            });
            refreshOrderCountdownTexts();
            updateHomeStats();
        }

        async function submitCheckout() {
            if (state.loading.checkout) {
                return;
            }
            const checkout = state.checkout;
            const feedback = document.getElementById("checkout-feedback");
            if (!checkout.itemName) {
                feedback.textContent = "请先选择一个菜品或套餐。";
                return;
            }
            state.loading.checkout = true;
            const submitButton = document.getElementById("checkout-submit-btn");
            const originalText = submitButton ? submitButton.textContent : "";
            if (submitButton) {
                submitButton.disabled = true;
                submitButton.textContent = checkout.orderId ? "支付处理中..." : "订单提交中...";
            }
            feedback.textContent = checkout.orderId ? "正在发起支付，请稍候..." : "正在创建订单，请稍候...";
            try {
                if (!checkout.orderId) {
                    const result = await getJson("/api/client/orders", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json",
                            "X-Requested-With": "XMLHttpRequest"
                        },
                        body: JSON.stringify({
                            merchantId: checkout.merchantId,
                            itemType: checkout.itemType,
                            itemName: checkout.itemName,
                            totalAmount: checkout.totalAmount
                        })
                    });
                    if (!result || !result.success) {
                        feedback.textContent = result ? result.message : "订单创建失败";
                        return;
                    }
                    state.checkout = {
                        orderId: result.data.id,
                        merchantId: result.data.merchantId,
                        itemType: result.data.itemType,
                        itemName: result.data.itemName,
                        totalAmount: result.data.totalAmount,
                        payChannel: checkout.payChannel,
                        status: result.data.status
                    };
                    feedback.textContent = "订单已创建，点击一次确认支付即可完成付款。";
                    await loadMyOrders();
                    renderCheckoutBox();
                    return;
                }
                const payResult = await getJson("/api/client/orders/" + checkout.orderId + "/pay", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: JSON.stringify({ payChannel: checkout.payChannel })
                });
                if (!payResult || !payResult.success) {
                    feedback.textContent = payResult ? payResult.message : "支付失败";
                    return;
                }
                feedback.textContent = "支付成功，已加入我的订单记录。";
                state.checkout = {
                    orderId: null,
                    merchantId: null,
                    itemType: null,
                    itemName: "",
                    totalAmount: "",
                    payChannel: "CAMPUS_CARD",
                    status: null
                };
                await loadMyOrders();
                renderCheckoutBox();
            } finally {
                state.loading.checkout = false;
                if (submitButton) {
                    submitButton.disabled = false;
                    submitButton.textContent = originalText;
                }
            }
        }

        async function uploadProfileAvatar() {
            const feedback = document.getElementById("profile-feedback");
            const file = document.getElementById("profile-avatar-file").files[0];
            if (!file) {
                feedback.textContent = "请先选择头像图片。";
                return;
            }
            const formData = new FormData();
            formData.append("file", file);
            try {
                const response = await axios.post("/api/auth/uploads/avatar", formData, {
                    withCredentials: true,
                    headers: {
                        "X-Requested-With": "XMLHttpRequest"
                    }
                });
                const data = response.data;
                if (!data || data.success === false) {
                    feedback.textContent = normalizeApiErrorMessage(data && data.message, response.status);
                    return;
                }
                document.getElementById("profile-edit-avatar").value = data.data.url;
                feedback.textContent = "头像已上传，请点击保存资料。";
            } catch (error) {
                feedback.textContent = resolveAxiosError(error);
            }
        }

        async function saveProfile() {
            if (state.loading.profile) {
                return;
            }
            const feedback = document.getElementById("profile-feedback");
            const payload = {
                username: document.getElementById("profile-edit-username").value.trim(),
                phone: document.getElementById("profile-edit-phone").value.trim(),
                avatarUrl: document.getElementById("profile-edit-avatar").value.trim()
            };
            if (!payload.username) {
                feedback.textContent = "姓名不能为空。";
                return;
            }
            if (!payload.phone) {
                feedback.textContent = "手机号不能为空。";
                return;
            }
            state.loading.profile = true;
            try {
                const result = await getJson("/api/auth/profile", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: JSON.stringify(payload)
                });
                if (!result || !result.success) {
                    feedback.textContent = result ? result.message : "保存失败";
                    return;
                }
                state.currentUser = result.data;
                document.getElementById("client-avatar").src = result.data.avatarUrl || "/static/img/user.svg";
                document.getElementById("client-username").textContent = result.data.username || "校园用户";
                document.getElementById("client-phone").textContent = result.data.phone || "";
                document.getElementById("profile-username").textContent = result.data.username || "-";
                document.getElementById("profile-phone").textContent = result.data.phone || "-";
                document.getElementById("signup-phone").value = result.data.phone || "";
                feedback.textContent = "个人资料更新成功。";
                closeModal("profile-edit-modal", false);
            } finally {
                state.loading.profile = false;
            }
        }

        async function askAi() {
            const questionInput = document.getElementById("ai-question");
            const question = (questionInput.value || "").trim();
            if (!question) {
                appendAiMessage("system", "请输入问题后再发送。");
                return;
            }
            appendAiMessage("user", question);
            clearAiInput(questionInput);
            const pendingNode = appendAiMessage("ai", "正在同步最新业务数据...");
            await Promise.all([loadMerchants(), loadStudyRooms(), loadActivities(), loadMyOrders()]);
            const syncedAt = formatNowDateTime();
            if (pendingNode) {
                pendingNode.textContent = "数据已同步，正在生成 AI 回复...";
            }
            const result = await getJson("/api/client/ai/chat", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest"
                },
                body: JSON.stringify({
                    scene: "校园生活服务",
                    question: question
                })
            });
            if (pendingNode && pendingNode.parentElement) {
                pendingNode.parentElement.remove();
            }
            appendAiMessage("ai", result && result.success
                ? (result.data.answer + "\n\n数据同步时间：" + syncedAt)
                : (result ? result.message : "AI 服务暂时不可用"));
            clearAiInput(questionInput);
        }

        function clearAiInput(input) {
            if (!input) {
                return;
            }
            input.blur();
            input.value = "";
            input.defaultValue = "";
            input.textContent = "";
            input.dispatchEvent(new Event("input", { bubbles: true }));
            window.setTimeout(function () {
                input.value = "";
                input.defaultValue = "";
                input.textContent = "";
            }, 0);
            window.requestAnimationFrame(function () {
                input.value = "";
                input.defaultValue = "";
                input.textContent = "";
                input.focus();
            });
        }

        function appendAiMessage(role, text) {
            const log = document.getElementById("ai-chat-log");
            if (!log) {
                return null;
            }
            const item = document.createElement("article");
            item.className = "campus-ai-msg " + (role === "user"
                ? "campus-ai-msg-user"
                : (role === "ai" ? "campus-ai-msg-ai" : "campus-ai-msg-system"));
            const bubble = document.createElement("div");
            bubble.className = "campus-ai-bubble";
            bubble.textContent = text;
            const time = document.createElement("time");
            time.textContent = role === "system" ? "系统" : formatNowDateTime().slice(11, 16);
            item.appendChild(bubble);
            item.appendChild(time);
            log.appendChild(item);
            log.scrollTop = log.scrollHeight;
            return bubble;
        }

        function resetAiChat() {
            const log = document.getElementById("ai-chat-log");
            if (!log) {
                return;
            }
            const questionInput = document.getElementById("ai-question");
            if (questionInput) {
                clearAiInput(questionInput);
            }
            log.innerHTML = "<article class='campus-ai-msg campus-ai-msg-system'>"
                + "<div class='campus-ai-bubble'>已清空对话。你可以继续提问，我会基于最新业务数据回答。</div>"
                + "<time>系统</time>"
                + "</article>";
        }

        bootstrap();
    })();
</script>
</body>
</html>
