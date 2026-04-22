<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>智慧校园生活服务平台 - 后台端</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/static/css/main.css">
    <link rel="stylesheet" href="/static/vendor/fullcalendar/index.global.min.css">
</head>
<body class="campus-admin-body" data-admin-page="${activeAdminPage!'overview'}">
<div class="campus-admin-layout">
    <header class="campus-admin-header">
        <div class="campus-admin-logo">
            <span class="campus-admin-logo-mark">CampusAI</span>
            <span>智慧校园生活服务平台</span>
        </div>
        <div class="campus-admin-userbar">
            <span>后台管理端</span>
            <a href="/admin/overview" class="campus-admin-home">控制台</a>
            <a href="/logout" class="campus-admin-logout">退出</a>
        </div>
    </header>

    <div class="campus-admin-main">
        <aside class="campus-admin-sidebar">
            <a href="/admin/overview" class="active" data-target="overview">统计分析</a>
            <a href="/admin/merchant" data-target="merchant">商家管理</a>
            <a href="/admin/dish" data-target="dish">菜品与套餐</a>
            <a href="/admin/study" data-target="study">自习室管理</a>
            <a href="/admin/activity" data-target="activity">活动与报表</a>
            <a href="/admin/audit" data-target="audit">审计日志</a>
        </aside>

        <main class="campus-admin-content">
            <section class="campus-admin-breadcrumb">
                <h1 id="admin-title">统计分析</h1>
                <p id="admin-desc">统一管理商家、菜品、预约和活动数据，确保后台操作与学生端展示保持同步。</p>
                <div id="admin-quick-stats" class="admin-quick-stats"></div>
            </section>

            <section id="panel-overview" class="admin-panel active-panel">
                <div class="campus-admin-panel-grid">
                    <article class="campus-admin-panel wide">
                        <div class="campus-section-head">
                            <h2>近30天用户注册趋势</h2>
                            <button id="refresh-overview" class="campus-light-btn" type="button">刷新概览</button>
                        </div>
                        <div id="overview-register-chart" class="campus-chart-card"></div>
                    </article>
                    <article class="campus-admin-panel">
                        <h2>商家订单占比</h2>
                        <div id="overview-order-chart" class="campus-chart-card"></div>
                    </article>
                    <article class="campus-admin-panel">
                        <h2>自习室时段使用率</h2>
                        <div id="overview-study-chart" class="campus-chart-card"></div>
                    </article>
                    <article class="campus-admin-panel">
                        <h2>活动报名热度</h2>
                        <div id="overview-activity-chart" class="campus-chart-card"></div>
                    </article>
                    <article class="campus-admin-panel wide">
                        <div class="campus-section-head">
                            <h2>Redis / Quartz / ZooKeeper 运行状态</h2>
                            <span class="campus-inline-tip">用于课堂检查缓存、静态化与协调配置能力</span>
                        </div>
                        <div id="overview-system-runtime" class="admin-runtime-grid"></div>
                    </article>
                    <article class="campus-admin-panel wide">
                        <div class="campus-section-head">
                            <h2>月度运营报表预览</h2>
                            <div class="admin-inline-actions">
                                <span class="campus-inline-tip">Excel / PDF 导出内容与这里保持同源</span>
                                <a class="campus-light-btn" href="/api/admin/reports/monthly.xlsx">导出 Excel</a>
                                <button id="export-monthly-pdf" class="campus-primary-btn" type="button">导出 PDF</button>
                            </div>
                        </div>
                        <div class="campus-table-scroll">
                            <table class="campus-table">
                                <thead>
                                <tr><th>商家</th><th>营收</th><th>订单量</th><th>退款率</th></tr>
                                </thead>
                                <tbody id="overview-monthly-report"></tbody>
                            </table>
                        </div>
                        <div id="overview-feedback" class="admin-feedback"></div>
                    </article>
                </div>
            </section>

            <section id="panel-merchant" class="admin-panel" hidden>
                <div class="admin-split">
                    <div class="campus-admin-panel">
                        <div class="campus-section-head merchant-list-head">
                            <h2>商家列表</h2>
                            <div class="admin-inline-actions merchant-toolbar">
                                <input id="merchant-keyword" class="admin-mini-input" type="text" placeholder="搜索商家或食堂">
                                <button id="search-merchants" class="campus-light-btn" type="button">查询</button>
                                <button id="open-merchant-modal" class="campus-primary-btn" type="button">新增商家</button>
                            </div>
                        </div>
                        <div class="campus-table-scroll">
                            <table class="campus-table campus-table--merchant">
                                <thead>
                                <tr><th>ID</th><th>商家名称</th><th>食堂</th><th>状态</th><th>操作</th></tr>
                                </thead>
                                <tbody id="merchant-table-body"></tbody>
                            </table>
                        </div>
                        <div id="merchant-sync-banner" class="campus-info-banner"></div>
                        <div id="merchant-preview-grid" class="admin-preview-grid"></div>
                        <div class="admin-feedback admin-feedback-compact" data-feedback-for="merchant-feedback"></div>
                    </div>
                    <div id="merchant-form-panel" class="campus-admin-panel">
                        <div class="campus-section-head">
                            <h2 id="merchant-form-title">新增商家</h2>
                            <button id="cancel-merchant-edit" class="campus-light-btn" type="button" hidden>取消编辑</button>
                        </div>
                        <div class="admin-form-grid">
                            <label class="admin-field">
                                <span>商家名称</span>
                                <input id="merchant-name" type="text" placeholder="例如：创新食堂能量站">
                            </label>
                            <label class="admin-field">
                                <span>所属食堂</span>
                                <input id="merchant-canteen" type="text" placeholder="例如：第三食堂">
                            </label>
                            <label class="admin-field">
                                <span>联系电话</span>
                                <input id="merchant-phone" type="text" placeholder="例如：021-88880005">
                            </label>
                            <label class="admin-field">
                                <span>Logo 地址</span>
                                <input id="merchant-logo" type="text" value="/static/img/light-food.jpg">
                            </label>
                            <div class="admin-upload-panel admin-field-full">
                                <div class="admin-upload-meta">
                                    <span>商家 Logo 上传</span>
                                    <p>支持从电脑选择图片，上传后会自动回填地址并同步预览。</p>
                                </div>
                                <div class="admin-upload-body">
                                    <img id="merchant-logo-preview" class="admin-upload-preview" src="/static/img/light-food.jpg" alt="商家 Logo 预览">
                                    <div class="admin-upload-actions">
                                        <div class="admin-upload-row">
                                            <input id="merchant-logo-file" type="file" accept="image/*">
                                            <button id="upload-merchant-logo" class="campus-light-btn" type="button">上传 Logo</button>
                                        </div>
                                        <small>支持“本地选图 -> 上传 -> 页面同步显示”的完整图片管理流程。</small>
                                    </div>
                                </div>
                            </div>
                            <label class="admin-field">
                                <span>审核状态</span>
                                <select id="merchant-status">
                                    <option value="PENDING">待审核</option>
                                    <option value="APPROVED">已审核</option>
                                </select>
                            </label>
                            <label class="admin-field">
                                <span>推荐展示</span>
                                <select id="merchant-recommended">
                                    <option value="true">是</option>
                                    <option value="false">否</option>
                                </select>
                            </label>
                        </div>
                        <div class="admin-action-row">
                            <button id="save-merchant" class="campus-primary-btn" type="button">新增商家</button>
                        </div>
                        <div id="merchant-feedback" class="admin-feedback"></div>
                        <div class="admin-note">
                            说明：点击左侧商家表的“通过/待审”可直接切换审核状态，并同步影响学生端可见商家。
                        </div>
                    </div>
                </div>
            </section>

            <section id="panel-dish" class="admin-panel" hidden>
                <div class="campus-admin-panel">
                    <div class="campus-section-head">
                        <h2>菜品与套餐管理</h2>
                        <div class="admin-inline-actions">
                            <select id="dish-merchant-select" class="admin-mini-input"></select>
                            <button id="refresh-dish" class="campus-light-btn" type="button">刷新</button>
                            <button id="open-dish-modal" class="campus-primary-btn" type="button">新增菜品</button>
                            <button id="open-package-modal" class="campus-light-btn" type="button">新增套餐</button>
                        </div>
                    </div>
                    <div class="admin-split admin-dish-workbench">
                        <div class="admin-dish-sidebar">
                            <div class="admin-subtitle">分类列表</div>
                            <ul id="category-list" class="campus-info-list admin-category-list"></ul>
                            <div id="category-form-panel" class="admin-card-block">
                                <h3>新增分类</h3>
                                <label class="admin-field">
                                    <span>分类名称</span>
                                    <input id="category-name" type="text" placeholder="例如：夜宵套餐">
                                </label>
                                <label class="admin-field">
                                    <span>排序</span>
                                    <input id="category-sort" type="number" value="1">
                                </label>
                                <button id="save-category" class="campus-primary-btn" type="button">新增分类</button>
                            </div>
                        </div>
                        <div class="admin-dish-content">
                            <div class="admin-subtitle">菜品列表</div>
                            <div class="admin-inline-actions">
                                <input id="dish-keyword" class="admin-mini-input" type="text" placeholder="搜索菜品名/描述">
                                <select id="dish-category-filter" class="admin-mini-input"></select>
                                <select id="dish-on-sale-filter" class="admin-mini-input">
                                    <option value="">全部状态</option>
                                    <option value="true">仅上架</option>
                                    <option value="false">仅售罄</option>
                                </select>
                                <button id="search-dishes" class="campus-light-btn" type="button">筛选</button>
                                <button id="reset-dishes" class="campus-light-btn" type="button">重置</button>
                            </div>
                            <div id="dish-sync-banner" class="campus-info-banner"></div>
                            <div id="dish-list" class="admin-list-stack admin-dish-list"></div>
                            <div id="dish-form-panel" class="admin-card-block">
                                <div class="campus-section-head">
                                    <h3 id="dish-form-title">新增菜品</h3>
                                    <button id="cancel-dish-edit" class="campus-light-btn" type="button" hidden>取消编辑</button>
                                </div>
                                <div class="admin-form-grid">
                                    <label class="admin-field">
                                        <span>菜品名称</span>
                                        <input id="dish-name" type="text" placeholder="例如：香煎鸡排饭">
                                    </label>
                                    <label class="admin-field">
                                        <span>所属分类</span>
                                        <select id="dish-category"></select>
                                    </label>
                                    <label class="admin-field">
                                        <span>价格</span>
                                        <input id="dish-price" type="number" step="0.01" value="18.00">
                                    </label>
                                    <label class="admin-field">
                                        <span>热量</span>
                                        <input id="dish-calories" type="number" value="420">
                                    </label>
                                    <label class="admin-field">
                                        <span>图片预设</span>
                                        <select id="dish-image-preset">
                                            <option value="/static/img/dishes/chicken-breast-bowl.jpg">鸡胸能量餐</option>
                                            <option value="/static/img/dishes/beef-rice-bowl.jpg">黑椒牛肉盖饭</option>
                                            <option value="/static/img/dishes/avocado-chicken-salad.jpg">牛油果鸡肉沙拉</option>
                                            <option value="/static/img/dishes/tuna-quinoa-salad.jpg">金枪鱼藜麦沙拉</option>
                                            <option value="/static/img/dishes/salmon-bowl.jpg">三文鱼能量碗</option>
                                            <option value="/static/img/dishes/beef-brisket-noodles.jpg">番茄牛腩面</option>
                                            <option value="/static/img/dishes/stir-fried-beef.jpg">小炒黄牛肉</option>
                                            <option value="/static/img/dishes/orange-juice.jpg">鲜榨橙汁</option>
                                            <option value="/static/img/dishes/cappuccino.jpg">轻甜卡布奇诺</option>
                                            <option value="/static/img/dishes/egg-sandwich.jpg">全麦鸡蛋三明治</option>
                                        </select>
                                    </label>
                                    <label class="admin-field">
                                        <span>图片地址</span>
                                        <input id="dish-image" type="text" value="/static/img/dishes/chicken-breast-bowl.jpg" placeholder="可上传本地图片或使用预设地址">
                                    </label>
                                    <label class="admin-field admin-field-full">
                                        <span>菜品简介</span>
                                        <input id="dish-description" type="text" placeholder="请输入菜品描述">
                                    </label>
                                    <div class="admin-upload-panel admin-field-full">
                                        <div class="admin-upload-meta">
                                            <span>菜品图片上传</span>
                                            <p>支持本地选图，上传后会自动写入图片地址，并在下方菜品卡片中直接显示。</p>
                                        </div>
                                        <div class="admin-upload-body">
                                            <img id="dish-image-preview" class="admin-upload-preview" src="/static/img/dishes/chicken-breast-bowl.jpg" alt="菜品图片预览">
                                            <div class="admin-upload-actions">
                                                <input id="dish-image-file" type="file" accept="image/*">
                                                <button id="upload-dish-image" class="campus-light-btn" type="button">上传菜品图</button>
                                                <small>预设图片和本地上传都可用，便于统一图片资源管理。</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="admin-inline-actions">
                                    <label class="admin-checkbox"><input id="dish-onsale" type="checkbox" checked> 立即上架</label>
                                    <button id="save-dish" class="campus-primary-btn" type="button">新增菜品</button>
                                </div>
                                <div class="admin-feedback" data-feedback-for="dish-feedback"></div>
                            </div>
                        </div>
                    </div>
                    <div id="package-form-panel" class="admin-card-block">
                        <div class="campus-section-head">
                            <h3 id="package-form-title">套餐管理</h3>
                            <button id="cancel-package-edit" class="campus-light-btn" type="button" hidden>取消编辑</button>
                            <button id="refresh-package" class="campus-light-btn" type="button">刷新套餐</button>
                        </div>
                        <div id="package-sync-banner" class="campus-info-banner"></div>
                        <div id="package-list" class="admin-list-stack"></div>
                        <div id="package-preview-grid" class="admin-preview-grid"></div>
                        <div class="admin-form-grid">
                            <label class="admin-field">
                                <span>套餐名称</span>
                                <input id="package-name" type="text" placeholder="例如：轻食双拼套餐">
                            </label>
                            <label class="admin-field">
                                <span>主题</span>
                                <input id="package-theme" type="text" placeholder="例如：轻负担晚餐">
                            </label>
                            <label class="admin-field">
                                <span>价格</span>
                                <input id="package-price" type="number" step="0.01" value="25.00">
                            </label>
                            <label class="admin-field">
                                <span>状态</span>
                                <select id="package-status">
                                    <option value="ONLINE">上线</option>
                                    <option value="OFFLINE">下线</option>
                                </select>
                            </label>
                            <label class="admin-field admin-field-full">
                                <span>套餐说明</span>
                                <input id="package-description" type="text" placeholder="请输入套餐简介">
                            </label>
                        </div>
                        <div class="admin-checkbox-list" id="package-dish-selector"></div>
                        <button id="save-package" class="campus-primary-btn" type="button">创建套餐</button>
                        <div class="admin-feedback" data-feedback-for="dish-feedback"></div>
                    </div>
                    <div id="dish-feedback" class="admin-feedback"></div>
                </div>
            </section>

            <section id="panel-study" class="admin-panel" hidden>
                <div class="admin-split">
                    <div class="campus-admin-panel">
                        <div class="campus-section-head">
                            <h2>自习室规则总览</h2>
                            <div class="admin-inline-actions">
                                <button id="refresh-study" class="campus-light-btn" type="button">刷新自习室</button>
                                <button id="open-study-room-modal" class="campus-primary-btn" type="button">新增自习室</button>
                            </div>
                        </div>
                        <div id="study-room-grid" class="admin-room-grid"></div>
                        <div id="study-room-form-panel" class="admin-card-block admin-top-gap">
                            <div class="campus-section-head">
                                <h3 id="study-room-form-title">新增自习室</h3>
                                <button id="cancel-study-room-edit" class="campus-light-btn" type="button" hidden>取消编辑</button>
                            </div>
                            <div class="admin-form-grid">
                                <label class="admin-field">
                                    <span>名称</span>
                                    <input id="study-room-name" type="text" placeholder="例如：图书馆五层研修区">
                                </label>
                                <label class="admin-field">
                                    <span>位置</span>
                                    <input id="study-room-location" type="text" placeholder="例如：图书馆5F东侧">
                                </label>
                                <label class="admin-field">
                                    <span>开放时间</span>
                                    <input id="study-room-open" type="time" value="08:00">
                                </label>
                                <label class="admin-field">
                                    <span>关闭时间</span>
                                    <input id="study-room-close" type="time" value="22:00">
                                </label>
                                <label class="admin-field">
                                    <span>单次上限(小时)</span>
                                    <input id="study-room-max-hours" type="number" value="4">
                                </label>
                                <label class="admin-field">
                                    <span>每日上限(次)</span>
                                    <input id="study-room-daily-limit" type="number" value="2">
                                </label>
                            </div>
                            <div class="admin-action-row">
                                <button id="save-study-room" class="campus-primary-btn" type="button">新增自习室</button>
                            </div>
                            <div class="admin-feedback" data-feedback-for="study-feedback"></div>
                        </div>
                    </div>
                    <div class="campus-admin-panel">
                        <h2>座位导入与模板</h2>
                        <div class="admin-card-block">
                            <div class="campus-section-head">
                                <h3>预约规则编辑</h3>
                            </div>
                            <div class="admin-form-grid">
                                <label class="admin-field">
                                    <span>选择自习室</span>
                                    <select id="study-rule-room"></select>
                                </label>
                                <label class="admin-field">
                                    <span>单次上限(小时)</span>
                                    <input id="study-rule-max-hours" type="number" value="4">
                                </label>
                                <label class="admin-field">
                                    <span>每日上限(次)</span>
                                    <input id="study-rule-daily-limit" type="number" value="2">
                                </label>
                                <label class="admin-field">
                                    <span>可取消提前分钟</span>
                                    <input id="study-rule-cancel-minutes" type="number" value="30">
                                </label>
                                <label class="admin-field">
                                    <span>规则状态</span>
                                    <select id="study-rule-enabled">
                                        <option value="true">启用</option>
                                        <option value="false">停用</option>
                                    </select>
                                </label>
                            </div>
                            <div class="admin-action-row">
                                <button id="save-study-rule" class="campus-primary-btn" type="button">保存预约规则</button>
                            </div>
                        </div>
                        <div class="admin-card-block admin-doc-links">
                            <a class="campus-link-btn" href="/api/admin/study-rooms/template">下载 Excel 模板</a>
                            <a class="campus-light-btn" href="/static/docs/seat-import-guide.html" target="_blank" rel="noopener">查看导入说明</a>
                        </div>
                        <div class="admin-card-block">
                            <div class="campus-section-head">
                                <h3>FullCalendar 预约视图</h3>
                                <span class="campus-inline-tip">按自习室查看未来 30 天的预约占用情况</span>
                            </div>
                            <div id="study-calendar-summary" class="campus-info-banner"></div>
                            <div id="study-calendar" class="campus-calendar-card"></div>
                        </div>
                        <div class="admin-card-block">
                            <label class="admin-field">
                                <span>选择座位模板文件</span>
                                <input id="seat-file" type="file" accept=".xlsx">
                            </label>
                            <button id="import-seat-file" class="campus-primary-btn" type="button">导入座位</button>
                        </div>
                        <div id="study-feedback" class="admin-feedback"></div>
                    </div>
                </div>
            </section>

            <section id="panel-activity" class="admin-panel" hidden>
                <div class="campus-admin-panel">
                    <div class="campus-section-head">
                        <h2>活动管理与报表导出</h2>
                        <div class="admin-inline-actions">
                            <button id="refresh-activities" class="campus-light-btn" type="button">刷新活动</button>
                            <button id="open-activity-modal" class="campus-primary-btn" type="button">新增活动</button>
                        </div>
                    </div>
                    <div id="activity-sync-banner" class="campus-info-banner"></div>
                    <div id="activity-grid" class="admin-activity-grid"></div>
                    <div id="activity-static-panel" class="admin-card-block admin-top-gap">
                        <div class="campus-section-head">
                            <h3>静态化与 Nginx 发布说明</h3>
                            <span class="campus-inline-tip">活动发布、报名变化、截止关闭后会自动刷新静态页</span>
                        </div>
                        <div id="activity-static-summary" class="campus-info-banner"></div>
                        <div class="admin-doc-links">
                            <a class="campus-light-btn" href="/static/docs/nginx-static-deploy-guide.html" target="_blank" rel="noopener">查看 Nginx 部署说明</a>
                        </div>
                    </div>
                    <div id="activity-form-panel" class="admin-card-block admin-top-gap">
                        <div class="campus-section-head">
                            <h3 id="activity-form-title">新增活动</h3>
                            <button id="cancel-activity-edit" class="campus-light-btn" type="button" hidden>取消编辑</button>
                        </div>
                        <div class="admin-form-grid">
                            <label class="admin-field">
                                <span>活动标题</span>
                                <input id="activity-title-input" type="text" placeholder="例如：校园创客路演日">
                            </label>
                            <label class="admin-field">
                                <span>活动地点</span>
                                <input id="activity-location-input" type="text" placeholder="例如：创新中心报告厅">
                            </label>
                            <label class="admin-field">
                                <span>开始时间</span>
                                <input id="activity-start-input" type="datetime-local">
                            </label>
                            <label class="admin-field">
                                <span>结束时间</span>
                                <input id="activity-end-input" type="datetime-local">
                            </label>
                            <label class="admin-field">
                                <span>最大人数</span>
                                <input id="activity-max-input" type="number" value="120">
                            </label>
                            <label class="admin-field">
                                <span>状态</span>
                                <select id="activity-status-input">
                                    <option value="OPEN">开放报名</option>
                                    <option value="CLOSED">停止报名</option>
                                </select>
                            </label>
                            <label class="admin-field admin-field-full">
                                <span>活动简介</span>
                                <input id="activity-summary-input" type="text" placeholder="请输入活动亮点或说明">
                            </label>
                            <label class="admin-field admin-field-full">
                                <span>活动海报地址</span>
                                <input id="activity-poster-input" type="text" value="/static/img/activity-1.svg" placeholder="可上传本地图片或填写URL">
                            </label>
                            <div class="admin-upload-panel admin-field-full">
                                <div class="admin-upload-meta">
                                    <span>活动海报上传</span>
                                    <p>支持本地上传，上传后自动回填海报地址，编辑活动时可直接替换。</p>
                                </div>
                                <div class="admin-upload-body">
                                    <img id="activity-poster-preview" class="admin-upload-preview" src="/static/img/activity-1.svg" alt="活动海报预览">
                                    <div class="admin-upload-actions">
                                        <input id="activity-poster-file" type="file" accept="image/*">
                                        <button id="upload-activity-poster" class="campus-light-btn" type="button">上传海报</button>
                                        <small>建议比例 16:9，避免活动卡片显示被裁剪。</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="admin-action-row">
                            <button id="save-activity" class="campus-primary-btn" type="button">新增活动</button>
                        </div>
                        <div class="admin-feedback" data-feedback-for="activity-feedback"></div>
                    </div>
                    <div id="activity-feedback" class="admin-feedback"></div>
                </div>
            </section>

            <section id="panel-audit" class="admin-panel" hidden>
                <div class="campus-admin-panel">
                    <div class="campus-section-head admin-audit-head">
                        <h2>后台操作审计日志</h2>
                        <div class="admin-inline-actions admin-audit-actions">
                            <input id="admin-audit-operator" class="admin-mini-input" type="text" placeholder="操作人">
                            <select id="admin-audit-module" class="admin-mini-input">
                                <option value="">全部模块</option>
                                <option value="MERCHANT">商家</option>
                                <option value="DISH">菜品</option>
                                <option value="PACKAGE">套餐</option>
                                <option value="STUDY_ROOM">自习室</option>
                                <option value="ACTIVITY">活动</option>
                            </select>
                            <select id="admin-audit-result" class="admin-mini-input">
                                <option value="">全部结果</option>
                                <option value="SUCCESS">成功</option>
                            </select>
                            <input id="admin-audit-start" class="admin-mini-input" type="datetime-local">
                            <input id="admin-audit-end" class="admin-mini-input" type="datetime-local">
                            <button id="search-admin-audit" class="campus-light-btn" type="button">筛选</button>
                            <button id="reset-admin-audit" class="campus-light-btn" type="button">重置</button>
                        </div>
                    </div>
                    <div class="campus-table-scroll">
                        <table class="campus-table campus-table--audit">
                            <thead>
                            <tr><th>时间</th><th>模块</th><th>动作</th><th>对象</th><th>结果</th><th>操作人</th><th>说明</th></tr>
                            </thead>
                            <tbody id="admin-audit-table"></tbody>
                        </table>
                    </div>
                    <div class="admin-inline-actions admin-pagination">
                        <button id="admin-audit-prev" class="campus-light-btn" type="button">上一页</button>
                        <span id="admin-audit-page" class="campus-inline-tip">第 1 页</span>
                        <button id="admin-audit-next" class="campus-light-btn" type="button">下一页</button>
                    </div>
                </div>
            </section>
        </main>
    </div>
</div>

<script src="/static/vendor/axios/axios.min.js"></script>
<script src="/static/vendor/fullcalendar/index.global.min.js"></script>
<script src="/static/vendor/echarts/echarts.min.js"></script>
<script>
    (function () {
        const sectionMeta = {
            overview: {
                title: "统计分析",
                desc: "展示注册趋势、订单占比、自习室使用率和活动热度排行。"
            },
            merchant: {
                title: "商家管理",
                desc: "集中维护商家资料、审核状态和展示信息，并实时同步到学生端。"
            },
            dish: {
                title: "菜品与套餐",
                desc: "按商家统一维护分类、菜品和套餐，支持图片上传、筛选与即时刷新。"
            },
            study: {
                title: "自习室管理",
                desc: "配置预约规则、下载模板并批量导入座位数据。"
            },
            activity: {
                title: "活动与报表",
                desc: "维护活动内容、海报信息与报名报表，并支持静态页生成。"
            },
            audit: {
                title: "审计日志",
                desc: "记录后台关键操作，支持按模块、操作人和时间筛选。"
            }
        };

        const state = {
            adminContext: null,
            currentMerchantId: 1,
            editingMerchantId: null,
            editingDishId: null,
            editingPackageId: null,
            editingActivityId: null,
            editingStudyRoomId: null,
            currentStudyRuleRoomId: null,
            merchants: [],
            categories: [],
            dishes: [],
            packages: [],
            studyRooms: [],
            activities: [],
            dashboard: null,
            overviewCharts: {},
            studyCalendar: null,
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

        function createModalShell(modalId, panel, wide) {
            const shell = document.createElement("div");
            shell.id = modalId;
            shell.className = "campus-modal-shell";
            shell.hidden = true;

            const backdrop = document.createElement("div");
            backdrop.className = "campus-modal-backdrop";
            backdrop.dataset.modalClose = modalId;

            const dialog = document.createElement("div");
            dialog.className = "campus-modal-dialog" + (wide ? " campus-modal-dialog-wide" : "");

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
            const shell = createModalShell(config.modalId, panel, config.wide);
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

        function assertInput(value, message) {
            if (!String(value == null ? "" : value).trim()) {
                throw new Error(message);
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

        function formatDateTime(value) {
            if (!value) {
                return "-";
            }
            if (Array.isArray(value)) {
                const parts = value.slice(0, 5);
                const padded = parts.map((item) => String(item).padStart(2, "0"));
                return padded[0] + "-" + padded[1] + "-" + padded[2] + " " + padded[3] + ":" + padded[4];
            }
            return String(value).replace("T", " ");
        }

        function toDateTimeLocalValue(value) {
            if (!value) {
                return "";
            }
            if (Array.isArray(value)) {
                const parts = value.slice(0, 5).map((item) => String(item).padStart(2, "0"));
                return parts[0] + "-" + parts[1] + "-" + parts[2] + "T" + parts[3] + ":" + parts[4];
            }
            return String(value).slice(0, 16);
        }

        function normalizeDateTimeLocal(value) {
            return value ? value.replace("T", " ") + ":00" : "";
        }

        function setImagePreview(previewId, url, fallback) {
            const element = document.getElementById(previewId);
            const finalUrl = String(url || fallback || "").trim() || fallback;
            element.src = finalUrl;
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

        async function uploadImage(type, fileInputId, valueInputId, previewId, feedbackId) {
            const file = document.getElementById(fileInputId).files[0];
            if (!file) {
                showFeedback(feedbackId, "请先选择一张图片。", false);
                return;
            }
            const formData = new FormData();
            formData.append("file", file);
            formData.append("type", type);
            try {
                const response = await axios.post("/api/admin/uploads/images", formData, {
                    withCredentials: true,
                    headers: {
                        "X-Requested-With": "XMLHttpRequest"
                    }
                });
                const data = response.data;
                if (!data || data.success === false) {
                    throw new Error(normalizeApiErrorMessage(data && data.message, response.status));
                }
                document.getElementById(valueInputId).value = data.data.url;
                setImagePreview(previewId, data.data.url, data.data.url);
                showFeedback(feedbackId, "图片上传成功，地址已自动回填。", true);
            } catch (error) {
                showFeedback(feedbackId, resolveAxiosError(error), false);
            }
        }

        function renderQuickStats() {
            const host = document.getElementById("admin-quick-stats");
            const summary = state.dashboard && state.dashboard.summary ? state.dashboard.summary : {};
            const merchantCount = summary.merchantCount != null ? summary.merchantCount : state.merchants.length;
            const activityCount = summary.activityCount != null ? summary.activityCount : state.activities.length;
            const dishCount = summary.dishCount != null ? summary.dishCount : state.dishes.length;
            const packageCount = summary.packageCount != null ? summary.packageCount : state.packages.length;
            const activeRooms = summary.studyRoomCount != null ? summary.studyRoomCount : state.studyRooms.length;
            host.innerHTML = [
                { label: "商家总数", value: merchantCount },
                { label: "全站菜品", value: dishCount },
                { label: "全站套餐", value: packageCount },
                { label: "自习室", value: activeRooms },
                { label: "活动场次", value: activityCount }
            ].map((item) => {
                return "<div class='admin-stat-card'><span>" + escapeHtml(item.label) + "</span><strong>" + escapeHtml(item.value) + "</strong></div>";
            }).join("");
        }

        function normalizeApiErrorMessage(message, statusCode) {
            const raw = String(message || "");
            if (statusCode === 401) {
                return "登录状态已失效，请重新登录后再试。";
            }
            if (statusCode === 403) {
                return "你没有当前操作权限，请联系超级管理员。";
            }
            if (raw.indexOf("Request method") >= 0 && raw.indexOf("not supported") >= 0) {
                return "请求方式不匹配，请刷新页面后重试当前操作。";
            }
            if (statusCode >= 500 || raw.indexOf("系统异常") >= 0) {
                return "服务暂时不可用，请稍后重试。";
            }
            return raw || ("请求失败（HTTP " + statusCode + "）");
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

        function isMerchantScopedAdmin() {
            return false;
        }

        async function loadAdminContext() {
            const result = await requestJson("/api/admin/context");
            state.adminContext = result.data || {};
            applyAdminContext();
        }

        function applyAdminContext() {
            document.querySelectorAll(".campus-admin-sidebar [data-target='study'], .campus-admin-sidebar [data-target='activity'], .campus-admin-sidebar [data-target='audit']").forEach((item) => {
                item.style.display = "";
            });
            const merchantStatusField = document.getElementById("merchant-status").closest(".admin-field");
            const merchantRecommendedField = document.getElementById("merchant-recommended").closest(".admin-field");
            merchantStatusField.hidden = false;
            merchantRecommendedField.hidden = false;
            document.getElementById("merchant-status").disabled = false;
            document.getElementById("merchant-recommended").disabled = false;
            document.querySelector(".admin-note").textContent = "说明：点击左侧商家表的“通过/待审”可直接切换审核状态，并同步影响学生端可见商家。";
        }

        function switchPanel(target) {
            document.querySelectorAll(".campus-admin-sidebar [data-target]").forEach((item) => {
                item.classList.toggle("active", item.dataset.target === target);
            });
            document.querySelectorAll(".admin-panel").forEach((panel) => {
                panel.hidden = panel.id !== "panel-" + target;
            });
            document.getElementById("admin-title").textContent = sectionMeta[target].title;
            document.getElementById("admin-desc").textContent = sectionMeta[target].desc;
            if (target === "overview") {
                window.setTimeout(resizeOverviewCharts, 80);
            }
            if (target === "study") {
                window.setTimeout(function () {
                    if (state.studyCalendar) {
                        state.studyCalendar.render();
                    }
                }, 80);
            }
        }

        function getOverviewChart(id) {
            const el = document.getElementById(id);
            if (!el || typeof echarts === "undefined") {
                return null;
            }
            if (!state.overviewCharts[id]) {
                state.overviewCharts[id] = echarts.init(el);
            }
            return state.overviewCharts[id];
        }

        function resizeOverviewCharts() {
            Object.keys(state.overviewCharts || {}).forEach((key) => {
                if (state.overviewCharts[key]) {
                    state.overviewCharts[key].resize();
                }
            });
        }

        function renderOverviewCharts(data) {
            const registerRows = (data && data.registerTrend) || [];
            const orderRows = (data && data.orderRatio) || [];
            const studyRows = (data && data.studyRoomUsage) || [];
            const activityRows = (data && data.activityHotRank) || [];

            const registerChart = getOverviewChart("overview-register-chart");
            if (registerChart) {
                registerChart.setOption({
                    tooltip: { trigger: "axis" },
                    grid: { left: 36, right: 20, top: 28, bottom: 26 },
                    xAxis: { type: "category", data: registerRows.map((item) => item.statDate), axisLabel: { color: "#66788a" } },
                    yAxis: { type: "value", axisLabel: { color: "#66788a" } },
                    series: [{
                        type: "line",
                        smooth: true,
                        data: registerRows.map((item) => Number(item.statValue || 0)),
                        lineStyle: { color: "#4e8df7", width: 3 },
                        areaStyle: { color: "rgba(78,141,247,0.15)" },
                        itemStyle: { color: "#4e8df7" }
                    }]
                });
            }

            const orderChart = getOverviewChart("overview-order-chart");
            if (orderChart) {
                orderChart.setOption({
                    tooltip: { trigger: "item" },
                    series: [{
                        type: "pie",
                        radius: ["42%", "72%"],
                        center: ["50%", "54%"],
                        label: { color: "#526273" },
                        data: orderRows.map((item) => ({ name: item.statName, value: Number(item.statValue || 0) }))
                    }]
                });
            }

            const studyChart = getOverviewChart("overview-study-chart");
            if (studyChart) {
                studyChart.setOption({
                    tooltip: { trigger: "axis" },
                    grid: { left: 36, right: 16, top: 24, bottom: 30 },
                    xAxis: { type: "category", data: studyRows.map((item) => item.statName), axisLabel: { color: "#66788a", interval: 0, rotate: 18 } },
                    yAxis: { type: "value", axisLabel: { color: "#66788a" } },
                    series: [{
                        type: "bar",
                        barWidth: 24,
                        itemStyle: { color: "#68b984", borderRadius: [8, 8, 0, 0] },
                        data: studyRows.map((item) => Number(item.statValue || 0))
                    }]
                });
            }

            const activityChart = getOverviewChart("overview-activity-chart");
            if (activityChart) {
                const activityNames = activityRows.map((item) => item.statName).reverse();
                const activityValues = activityRows.map((item) => Number(item.statValue || 0)).reverse();
                activityChart.setOption({
                    tooltip: { trigger: "axis" },
                    grid: { left: 90, right: 20, top: 24, bottom: 18 },
                    xAxis: { type: "value", axisLabel: { color: "#66788a" } },
                    yAxis: { type: "category", data: activityNames, axisLabel: { color: "#66788a" } },
                    series: [{
                        type: "bar",
                        barWidth: 18,
                        itemStyle: { color: "#9b7bff", borderRadius: [0, 8, 8, 0] },
                        data: activityValues
                    }]
                });
            }
        }

        function renderRuntimeCards(system) {
            const host = document.getElementById("overview-system-runtime");
            const cache = system && system.cache ? system.cache : {};
            const staticPage = system && system.staticPage ? system.staticPage : {};
            const zookeeper = system ? system.zookeeper : "未读取";
            const hotMerchants = (cache.sampleHotMerchants || []).join("、") || "暂无";
            const hotPackages = (cache.sampleHotPackages || []).join("、") || "暂无";
            const sampleFiles = (staticPage.sampleFiles || []).join("、") || "暂无";
            host.innerHTML = ""
                + "<article class='admin-runtime-card'><strong>Redis 图片缓存</strong><p>图片缓存键 " + escapeHtml(cache.imageCacheCount || 0) + " 个，孤儿图片待清理 " + escapeHtml(cache.unusedImageCount || 0) + " 个。</p><span>热门商家缓存：" + escapeHtml(cache.hotMerchantCount || 0) + " 项</span></article>"
                + "<article class='admin-runtime-card'><strong>首页热点缓存</strong><p>热门商家：" + escapeHtml(hotMerchants) + "</p><span>热门套餐：" + escapeHtml(hotPackages) + "</span></article>"
                + "<article class='admin-runtime-card'><strong>FreeMarker 静态页</strong><p>静态页目录：" + escapeHtml(staticPage.outputDir || "-") + "</p><span>样例文件：" + escapeHtml(sampleFiles) + "</span></article>"
                + "<article class='admin-runtime-card'><strong>ZooKeeper 配置中心</strong><p>" + escapeHtml(zookeeper || "未读取配置") + "</p><span>当前用于演示平台协调配置读取能力</span></article>";
        }

        function renderMonthlyPreview(rows) {
            const tbody = document.getElementById("overview-monthly-report");
            tbody.innerHTML = rows && rows.length
                ? rows.map((item) => "<tr><td>" + escapeHtml(item.merchantName) + "</td><td>￥" + escapeHtml(item.revenue) + "</td><td>" + escapeHtml(item.orderCount) + "</td><td>" + escapeHtml(item.refundRate) + "</td></tr>").join("")
                : "<tr><td colspan='4' class='admin-empty'>暂无月报数据</td></tr>";
        }

        async function loadOverview() {
            const result = await requestJson("/api/admin/dashboard");
            state.dashboard = result.data;
            renderOverviewCharts(result.data);
            renderRuntimeCards(result.data.system || {});
            renderMonthlyPreview(result.data.monthlyReportPreview || []);
            renderQuickStats();
        }

        async function refreshOverviewQuietly(feedbackId) {
            try {
                await loadOverview();
            } catch (error) {
                if (feedbackId) {
                    showFeedback(feedbackId, "操作已成功，但概览刷新失败：" + error.message, false);
                }
            }
        }

        async function loadMerchants(keyword) {
            const result = await requestJson("/api/admin/merchants/page", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest"
                },
                body: JSON.stringify({ pageNum: 1, pageSize: 30, keyword: keyword || "" })
            });
            state.merchants = result.data.records || [];
            if (!state.merchants.some((item) => item.id === state.currentMerchantId) && state.merchants.length > 0) {
                state.currentMerchantId = state.merchants[0].id;
            }
            renderMerchantTable();
            renderMerchantSelect();
        }

        function renderMerchantTable() {
            const tbody = document.getElementById("merchant-table-body");
            if (!state.merchants.length) {
                tbody.innerHTML = "<tr><td colspan='5' class='admin-empty'>没有找到匹配商家，请尝试新增一个商家用于演示。</td></tr>";
                document.getElementById("merchant-sync-banner").innerHTML = "当前没有商家数据。";
                document.getElementById("merchant-preview-grid").innerHTML = "";
                return;
            }
            tbody.innerHTML = state.merchants.map((merchant) => {
                return "<tr>"
                    + "<td>" + escapeHtml(merchant.id) + "</td>"
                    + "<td>" + escapeHtml(merchant.name) + "</td>"
                    + "<td>" + escapeHtml(merchant.canteenName) + "</td>"
                    + "<td><span class='campus-status'>" + escapeHtml(merchant.auditStatus) + "</span></td>"
                    + "<td class='admin-table-actions'>"
                    + "<button class='campus-light-btn' type='button' data-edit-merchant='" + merchant.id + "'>编辑</button>"
                    + "<button class='campus-light-btn' type='button' data-manage='" + merchant.id + "'>管理菜品</button>"
                    + ("<button class='campus-light-btn' type='button' data-audit='" + merchant.id + ":APPROVED'>通过</button>"
                    + "<button class='campus-light-btn' type='button' data-audit='" + merchant.id + ":PENDING'>待审</button>")
                    + "</td>"
                    + "</tr>";
            }).join("");
            tbody.querySelectorAll("[data-edit-merchant]").forEach((button) => {
                button.addEventListener("click", async function () {
                    try {
                        const result = await requestJson("/api/admin/merchants/" + button.dataset.editMerchant);
                        fillMerchantForm(result.data);
                        showFeedback("merchant-feedback", "商家信息已回显，可直接修改后保存。", true);
                    } catch (error) {
                        showFeedback("merchant-feedback", error.message, false);
                    }
                });
            });
            tbody.querySelectorAll("[data-manage]").forEach((button) => {
                button.addEventListener("click", async function () {
                    state.currentMerchantId = Number(button.dataset.manage);
                    renderMerchantSelect();
                    switchPanel("dish");
                    await loadDishData();
                    showFeedback("dish-feedback", "已切换到对应商家的菜品与套餐管理。", true);
                });
            });
            tbody.querySelectorAll("[data-audit]").forEach((button) => {
                button.addEventListener("click", async function () {
                    const parts = button.dataset.audit.split(":");
                    try {
                        await requestJson("/api/admin/merchants/" + parts[0] + "/audit?status=" + parts[1], { method: "POST" });
                        showFeedback("merchant-feedback", "商家审核状态已更新。", true);
                        await loadMerchants(document.getElementById("merchant-keyword").value.trim());
                        await refreshOverviewQuietly("merchant-feedback");
                    } catch (error) {
                        showFeedback("merchant-feedback", error.message, false);
                    }
                });
            });
            renderMerchantPreview();
        }

        function renderMerchantPreview() {
            const approvedCount = state.merchants.filter((item) => item.auditStatus === "APPROVED").length;
            const recommendedCount = state.merchants.filter((item) => item.recommended).length;
            document.getElementById("merchant-sync-banner").innerHTML =
                "<strong>商家同步预览</strong><span>当前后台共管理 " + escapeHtml(state.merchants.length) + " 个商家，其中已审核 " + escapeHtml(approvedCount) + " 个、推荐展示 " + escapeHtml(recommendedCount) + " 个。用户端首页和餐饮页会优先展示这些已审核商家。</span>";
            document.getElementById("merchant-preview-grid").innerHTML = state.merchants.slice(0, 6).map((merchant) => {
                return "<article class='campus-merchant-preview-card admin-merchant-card'>"
                    + "<img src='" + escapeHtml(resolveMerchantLogoUrl(merchant)) + "' alt='" + escapeHtml(merchant.name) + "'>"
                    + "<div><strong>" + escapeHtml(merchant.name) + "</strong>"
                    + "<p>" + escapeHtml(merchant.canteenName) + "</p>"
                    + "<span>" + escapeHtml(merchant.auditStatus) + (merchant.recommended ? " / 推荐" : "") + "</span></div>"
                    + "</article>";
            }).join("");
        }

        function renderMerchantSelect() {
            const select = document.getElementById("dish-merchant-select");
            select.innerHTML = state.merchants.map((merchant) => {
                const selected = merchant.id === state.currentMerchantId ? " selected" : "";
                return "<option value='" + escapeHtml(merchant.id) + "'" + selected + ">" + escapeHtml(merchant.name) + "</option>";
            }).join("");
            renderQuickStats();
        }

        function resetMerchantForm() {
            state.editingMerchantId = null;
            document.getElementById("merchant-form-title").textContent = "新增商家";
            document.getElementById("save-merchant").textContent = "新增商家";
            document.getElementById("cancel-merchant-edit").hidden = true;
            document.getElementById("merchant-name").value = "";
            document.getElementById("merchant-canteen").value = "";
            document.getElementById("merchant-phone").value = "";
            document.getElementById("merchant-logo").value = "/static/img/light-food.jpg";
            document.getElementById("merchant-status").value = "PENDING";
            document.getElementById("merchant-recommended").value = "true";
            document.getElementById("merchant-logo-file").value = "";
            setImagePreview("merchant-logo-preview", "/static/img/light-food.jpg", "/static/img/light-food.jpg");
        }

        function fillMerchantForm(merchant) {
            state.editingMerchantId = merchant.id;
            document.getElementById("merchant-form-title").textContent = "编辑商家";
            document.getElementById("save-merchant").textContent = "更新商家";
            document.getElementById("cancel-merchant-edit").hidden = false;
            document.getElementById("merchant-name").value = merchant.name || "";
            document.getElementById("merchant-canteen").value = merchant.canteenName || "";
            document.getElementById("merchant-phone").value = merchant.contactPhone || "";
            document.getElementById("merchant-logo").value = resolveMerchantLogoUrl(merchant);
            document.getElementById("merchant-status").value = merchant.auditStatus || "PENDING";
            document.getElementById("merchant-recommended").value = merchant.recommended ? "true" : "false";
            setImagePreview("merchant-logo-preview", resolveMerchantLogoUrl(merchant), "/static/img/light-food.jpg");
            openModal("merchant-form-modal");
        }

        function resetDishForm() {
            state.editingDishId = null;
            document.getElementById("dish-form-title").textContent = "新增菜品";
            document.getElementById("save-dish").textContent = "新增菜品";
            document.getElementById("cancel-dish-edit").hidden = true;
            document.getElementById("dish-name").value = "";
            document.getElementById("dish-price").value = "18.00";
            document.getElementById("dish-calories").value = "420";
            document.getElementById("dish-image-preset").value = "/static/img/dishes/chicken-breast-bowl.jpg";
            document.getElementById("dish-image").value = "/static/img/dishes/chicken-breast-bowl.jpg";
            document.getElementById("dish-description").value = "";
            document.getElementById("dish-onsale").checked = true;
            document.getElementById("dish-image-file").value = "";
            setImagePreview("dish-image-preview", "/static/img/dishes/chicken-breast-bowl.jpg", "/static/img/dishes/chicken-breast-bowl.jpg");
        }

        function fillDishForm(dish) {
            state.editingDishId = dish.id;
            document.getElementById("dish-form-title").textContent = "编辑菜品";
            document.getElementById("save-dish").textContent = "更新菜品";
            document.getElementById("cancel-dish-edit").hidden = false;
            document.getElementById("dish-name").value = dish.name || "";
            document.getElementById("dish-category").value = String(dish.categoryId || "");
            document.getElementById("dish-price").value = dish.price || "18.00";
            document.getElementById("dish-calories").value = dish.calories || 0;
            document.getElementById("dish-image-preset").value = (dish.imageUrl || "").startsWith("/static/img/") ? dish.imageUrl : "/static/img/dishes/chicken-breast-bowl.jpg";
            document.getElementById("dish-image").value = dish.imageUrl || "/static/img/dishes/chicken-breast-bowl.jpg";
            document.getElementById("dish-description").value = dish.description || "";
            document.getElementById("dish-onsale").checked = Boolean(dish.onSale);
            setImagePreview("dish-image-preview", dish.imageUrl || "/static/img/dishes/chicken-breast-bowl.jpg", "/static/img/dishes/chicken-breast-bowl.jpg");
            openModal("dish-form-modal");
        }

        function resetPackageForm() {
            state.editingPackageId = null;
            document.getElementById("package-form-title").textContent = "套餐管理";
            document.getElementById("save-package").textContent = "创建套餐";
            document.getElementById("cancel-package-edit").hidden = true;
            document.getElementById("package-name").value = "";
            document.getElementById("package-theme").value = "";
            document.getElementById("package-price").value = "25.00";
            document.getElementById("package-status").value = "ONLINE";
            document.getElementById("package-description").value = "";
            document.querySelectorAll("#package-dish-selector input").forEach((item) => {
                item.checked = false;
            });
        }

        function fillPackageForm(pkg, relations) {
            state.editingPackageId = pkg.id;
            document.getElementById("package-form-title").textContent = "编辑套餐";
            document.getElementById("save-package").textContent = "更新套餐";
            document.getElementById("cancel-package-edit").hidden = false;
            document.getElementById("package-name").value = pkg.name || "";
            document.getElementById("package-theme").value = pkg.theme || "";
            document.getElementById("package-price").value = pkg.price || "25.00";
            document.getElementById("package-status").value = pkg.status || "ONLINE";
            document.getElementById("package-description").value = pkg.description || "";
            const relationIds = new Set((relations || []).map((item) => Number(item.dishId)));
            document.querySelectorAll("#package-dish-selector input").forEach((item) => {
                item.checked = relationIds.has(Number(item.value));
            });
            openModal("package-form-modal");
        }

        function resetActivityForm() {
            state.editingActivityId = null;
            document.getElementById("activity-form-title").textContent = "新增活动";
            document.getElementById("save-activity").textContent = "新增活动";
            document.getElementById("cancel-activity-edit").hidden = true;
            document.getElementById("activity-title-input").value = "";
            document.getElementById("activity-location-input").value = "";
            document.getElementById("activity-start-input").value = "";
            document.getElementById("activity-end-input").value = "";
            document.getElementById("activity-max-input").value = "120";
            document.getElementById("activity-status-input").value = "OPEN";
            document.getElementById("activity-summary-input").value = "";
            document.getElementById("activity-poster-input").value = "/static/img/activity-1.svg";
            document.getElementById("activity-poster-file").value = "";
            setImagePreview("activity-poster-preview", "/static/img/activity-1.svg", "/static/img/activity-1.svg");
        }

        function resetStudyRoomForm() {
            state.editingStudyRoomId = null;
            document.getElementById("study-room-form-title").textContent = "新增自习室";
            document.getElementById("save-study-room").textContent = "新增自习室";
            document.getElementById("cancel-study-room-edit").hidden = true;
            document.getElementById("study-room-name").value = "";
            document.getElementById("study-room-location").value = "";
            document.getElementById("study-room-open").value = "08:00";
            document.getElementById("study-room-close").value = "22:00";
            document.getElementById("study-room-max-hours").value = "4";
            document.getElementById("study-room-daily-limit").value = "2";
        }

        function fillStudyRoomForm(room) {
            state.editingStudyRoomId = room.id;
            document.getElementById("study-room-form-title").textContent = "编辑自习室";
            document.getElementById("save-study-room").textContent = "更新自习室";
            document.getElementById("cancel-study-room-edit").hidden = false;
            document.getElementById("study-room-name").value = room.name || "";
            document.getElementById("study-room-location").value = room.location || "";
            document.getElementById("study-room-open").value = String(room.openTime || "08:00").slice(0, 5);
            document.getElementById("study-room-close").value = String(room.closeTime || "22:00").slice(0, 5);
            document.getElementById("study-room-max-hours").value = room.maxHours || 4;
            document.getElementById("study-room-daily-limit").value = room.dailyLimit || 2;
            openModal("study-room-form-modal");
        }

        function fillActivityForm(activity) {
            state.editingActivityId = activity.id;
            document.getElementById("activity-form-title").textContent = "编辑活动";
            document.getElementById("save-activity").textContent = "更新活动";
            document.getElementById("cancel-activity-edit").hidden = false;
            document.getElementById("activity-title-input").value = activity.title || "";
            document.getElementById("activity-location-input").value = activity.location || "";
            document.getElementById("activity-start-input").value = toDateTimeLocalValue(activity.startTime);
            document.getElementById("activity-end-input").value = toDateTimeLocalValue(activity.endTime);
            document.getElementById("activity-max-input").value = activity.maxParticipants || 120;
            document.getElementById("activity-status-input").value = activity.status || "OPEN";
            document.getElementById("activity-summary-input").value = activity.summary || "";
            document.getElementById("activity-poster-input").value = activity.posterUrl || "/static/img/activity-1.svg";
            setImagePreview("activity-poster-preview", activity.posterUrl || "/static/img/activity-1.svg", "/static/img/activity-1.svg");
            openModal("activity-form-modal");
        }

        async function createMerchant() {
            const payload = {
                id: state.editingMerchantId,
                name: document.getElementById("merchant-name").value.trim(),
                canteenName: document.getElementById("merchant-canteen").value.trim(),
                contactPhone: document.getElementById("merchant-phone").value.trim(),
                logoUrl: document.getElementById("merchant-logo").value.trim(),
                auditStatus: document.getElementById("merchant-status").value,
                recommended: document.getElementById("merchant-recommended").value === "true"
            };
            try {
                assertInput(payload.name, "请输入商家名称");
                assertInput(payload.canteenName, "请输入所属食堂");
                const result = await requestJson("/api/admin/merchants", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: JSON.stringify(payload)
                });
                state.currentMerchantId = result.data.id;
                showFeedback("merchant-feedback", state.editingMerchantId ? "商家信息已更新。" : "新商家已创建。", true);
                resetMerchantForm();
                closeModal("merchant-form-modal", false);
                await loadMerchants(document.getElementById("merchant-keyword").value.trim());
                await loadDishData();
                renderQuickStats();
                await refreshOverviewQuietly("merchant-feedback");
            } catch (error) {
                showFeedback("merchant-feedback", error.message, false);
            }
        }

        async function loadDishData() {
            const merchantId = Number(document.getElementById("dish-merchant-select").value || state.currentMerchantId || 1);
            state.currentMerchantId = merchantId;
            const keyword = document.getElementById("dish-keyword").value.trim();
            const categoryId = document.getElementById("dish-category-filter").value;
            const onSaleValue = document.getElementById("dish-on-sale-filter").value;
            const categoryResult = await requestJson("/api/admin/merchants/" + merchantId + "/categories");
            const dishResult = await requestJson("/api/admin/merchants/" + merchantId + "/dishes/page", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest"
                },
                body: JSON.stringify({
                    pageNum: 1,
                    pageSize: 60,
                    keyword: keyword,
                    categoryId: categoryId ? Number(categoryId) : null,
                    onSale: onSaleValue === "" ? null : onSaleValue === "true",
                    includeSoldOut: true
                })
            });
            const packageResult = await requestJson("/api/admin/packages?merchantId=" + merchantId);
            state.categories = categoryResult.data || [];
            state.dishes = dishResult.data.records || [];
            state.packages = packageResult.data || [];
            renderCategories();
            renderDishes();
            renderPackages(state.packages);
            renderDishSyncBanner();
            renderQuickStats();
        }

        function renderDishSyncBanner() {
            const current = state.merchants.find((item) => item.id === state.currentMerchantId);
            document.getElementById("dish-sync-banner").innerHTML = current
                ? "<strong>当前同步商家：" + escapeHtml(current.name) + "</strong><span>用户端会同步展示该商家的 " + escapeHtml(state.dishes.length) + " 道菜品和 " + escapeHtml(state.packages.length) + " 个套餐。</span>"
                : "请选择商家。";
            document.getElementById("package-sync-banner").innerHTML = current
                ? "<strong>套餐同步预览</strong><span>下面这组套餐卡片和用户端餐饮页展示内容保持实时同步。</span>"
                : "请选择商家。";
        }

        function renderCategories() {
            document.getElementById("category-list").innerHTML = state.categories.length
                ? state.categories.map((item) => "<li>" + escapeHtml(item.name) + " / 排序 " + escapeHtml(item.sortOrder) + "</li>").join("")
                : "<li>当前商家还没有分类</li>";
            document.getElementById("dish-category").innerHTML = state.categories.map((item) => {
                return "<option value='" + escapeHtml(item.id) + "'>" + escapeHtml(item.name) + "</option>";
            }).join("");
            const filter = document.getElementById("dish-category-filter");
            const currentFilterValue = filter.value || "";
            filter.innerHTML = "<option value=''>全部分类</option>" + state.categories.map((item) => {
                return "<option value='" + escapeHtml(item.id) + "'>" + escapeHtml(item.name) + "</option>";
            }).join("");
            if (currentFilterValue) {
                filter.value = currentFilterValue;
            }
            if (!state.categories.length) {
                document.getElementById("dish-category").innerHTML = "<option value=''>请先新增分类</option>";
            }
        }

        function renderDishes() {
            const categoryMap = new Map(state.categories.map((item) => [Number(item.id), item.name]));
            document.getElementById("dish-list").innerHTML = state.dishes.length
                ? state.dishes.map((item) => {
                    const status = item.onSale ? "上架中" : "已售罄";
                    const statusClass = item.onSale ? "" : " muted";
                    const categoryName = categoryMap.get(Number(item.categoryId)) || "未分类";
                    return "<article class='admin-crud-card admin-dish-crud-card'>"
                        + "<img class='admin-dish-thumb' src='" + escapeHtml(item.imageUrl || "/static/img/dishes/chicken-breast-bowl.jpg") + "' alt='" + escapeHtml(item.name) + "'>"
                        + "<div class='admin-dish-card-main'>"
                        + "<div class='admin-dish-card-head'><strong>" + escapeHtml(item.name) + "</strong><span class='campus-status-tag" + statusClass + "'>" + escapeHtml(status) + "</span></div>"
                        + "<p>" + escapeHtml(item.description || "暂无简介") + "</p>"
                        + "<div class='admin-dish-meta'>"
                        + "<span>分类：" + escapeHtml(categoryName) + "</span>"
                        + "<span>价格：￥" + escapeHtml(item.price) + "</span>"
                        + "<span>热量：" + escapeHtml(item.calories) + " kcal</span>"
                        + "</div></div>"
                        + "<div class='admin-table-actions admin-dish-actions'>"
                        + "<button class='campus-light-btn' type='button' data-edit-dish='" + item.id + "'>编辑</button>"
                        + "<button class='campus-light-btn' type='button' data-toggle-dish-onsale='" + item.id + ":" + (item.onSale ? "false" : "true") + "'>" + (item.onSale ? "设为售罄" : "恢复上架") + "</button>"
                        + "<button class='campus-light-btn danger-lite' type='button' data-delete-dish='" + item.id + "'>删除</button>"
                        + "</div></article>";
                }).join("")
                : "<div class='admin-empty'>当前商家还没有菜品</div>";
            document.getElementById("package-dish-selector").innerHTML = state.dishes.length
                ? state.dishes.map((item) => {
                    return "<label class='admin-checkbox'><input type='checkbox' value='" + escapeHtml(item.id) + "'> " + escapeHtml(item.name) + "</label>";
                }).join("")
                : "<div class='admin-empty'>先创建菜品后才能组合套餐</div>";
            document.querySelectorAll("[data-edit-dish]").forEach((button) => {
                button.addEventListener("click", async function () {
                    try {
                        const result = await requestJson("/api/admin/dishes/" + button.dataset.editDish);
                        fillDishForm(result.data);
                        showFeedback("dish-feedback", "菜品信息已回显，可直接修改后保存。", true);
                    } catch (error) {
                        showFeedback("dish-feedback", error.message, false);
                    }
                });
            });
            document.querySelectorAll("[data-delete-dish]").forEach((button) => {
                button.addEventListener("click", async function () {
                    if (!window.confirm("确认删除这道菜品吗？")) {
                        return;
                    }
                    try {
                        await requestJson("/api/admin/dishes/" + button.dataset.deleteDish + "/delete", { method: "POST" });
                        showFeedback("dish-feedback", "菜品已删除。", true);
                        if (state.editingDishId === Number(button.dataset.deleteDish)) {
                            closeModal("dish-form-modal");
                        }
                        await loadDishData();
                        await refreshOverviewQuietly("dish-feedback");
                    } catch (error) {
                        showFeedback("dish-feedback", error.message, false);
                    }
                });
            });
            document.querySelectorAll("[data-toggle-dish-onsale]").forEach((button) => {
                button.addEventListener("click", async function () {
                    const parts = String(button.dataset.toggleDishOnsale || "").split(":");
                    const dishId = Number(parts[0] || 0);
                    const nextOnSale = parts[1] === "true";
                    try {
                        const detail = await requestJson("/api/admin/dishes/" + dishId);
                        const payload = Object.assign({}, detail.data || {}, { onSale: nextOnSale });
                        await requestJson("/api/admin/dishes", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json",
                                "X-Requested-With": "XMLHttpRequest"
                            },
                            body: JSON.stringify(payload)
                        });
                        showFeedback("dish-feedback", nextOnSale ? "菜品已恢复上架。" : "菜品已设为售罄。", true);
                        await loadDishData();
                    } catch (error) {
                        showFeedback("dish-feedback", error.message, false);
                    }
                });
            });
        }

        function buildAdminAuditQuery() {
            return {
                pageNum: state.auditPageNum,
                pageSize: state.auditPageSize,
                module: document.getElementById("admin-audit-module").value,
                actionResult: document.getElementById("admin-audit-result").value,
                operatorName: document.getElementById("admin-audit-operator").value.trim(),
                startTime: normalizeDateTimeLocal(document.getElementById("admin-audit-start").value),
                endTime: normalizeDateTimeLocal(document.getElementById("admin-audit-end").value)
            };
        }

        function renderAdminAuditRows(rows) {
            const tbody = document.getElementById("admin-audit-table");
            tbody.innerHTML = rows && rows.length
                ? rows.map((item) => {
                    const target = item.targetName || (item.targetId ? ("#" + item.targetId) : "-");
                    return "<tr>"
                        + "<td>" + escapeHtml(formatDateTime(item.createdAt)) + "</td>"
                        + "<td>" + escapeHtml(item.module || "-") + "</td>"
                        + "<td>" + escapeHtml(item.action || "-") + "</td>"
                        + "<td>" + escapeHtml(target) + "</td>"
                        + "<td>" + escapeHtml(item.actionResult || "-") + "</td>"
                        + "<td>" + escapeHtml(item.operatorName || "-") + "</td>"
                        + "<td>" + escapeHtml(item.detail || "-") + "</td>"
                        + "</tr>";
                }).join("")
                : "<tr><td colspan='7' class='admin-empty'>暂无日志</td></tr>";
        }

        async function loadAdminAuditLogs() {
            const result = await requestJson("/api/admin/audit-logs/page", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest"
                },
                body: JSON.stringify(buildAdminAuditQuery())
            });
            const pageData = result.data || {};
            const rows = pageData.records || [];
            renderAdminAuditRows(rows);
            state.auditTotal = Number(pageData.total || 0);
            const totalPage = Math.max(1, Math.ceil(state.auditTotal / state.auditPageSize));
            document.getElementById("admin-audit-page").textContent = "第 " + state.auditPageNum + " / " + totalPage + " 页（共 " + state.auditTotal + " 条）";
            document.getElementById("admin-audit-prev").disabled = state.auditPageNum <= 1;
            document.getElementById("admin-audit-next").disabled = state.auditPageNum >= totalPage;
        }

        function renderPackages(packages) {
            document.getElementById("package-list").innerHTML = packages.length
                ? packages.map((item) => {
                    return "<article class='admin-crud-card'>"
                        + "<div><strong>" + escapeHtml(item.name) + "</strong>"
                        + "<p>" + escapeHtml(item.description || "暂无套餐说明") + "</p>"
                        + "<span>" + escapeHtml(item.theme || "套餐") + " / ￥" + escapeHtml(item.price) + " / " + escapeHtml(item.status) + "</span></div>"
                        + "<div class='admin-table-actions'>"
                        + "<button class='campus-light-btn' type='button' data-edit-package='" + item.id + "'>编辑</button>"
                        + "<button class='campus-light-btn danger-lite' type='button' data-delete-package='" + item.id + "'>删除</button>"
                        + "</div></article>";
                }).join("")
                : "<div class='admin-empty'>当前商家还没有套餐</div>";
            document.getElementById("package-preview-grid").innerHTML = packages.length
                ? packages.map((item) => {
                    return "<article class='campus-package-card'>"
                        + "<span class='campus-status-tag'>" + escapeHtml(item.theme || "套餐") + "</span>"
                        + "<strong>" + escapeHtml(item.name) + "</strong>"
                        + "<p>" + escapeHtml(item.description || "标准化套餐内容说明。") + "</p>"
                        + "<div class='campus-dish-meta'><span>" + escapeHtml(item.status) + "</span><b>￥" + escapeHtml(item.price) + "</b></div>"
                        + "</article>";
                }).join("")
                : "<div class='campus-empty-card'>当前商家还没有套餐预览内容。</div>";
            document.querySelectorAll("[data-edit-package]").forEach((button) => {
                button.addEventListener("click", async function () {
                    try {
                        const result = await requestJson("/api/admin/packages/" + button.dataset.editPackage);
                        fillPackageForm(result.data.mealPackage, result.data.relations);
                        showFeedback("dish-feedback", "套餐信息已回显，可直接修改后保存。", true);
                    } catch (error) {
                        showFeedback("dish-feedback", error.message, false);
                    }
                });
            });
            document.querySelectorAll("[data-delete-package]").forEach((button) => {
                button.addEventListener("click", async function () {
                    if (!window.confirm("确认删除这个套餐吗？")) {
                        return;
                    }
                    try {
                        await requestJson("/api/admin/packages/" + button.dataset.deletePackage + "/delete", { method: "POST" });
                        if (state.editingPackageId === Number(button.dataset.deletePackage)) {
                            closeModal("package-form-modal");
                        }
                        showFeedback("dish-feedback", "套餐已删除。", true);
                        await loadDishData();
                        await refreshOverviewQuietly("dish-feedback");
                    } catch (error) {
                        showFeedback("dish-feedback", error.message, false);
                    }
                });
            });
        }

        async function createCategory() {
            const payload = {
                merchantId: state.currentMerchantId,
                name: document.getElementById("category-name").value.trim(),
                sortOrder: Number(document.getElementById("category-sort").value || 1)
            };
            try {
                assertInput(payload.name, "请输入分类名称");
                const result = await requestJson("/api/admin/categories", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: JSON.stringify(payload)
                });
                showFeedback("dish-feedback", "分类新增成功。", true);
                document.getElementById("category-name").value = "";
                await loadDishData();
                document.getElementById("dish-category").value = String(result.data.id);
                await refreshOverviewQuietly("dish-feedback");
            } catch (error) {
                showFeedback("dish-feedback", error.message, false);
            }
        }

        async function createDish() {
            const payload = {
                id: state.editingDishId,
                merchantId: state.currentMerchantId,
                categoryId: Number(document.getElementById("dish-category").value),
                name: document.getElementById("dish-name").value.trim(),
                description: document.getElementById("dish-description").value.trim(),
                price: Number(document.getElementById("dish-price").value || 0),
                imageUrl: document.getElementById("dish-image").value,
                onSale: document.getElementById("dish-onsale").checked,
                calories: Number(document.getElementById("dish-calories").value || 0)
            };
            try {
                assertInput(payload.name, "请输入菜品名称");
                assertInput(payload.description, "请输入菜品描述");
                if (!payload.categoryId) {
                    throw new Error("请先选择所属分类");
                }
                if (payload.price <= 0) {
                    throw new Error("菜品价格需要大于 0");
                }
                await requestJson("/api/admin/dishes", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: JSON.stringify(payload)
                });
                showFeedback("dish-feedback", state.editingDishId ? "菜品已更新。" : "菜品新增成功。", true);
                resetDishForm();
                closeModal("dish-form-modal", false);
                await loadDishData();
                await refreshOverviewQuietly("dish-feedback");
            } catch (error) {
                showFeedback("dish-feedback", error.message, false);
            }
        }

        async function createPackage() {
            const checkedDishIds = Array.from(document.querySelectorAll("#package-dish-selector input:checked")).map((item) => Number(item.value));
            const payload = {
                mealPackage: {
                    id: state.editingPackageId,
                    merchantId: state.currentMerchantId,
                    name: document.getElementById("package-name").value.trim(),
                    theme: document.getElementById("package-theme").value.trim(),
                    status: document.getElementById("package-status").value,
                    price: Number(document.getElementById("package-price").value || 0),
                    description: document.getElementById("package-description").value.trim()
                },
                relations: checkedDishIds.map((dishId) => ({ dishId: dishId, quantity: 1 }))
            };
            try {
                assertInput(payload.mealPackage.name, "请输入套餐名称");
                if (payload.mealPackage.price <= 0) {
                    throw new Error("套餐价格需要大于 0");
                }
                if (checkedDishIds.length === 0) {
                    throw new Error("请至少勾选一个菜品后再创建套餐");
                }
                const result = await requestJson("/api/admin/packages", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: JSON.stringify(payload)
                });
                showFeedback("dish-feedback", state.editingPackageId ? "套餐信息已更新。" : "套餐创建成功。", true);
                state.editingPackageId = result.data.id;
                resetPackageForm();
                closeModal("package-form-modal", false);
                await loadDishData();
                await refreshOverviewQuietly("dish-feedback");
            } catch (error) {
                showFeedback("dish-feedback", error.message, false);
            }
        }

        async function loadStudyRooms() {
            const result = await requestJson("/api/admin/study-rooms");
            state.studyRooms = result.data || [];
            if (state.currentStudyRuleRoomId == null && state.studyRooms.length) {
                state.currentStudyRuleRoomId = state.studyRooms[0].id;
            }
            if (!state.studyRooms.some((room) => room.id === state.currentStudyRuleRoomId) && state.studyRooms.length) {
                state.currentStudyRuleRoomId = state.studyRooms[0].id;
            }
            const grid = document.getElementById("study-room-grid");
            grid.innerHTML = state.studyRooms.map((room) => {
                return "<article class='admin-room-card'>"
                    + "<strong>" + escapeHtml(room.name) + "</strong>"
                    + "<span>" + escapeHtml(room.location) + "</span>"
                    + "<p>开放时间：" + escapeHtml(room.openTime) + " - " + escapeHtml(room.closeTime) + "</p>"
                    + "<p>单次上限：" + escapeHtml(room.maxHours) + " 小时 / 每日上限：" + escapeHtml(room.dailyLimit) + " 次</p>"
                    + "<div class='admin-table-actions'>"
                    + "<button class='campus-light-btn' type='button' data-edit-study-room='" + room.id + "'>编辑</button>"
                    + "<button class='campus-light-btn danger-lite' type='button' data-delete-study-room='" + room.id + "'>删除</button>"
                    + "</div>"
                    + "</article>";
            }).join("");
            renderStudyRuleRoomSelect();
            await loadCurrentStudyRule();
            await loadStudyCalendar();
            grid.querySelectorAll("[data-edit-study-room]").forEach((button) => {
                button.addEventListener("click", async function () {
                    try {
                        const result = await requestJson("/api/admin/study-rooms/" + button.dataset.editStudyRoom);
                        fillStudyRoomForm(result.data);
                        showFeedback("study-feedback", "自习室信息已回显，可直接修改后保存。", true);
                    } catch (error) {
                        showFeedback("study-feedback", error.message, false);
                    }
                });
            });
            grid.querySelectorAll("[data-delete-study-room]").forEach((button) => {
                button.addEventListener("click", async function () {
                    if (!window.confirm("确认删除该自习室吗？已有预约记录的自习室不可删除。")) {
                        return;
                    }
                    try {
                        await requestJson("/api/admin/study-rooms/" + button.dataset.deleteStudyRoom + "/delete", { method: "POST" });
                        showFeedback("study-feedback", "自习室已删除。", true);
                        if (state.editingStudyRoomId === Number(button.dataset.deleteStudyRoom)) {
                            closeModal("study-room-form-modal");
                        }
                        await loadStudyRooms();
                        await refreshOverviewQuietly("study-feedback");
                    } catch (error) {
                        showFeedback("study-feedback", error.message, false);
                    }
                });
            });
            renderQuickStats();
        }

        function ensureStudyCalendar() {
            const host = document.getElementById("study-calendar");
            if (!host || typeof FullCalendar === "undefined") {
                return null;
            }
            if (!state.studyCalendar) {
                state.studyCalendar = new FullCalendar.Calendar(host, {
                    initialView: "timeGridWeek",
                    locale: "zh-cn",
                    height: 620,
                    allDaySlot: false,
                    slotMinTime: "08:00:00",
                    slotMaxTime: "22:00:00",
                    expandRows: true,
                    headerToolbar: {
                        left: "prev,next today",
                        center: "title",
                        right: "timeGridWeek,timeGridDay,listWeek"
                    },
                    buttonText: {
                        today: "今天",
                        week: "周视图",
                        day: "日视图",
                        list: "列表"
                    },
                    events: []
                });
                state.studyCalendar.render();
            }
            return state.studyCalendar;
        }

        async function loadStudyCalendar() {
            if (!state.currentStudyRuleRoomId) {
                document.getElementById("study-calendar-summary").innerHTML = "请先创建并选择一个自习室。";
                return;
            }
            const calendar = ensureStudyCalendar();
            if (!calendar) {
                return;
            }
            const start = new Date();
            const end = new Date();
            end.setDate(end.getDate() + 30);
            const result = await requestJson("/api/admin/study-rooms/" + state.currentStudyRuleRoomId + "/reservations?startDate="
                + start.toISOString().slice(0, 10) + "&endDate=" + end.toISOString().slice(0, 10));
            const rows = result.data || [];
            const room = state.studyRooms.find((item) => item.id === state.currentStudyRuleRoomId);
            document.getElementById("study-calendar-summary").innerHTML = room
                ? "<strong>" + escapeHtml(room.name) + "</strong><span>未来 30 天共有 " + escapeHtml(rows.length) + " 条预约记录，日历可直接展示时段冲突和预约密度。</span>"
                : "当前未选中自习室。";
            calendar.removeAllEvents();
            rows.forEach((item) => {
                calendar.addEvent({
                    id: String(item.id),
                    title: (item.seatCode || "座位") + " · " + (item.status || "BOOKED"),
                    start: String(item.reservationDate) + "T" + String(item.startTime),
                    end: String(item.reservationDate) + "T" + String(item.endTime),
                    backgroundColor: item.status === "BOOKED" ? "#5a9cff" : "#c7d3e0",
                    borderColor: item.status === "BOOKED" ? "#4a86ea" : "#c7d3e0"
                });
            });
        }

        function renderStudyRuleRoomSelect() {
            const select = document.getElementById("study-rule-room");
            select.innerHTML = state.studyRooms.length
                ? state.studyRooms.map((room) => {
                    const selected = room.id === state.currentStudyRuleRoomId ? " selected" : "";
                    return "<option value='" + escapeHtml(room.id) + "'" + selected + ">" + escapeHtml(room.name) + "</option>";
                }).join("")
                : "<option value=''>暂无自习室</option>";
        }

        async function loadCurrentStudyRule() {
            if (!state.currentStudyRuleRoomId) {
                return;
            }
            const result = await requestJson("/api/admin/study-rooms/" + state.currentStudyRuleRoomId + "/rule");
            const rule = result.data || {};
            document.getElementById("study-rule-max-hours").value = rule.maxHours || 4;
            document.getElementById("study-rule-daily-limit").value = rule.dailyLimit || 2;
            document.getElementById("study-rule-cancel-minutes").value = rule.cancelBeforeMinutes == null ? 30 : rule.cancelBeforeMinutes;
            document.getElementById("study-rule-enabled").value = String(rule.enabled !== false);
        }

        async function saveStudyRoom() {
            const payload = {
                id: state.editingStudyRoomId,
                name: document.getElementById("study-room-name").value.trim(),
                location: document.getElementById("study-room-location").value.trim(),
                openTime: document.getElementById("study-room-open").value,
                closeTime: document.getElementById("study-room-close").value,
                maxHours: Number(document.getElementById("study-room-max-hours").value || 0),
                dailyLimit: Number(document.getElementById("study-room-daily-limit").value || 0)
            };
            try {
                assertInput(payload.name, "请输入自习室名称");
                assertInput(payload.location, "请输入自习室位置");
                assertInput(payload.openTime, "请选择开放时间");
                assertInput(payload.closeTime, "请选择关闭时间");
                if (payload.maxHours <= 0 || payload.dailyLimit <= 0) {
                    throw new Error("单次上限和每日上限必须大于0");
                }
                await requestJson("/api/admin/study-rooms", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: JSON.stringify(payload)
                });
                showFeedback("study-feedback", state.editingStudyRoomId ? "自习室信息已更新。" : "自习室已创建。", true);
                resetStudyRoomForm();
                closeModal("study-room-form-modal", false);
                await loadStudyRooms();
                await refreshOverviewQuietly("study-feedback");
            } catch (error) {
                showFeedback("study-feedback", error.message, false);
            }
        }

        async function saveStudyRule() {
            if (!state.currentStudyRuleRoomId) {
                showFeedback("study-feedback", "请先创建自习室。", false);
                return;
            }
            const payload = {
                studyRoomId: state.currentStudyRuleRoomId,
                maxHours: Number(document.getElementById("study-rule-max-hours").value || 0),
                dailyLimit: Number(document.getElementById("study-rule-daily-limit").value || 0),
                cancelBeforeMinutes: Number(document.getElementById("study-rule-cancel-minutes").value || 0),
                enabled: document.getElementById("study-rule-enabled").value === "true"
            };
            try {
                if (payload.maxHours <= 0 || payload.dailyLimit <= 0) {
                    throw new Error("规则中的时长和次数必须大于0");
                }
                if (payload.cancelBeforeMinutes < 0) {
                    throw new Error("取消时限不能小于0");
                }
                await requestJson("/api/admin/study-rooms/rules", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: JSON.stringify(payload)
                });
                showFeedback("study-feedback", "预约规则已保存。", true);
                await loadStudyRooms();
                await refreshOverviewQuietly("study-feedback");
            } catch (error) {
                showFeedback("study-feedback", error.message, false);
            }
        }

        async function importSeats() {
            const file = document.getElementById("seat-file").files[0];
            if (!file) {
                showFeedback("study-feedback", "请先选择 Excel 文件。", false);
                return;
            }
            const formData = new FormData();
            formData.append("file", file);
            try {
                const response = await axios.post("/api/admin/study-rooms/import", formData, {
                    withCredentials: true,
                    headers: {
                        "X-Requested-With": "XMLHttpRequest"
                    }
                });
                const data = response.data;
                if (!data || data.success === false) {
                    throw new Error(normalizeApiErrorMessage(data && data.message, response.status));
                }
                showFeedback("study-feedback", "导入成功，共写入 " + data.data + " 个座位。", true);
                await loadStudyRooms();
                await refreshOverviewQuietly("study-feedback");
            } catch (error) {
                showFeedback("study-feedback", resolveAxiosError(error), false);
            }
        }

        async function loadActivities() {
            const result = await requestJson("/api/admin/activities");
            state.activities = result.data || [];
            document.getElementById("activity-sync-banner").innerHTML = state.activities.length
                ? "<strong>活动同步预览</strong><span>用户端首页活动预告和活动报名页会读取这批活动。当前共有 " + escapeHtml(state.activities.length) + " 场活动。</span>"
                : "当前还没有活动。";
            const staticSummary = state.dashboard && state.dashboard.system && state.dashboard.system.staticPage
                ? state.dashboard.system.staticPage
                : {};
            document.getElementById("activity-static-summary").innerHTML =
                "<strong>自动静态化已启用</strong><span>活动发布、报名变化、截止关闭后会自动生成或刷新静态 HTML。当前静态目录：" + escapeHtml(staticSummary.outputDir || "-")
                + "；样例文件：" + escapeHtml((staticSummary.sampleFiles || []).join("、") || "暂无") + "。</span>";
            document.getElementById("activity-grid").innerHTML = state.activities.map((activity) => {
                return "<article class='admin-activity-card'>"
                    + "<div class='admin-activity-poster-wrap'><img class='admin-activity-poster' src='" + escapeHtml(activity.posterUrl || "/static/img/activity-1.svg") + "' alt='" + escapeHtml(activity.title) + "'></div>"
                    + "<div class='admin-activity-main'><strong>" + escapeHtml(activity.title) + "</strong>"
                    + "<p>" + escapeHtml(activity.summary) + "</p>"
                    + "<span>" + escapeHtml(activity.location) + " / 名额 " + escapeHtml(activity.maxParticipants) + " / " + escapeHtml(activity.status) + "</span>"
                    + "<p class='admin-muted'>时间：" + escapeHtml(formatDateTime(activity.startTime)) + " - " + escapeHtml(formatDateTime(activity.endTime)) + "</p></div>"
                    + "<div class='admin-inline-actions admin-activity-actions'>"
                    + "<button class='campus-light-btn' type='button' data-edit-activity='" + activity.id + "'>编辑</button>"
                    + "<button class='campus-light-btn' type='button' data-staticize-activity='" + activity.id + "'>生成静态页</button>"
                    + "<button class='campus-link-btn inline' type='button' data-export-activity-pdf='" + activity.id + "'>导出 PDF</button>"
                    + "<button class='campus-light-btn danger-lite' type='button' data-delete-activity='" + activity.id + "'>删除</button>"
                    + "</div></article>";
            }).join("");
            document.querySelectorAll("[data-edit-activity]").forEach((button) => {
                button.addEventListener("click", async function () {
                    try {
                        const result = await requestJson("/api/admin/activities/" + button.dataset.editActivity);
                        fillActivityForm(result.data);
                        showFeedback("activity-feedback", "活动信息已回显，可直接修改后保存。", true);
                    } catch (error) {
                        showFeedback("activity-feedback", error.message, false);
                    }
                });
            });
            document.querySelectorAll("[data-delete-activity]").forEach((button) => {
                button.addEventListener("click", async function () {
                    if (!window.confirm("确认删除这场活动吗？")) {
                        return;
                    }
                    try {
                        await requestJson("/api/admin/activities/" + button.dataset.deleteActivity + "/delete", { method: "POST" });
                        showFeedback("activity-feedback", "活动已删除。", true);
                        if (state.editingActivityId === Number(button.dataset.deleteActivity)) {
                            closeModal("activity-form-modal");
                        }
                        await loadActivities();
                        await refreshOverviewQuietly("activity-feedback");
                    } catch (error) {
                        showFeedback("activity-feedback", error.message, false);
                    }
                });
            });
            document.querySelectorAll("[data-staticize-activity]").forEach((button) => {
                button.addEventListener("click", async function () {
                    const staticPageWindow = window.open("", "_blank");
                    try {
                        const result = await requestJson("/api/admin/activities/" + button.dataset.staticizeActivity + "/staticize", { method: "POST" });
                        const staticPage = result.data || {};
                        if (staticPageWindow && staticPage.accessUrl) {
                            staticPageWindow.location.href = staticPage.accessUrl;
                        } else if (staticPageWindow) {
                            staticPageWindow.close();
                        }
                        if (!staticPageWindow && staticPage.accessUrl) {
                            window.open(staticPage.accessUrl, "_blank");
                        }
                        showFeedback("activity-feedback", "静态页已生成并打开：" + (staticPage.outputPath || "-"), true);
                        await loadOverview();
                        await loadActivities();
                    } catch (error) {
                        if (staticPageWindow) {
                            staticPageWindow.close();
                        }
                        showFeedback("activity-feedback", error.message, false);
                    }
                });
            });
            document.querySelectorAll("[data-export-activity-pdf]").forEach((button) => {
                button.addEventListener("click", async function () {
                    if (button.dataset.running === "1") {
                        return;
                    }
                    const originalText = button.textContent;
                    button.dataset.running = "1";
                    button.disabled = true;
                    button.textContent = "导出中...";
                    try {
                        await exportActivityPdf(button.dataset.exportActivityPdf);
                    } finally {
                        button.disabled = false;
                        button.textContent = originalText;
                        button.dataset.running = "0";
                    }
                });
            });
            renderQuickStats();
        }

        function parseDownloadFilename(disposition, fallbackName) {
            const value = String(disposition || "");
            const utf8Match = value.match(/filename\*=UTF-8''([^;]+)/i);
            if (utf8Match && utf8Match[1]) {
                try {
                    return decodeURIComponent(utf8Match[1]);
                } catch (error) {
                    return utf8Match[1];
                }
            }
            const plainMatch = value.match(/filename="?([^\";]+)"?/i);
            return plainMatch && plainMatch[1] ? plainMatch[1] : fallbackName;
        }

        async function exportActivityPdf(activityId) {
            try {
                const response = await axios.get("/api/admin/reports/activity/" + encodeURIComponent(activityId) + "/pdf", {
                    withCredentials: true,
                    responseType: "blob",
                    headers: {
                        "X-Requested-With": "XMLHttpRequest"
                    }
                });
                const contentType = String(response.headers["content-type"] || "");
                if (contentType.indexOf("application/pdf") < 0) {
                    const errorText = await response.data.text();
                    throw new Error(errorText || "PDF 导出失败，请稍后重试。");
                }
                const filename = parseDownloadFilename(response.headers["content-disposition"], "activity-" + activityId + "-report.pdf");
                const blobUrl = window.URL.createObjectURL(response.data);
                const link = document.createElement("a");
                link.href = blobUrl;
                link.download = filename;
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
                window.setTimeout(function () {
                    window.URL.revokeObjectURL(blobUrl);
                }, 1000);
                showFeedback("activity-feedback", "PDF 已开始下载。", true);
            } catch (error) {
                let message = resolveAxiosError(error);
                const response = error && error.response ? error.response : null;
                const data = response ? response.data : null;
                if (data instanceof Blob) {
                    try {
                        const rawText = await data.text();
                        if (rawText) {
                            try {
                                const parsed = JSON.parse(rawText);
                                if (parsed && parsed.message) {
                                    message = parsed.message;
                                } else {
                                    message = rawText;
                                }
                            } catch (parseError) {
                                message = rawText;
                            }
                        }
                    } catch (blobError) {
                    }
                }
                showFeedback("activity-feedback", message, false);
            }
        }

        async function exportMonthlyReportPdf() {
            try {
                const response = await axios.get("/api/admin/reports/monthly.pdf", {
                    withCredentials: true,
                    responseType: "blob",
                    headers: {
                        "X-Requested-With": "XMLHttpRequest"
                    }
                });
                const contentType = String(response.headers["content-type"] || "");
                if (contentType.indexOf("application/pdf") < 0) {
                    const errorText = await response.data.text();
                    throw new Error(errorText || "月度运营 PDF 导出失败，请稍后重试。");
                }
                const filename = parseDownloadFilename(response.headers["content-disposition"], "monthly-operation-report.pdf");
                const blobUrl = window.URL.createObjectURL(response.data);
                const link = document.createElement("a");
                link.href = blobUrl;
                link.download = filename;
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
                window.setTimeout(function () {
                    window.URL.revokeObjectURL(blobUrl);
                }, 1000);
                showFeedback("overview-feedback", "月度运营 PDF 已开始下载。", true);
            } catch (error) {
                let message = resolveAxiosError(error);
                const response = error && error.response ? error.response : null;
                const data = response ? response.data : null;
                if (data instanceof Blob) {
                    try {
                        const rawText = await data.text();
                        if (rawText) {
                            try {
                                const parsed = JSON.parse(rawText);
                                if (parsed && parsed.message) {
                                    message = parsed.message;
                                } else {
                                    message = rawText;
                                }
                            } catch (parseError) {
                                message = rawText;
                            }
                        }
                    } catch (blobError) {
                    }
                }
                showFeedback("overview-feedback", message, false);
            }
        }

        async function createActivity() {
            const payload = {
                id: state.editingActivityId,
                title: document.getElementById("activity-title-input").value.trim(),
                location: document.getElementById("activity-location-input").value.trim(),
                summary: document.getElementById("activity-summary-input").value.trim(),
                startTime: document.getElementById("activity-start-input").value,
                endTime: document.getElementById("activity-end-input").value,
                maxParticipants: Number(document.getElementById("activity-max-input").value || 0),
                status: document.getElementById("activity-status-input").value,
                posterUrl: document.getElementById("activity-poster-input").value.trim() || "/static/img/activity-1.svg"
            };
            try {
                assertInput(payload.title, "请输入活动标题");
                assertInput(payload.location, "请输入活动地点");
                assertInput(payload.summary, "请输入活动简介");
                assertInput(payload.startTime, "请选择开始时间");
                assertInput(payload.endTime, "请选择结束时间");
                if (new Date(payload.endTime).getTime() <= new Date(payload.startTime).getTime()) {
                    throw new Error("结束时间必须晚于开始时间");
                }
                await requestJson("/api/admin/activities", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                        "X-Requested-With": "XMLHttpRequest"
                    },
                    body: JSON.stringify(payload)
                });
                showFeedback("activity-feedback", state.editingActivityId ? "活动信息已更新，静态页已同步刷新。" : "新活动已创建，并已自动生成静态页。", true);
                resetActivityForm();
                closeModal("activity-form-modal", false);
                await loadActivities();
                await refreshOverviewQuietly("activity-feedback");
            } catch (error) {
                showFeedback("activity-feedback", error.message, false);
            }
        }

        bindModalDismiss();
        registerPanelModal({
            modalId: "merchant-form-modal",
            panelId: "merchant-form-panel",
            triggerIds: ["open-merchant-modal"],
            beforeOpen: resetMerchantForm,
            reset: resetMerchantForm,
            wide: true
        });
        registerPanelModal({
            modalId: "dish-form-modal",
            panelId: "dish-form-panel",
            triggerIds: ["open-dish-modal"],
            beforeOpen: resetDishForm,
            reset: resetDishForm,
            wide: true
        });
        registerPanelModal({
            modalId: "package-form-modal",
            panelId: "package-form-panel",
            triggerIds: ["open-package-modal"],
            beforeOpen: resetPackageForm,
            reset: resetPackageForm,
            wide: true
        });
        registerPanelModal({
            modalId: "study-room-form-modal",
            panelId: "study-room-form-panel",
            triggerIds: ["open-study-room-modal"],
            beforeOpen: resetStudyRoomForm,
            reset: resetStudyRoomForm,
            wide: false
        });
        registerPanelModal({
            modalId: "activity-form-modal",
            panelId: "activity-form-panel",
            triggerIds: ["open-activity-modal"],
            beforeOpen: resetActivityForm,
            reset: resetActivityForm,
            wide: true
        });

        const initialAdminPage = document.body.dataset.adminPage || "overview";
        switchPanel(sectionMeta[initialAdminPage] ? initialAdminPage : "overview");

        document.querySelectorAll(".campus-admin-sidebar [data-target]").forEach((link) => {
            link.addEventListener("click", function (event) {
                const target = link.dataset.target;
                if (!sectionMeta[target]) {
                    return;
                }
                event.preventDefault();
                switchPanel(target);
                window.history.replaceState(null, "", "/admin/" + target);
            });
        });

        document.getElementById("refresh-overview").addEventListener("click", function () {
            runWithButton("refresh-overview", "刷新中...", loadOverview);
        });
        document.getElementById("export-monthly-pdf").addEventListener("click", function () {
            runWithButton("export-monthly-pdf", "导出中...", exportMonthlyReportPdf);
        });
        document.getElementById("search-merchants").addEventListener("click", function () {
            runWithButton("search-merchants", "查询中...", function () {
                return loadMerchants(document.getElementById("merchant-keyword").value.trim());
            });
        });
        document.getElementById("save-merchant").addEventListener("click", function () {
            runWithButton("save-merchant", "保存中...", createMerchant);
        });
        document.getElementById("cancel-merchant-edit").addEventListener("click", function () {
            closeModal("merchant-form-modal");
        });
        document.getElementById("merchant-logo").addEventListener("input", function () {
            setImagePreview("merchant-logo-preview", this.value, "/static/img/light-food.jpg");
        });
        document.getElementById("upload-merchant-logo").addEventListener("click", function () {
            runWithButton("upload-merchant-logo", "上传中...", function () {
                return uploadImage("merchant", "merchant-logo-file", "merchant-logo", "merchant-logo-preview", "merchant-feedback");
            });
        });
        document.getElementById("dish-merchant-select").addEventListener("change", loadDishData);
        document.getElementById("refresh-dish").addEventListener("click", function () {
            runWithButton("refresh-dish", "刷新中...", loadDishData);
        });
        document.getElementById("refresh-package").addEventListener("click", function () {
            runWithButton("refresh-package", "刷新中...", loadDishData);
        });
        document.getElementById("search-dishes").addEventListener("click", function () {
            runWithButton("search-dishes", "筛选中...", loadDishData);
        });
        document.getElementById("reset-dishes").addEventListener("click", function () {
            document.getElementById("dish-keyword").value = "";
            document.getElementById("dish-category-filter").value = "";
            document.getElementById("dish-on-sale-filter").value = "";
            loadDishData();
        });
        document.getElementById("save-category").addEventListener("click", function () {
            runWithButton("save-category", "保存中...", createCategory);
        });
        document.getElementById("dish-image-preset").addEventListener("change", function () {
            document.getElementById("dish-image").value = this.value;
            setImagePreview("dish-image-preview", this.value, "/static/img/dishes/chicken-breast-bowl.jpg");
        });
        document.getElementById("dish-image").addEventListener("input", function () {
            setImagePreview("dish-image-preview", this.value, "/static/img/dishes/chicken-breast-bowl.jpg");
        });
        document.getElementById("upload-dish-image").addEventListener("click", function () {
            runWithButton("upload-dish-image", "上传中...", function () {
                return uploadImage("dish", "dish-image-file", "dish-image", "dish-image-preview", "dish-feedback");
            });
        });
        document.getElementById("save-dish").addEventListener("click", function () {
            runWithButton("save-dish", "保存中...", createDish);
        });
        document.getElementById("cancel-dish-edit").addEventListener("click", function () {
            closeModal("dish-form-modal");
        });
        document.getElementById("save-package").addEventListener("click", function () {
            runWithButton("save-package", "保存中...", createPackage);
        });
        document.getElementById("cancel-package-edit").addEventListener("click", function () {
            closeModal("package-form-modal");
        });
        document.getElementById("refresh-study").addEventListener("click", function () {
            runWithButton("refresh-study", "刷新中...", loadStudyRooms);
        });
        document.getElementById("save-study-room").addEventListener("click", function () {
            runWithButton("save-study-room", "保存中...", saveStudyRoom);
        });
        document.getElementById("cancel-study-room-edit").addEventListener("click", function () {
            closeModal("study-room-form-modal");
        });
        document.getElementById("save-study-rule").addEventListener("click", function () {
            runWithButton("save-study-rule", "保存中...", saveStudyRule);
        });
        document.getElementById("study-rule-room").addEventListener("change", async function () {
            state.currentStudyRuleRoomId = Number(this.value || 0) || null;
            await loadCurrentStudyRule();
            await loadStudyCalendar();
        });
        document.getElementById("import-seat-file").addEventListener("click", function () {
            runWithButton("import-seat-file", "导入中...", importSeats);
        });
        document.getElementById("refresh-activities").addEventListener("click", function () {
            runWithButton("refresh-activities", "刷新中...", loadActivities);
        });
        document.getElementById("save-activity").addEventListener("click", function () {
            runWithButton("save-activity", "保存中...", createActivity);
        });
        document.getElementById("activity-poster-input").addEventListener("input", function () {
            setImagePreview("activity-poster-preview", this.value, "/static/img/activity-1.svg");
        });
        document.getElementById("upload-activity-poster").addEventListener("click", function () {
            runWithButton("upload-activity-poster", "上传中...", function () {
                return uploadImage("activity", "activity-poster-file", "activity-poster-input", "activity-poster-preview", "activity-feedback");
            });
        });
        document.getElementById("cancel-activity-edit").addEventListener("click", function () {
            closeModal("activity-form-modal");
        });
        document.getElementById("search-admin-audit").addEventListener("click", function () {
            runWithButton("search-admin-audit", "筛选中...", function () {
                state.auditPageNum = 1;
                return loadAdminAuditLogs();
            });
        });
        document.getElementById("reset-admin-audit").addEventListener("click", function () {
            document.getElementById("admin-audit-module").value = "";
            document.getElementById("admin-audit-result").value = "";
            document.getElementById("admin-audit-operator").value = "";
            document.getElementById("admin-audit-start").value = "";
            document.getElementById("admin-audit-end").value = "";
            state.auditPageNum = 1;
            loadAdminAuditLogs();
        });
        document.getElementById("admin-audit-prev").addEventListener("click", function () {
            if (state.auditPageNum > 1) {
                state.auditPageNum -= 1;
                loadAdminAuditLogs();
            }
        });
        document.getElementById("admin-audit-next").addEventListener("click", function () {
            const totalPage = Math.max(1, Math.ceil(state.auditTotal / state.auditPageSize));
            if (state.auditPageNum < totalPage) {
                state.auditPageNum += 1;
                loadAdminAuditLogs();
            }
        });
        window.addEventListener("resize", resizeOverviewCharts);

        resetMerchantForm();
        resetDishForm();
        resetPackageForm();
        resetStudyRoomForm();
        resetActivityForm();
        loadAdminContext()
            .then(function () {
                return loadOverview();
            })
            .then(function () {
                const tasks = [loadMerchants("")];
                tasks.push(loadStudyRooms(), loadActivities(), loadAdminAuditLogs());
                return Promise.all(tasks);
            })
            .then(loadDishData)
            .catch(function (error) {
                console.error("后台初始化失败", error);
                showFeedback("merchant-feedback", "后台初始化失败：" + error.message, false);
                showFeedback("dish-feedback", "后台初始化失败：" + error.message, false);
                showFeedback("study-feedback", "后台初始化失败：" + error.message, false);
                showFeedback("activity-feedback", "后台初始化失败：" + error.message, false);
                document.getElementById("overview-system-runtime").innerHTML = "<article class='admin-runtime-card'><strong>初始化失败</strong><p>" + escapeHtml(error.message || "请刷新页面后重试。") + "</p><span>已保留页面结构，便于继续排查。</span></article>";
                document.getElementById("overview-monthly-report").innerHTML = "<tr><td colspan='4' class='admin-empty'>初始化失败：" + escapeHtml(error.message || "请刷新页面后重试。") + "</td></tr>";
            });
    })();
</script>
</body>
</html>
