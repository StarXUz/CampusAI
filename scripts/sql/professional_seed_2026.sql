SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

START TRANSACTION;

CREATE TABLE IF NOT EXISTS campus_admin_merchant_scope (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    merchant_id BIGINT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_admin_merchant_scope (user_id, merchant_id),
    KEY idx_admin_scope_user (user_id),
    KEY idx_admin_scope_merchant (merchant_id),
    CONSTRAINT fk_admin_scope_user FOREIGN KEY (user_id) REFERENCES campus_user (id) ON DELETE CASCADE,
    CONSTRAINT fk_admin_scope_merchant FOREIGN KEY (merchant_id) REFERENCES campus_merchant (id) ON DELETE CASCADE
);

DELETE FROM campus_package_dish;
DELETE FROM campus_activity_registration;
DELETE FROM campus_reservation_record;
DELETE FROM campus_order;
DELETE FROM campus_dish;
DELETE FROM campus_dish_category;
DELETE FROM campus_package;
DELETE FROM campus_seat;
DELETE FROM campus_reservation_rule;
DELETE FROM campus_activity;
DELETE FROM campus_study_room;
DELETE FROM campus_admin_merchant_scope;
DELETE FROM campus_merchant;
DELETE FROM campus_user_role;
DELETE FROM campus_user;
DELETE FROM campus_role;

ALTER TABLE campus_role AUTO_INCREMENT = 1;
ALTER TABLE campus_user AUTO_INCREMENT = 1;
ALTER TABLE campus_merchant AUTO_INCREMENT = 1;
ALTER TABLE campus_admin_merchant_scope AUTO_INCREMENT = 1;
ALTER TABLE campus_dish_category AUTO_INCREMENT = 1;
ALTER TABLE campus_dish AUTO_INCREMENT = 1;
ALTER TABLE campus_package AUTO_INCREMENT = 1;
ALTER TABLE campus_study_room AUTO_INCREMENT = 1;
ALTER TABLE campus_seat AUTO_INCREMENT = 1;
ALTER TABLE campus_reservation_rule AUTO_INCREMENT = 1;
ALTER TABLE campus_reservation_record AUTO_INCREMENT = 1;
ALTER TABLE campus_activity AUTO_INCREMENT = 1;
ALTER TABLE campus_activity_registration AUTO_INCREMENT = 1;
ALTER TABLE campus_order AUTO_INCREMENT = 1;

INSERT INTO campus_role (id, code, name) VALUES
(1, 'ROLE_SUPER_ADMIN', '超级管理员'),
(2, 'ROLE_MERCHANT_ADMIN', '商家管理员'),
(3, 'ROLE_USER', '学生用户');

INSERT INTO campus_user (id, username, phone, password, enabled, avatar_url, created_at) VALUES
(1, 'platform_super', '13900000001', '$2b$10$r90WZXTLxvi7zim.jpdq9eTRA2zs8lC9mWe1hgEPoP.Q6PULE0mGK', 1, '/static/img/admin.svg', '2026-04-01 09:00:00'),
(2, 'ops_admin', '13900000002', '$2b$10$r90WZXTLxvi7zim.jpdq9eTRA2zs8lC9mWe1hgEPoP.Q6PULE0mGK', 1, '/static/img/admin.svg', '2026-04-01 09:10:00'),
(3, 'merchant_north', '13900001001', '$2b$10$r90WZXTLxvi7zim.jpdq9eTRA2zs8lC9mWe1hgEPoP.Q6PULE0mGK', 1, '/static/img/merchant.svg', '2026-04-01 10:00:00'),
(4, 'merchant_south', '13900001002', '$2b$10$r90WZXTLxvi7zim.jpdq9eTRA2zs8lC9mWe1hgEPoP.Q6PULE0mGK', 1, '/static/img/merchant.svg', '2026-04-01 10:05:00'),
(5, 'merchant_west', '13900001003', '$2b$10$r90WZXTLxvi7zim.jpdq9eTRA2zs8lC9mWe1hgEPoP.Q6PULE0mGK', 1, '/static/img/merchant.svg', '2026-04-01 10:10:00'),
(6, 'student_chenyu', '18810000001', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 08:00:00'),
(7, 'student_linxi', '18810000002', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 08:10:00'),
(8, 'student_wanghao', '18810000003', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 08:20:00'),
(9, 'student_zhangqi', '18810000004', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 08:30:00'),
(10, 'student_sunyi', '18810000005', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 08:40:00'),
(11, 'student_hejing', '18810000006', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 08:50:00'),
(12, 'student_tangyu', '18810000007', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 09:00:00'),
(13, 'student_luoan', '18810000008', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 09:10:00');

INSERT INTO campus_user (id, username, phone, password, enabled, avatar_url, created_at) VALUES
(14, 'student_zhoumo', '18810000009', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 09:20:00'),
(15, 'student_xiaoyu', '18810000010', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 09:30:00'),
(16, 'student_peilin', '18810000011', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 09:40:00'),
(17, 'student_yuchen', '18810000012', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 09:50:00'),
(18, 'student_ruoxi', '18810000013', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 10:00:00'),
(19, 'student_yanting', '18810000014', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 10:10:00'),
(20, 'student_jiangnan', '18810000015', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 10:20:00'),
(21, 'student_kaixin', '18810000016', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 10:30:00'),
(22, 'student_chenxi', '18810000017', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 10:40:00'),
(23, 'student_jingya', '18810000018', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 10:50:00'),
(24, 'student_tianhao', '18810000019', '$2b$10$BlHngT8JkNQKNak.bPjwcuCNT4JFRZdJ16wq4RRUtlQxm.CRii9i6', 1, '/static/img/user.svg', '2026-04-02 11:00:00');

INSERT INTO campus_user_role (user_id, role_id) VALUES
(1, 1), (2, 1), (3, 2), (4, 2), (5, 2),
(6, 3), (7, 3), (8, 3), (9, 3), (10, 3), (11, 3), (12, 3), (13, 3);

INSERT INTO campus_user_role (user_id, role_id) VALUES
(14, 3), (15, 3), (16, 3), (17, 3), (18, 3), (19, 3), (20, 3), (21, 3), (22, 3), (23, 3), (24, 3);

INSERT INTO campus_merchant (id, name, canteen_name, logo_url, contact_phone, audit_status, recommended) VALUES
(1, '知味轻食厨房', '北区一食堂', '/static/img/light-food.jpg', '021-60211001', 'APPROVED', 1),
(2, '匠心盖饭档口', '北区一食堂', '/static/img/dishes/beef-rice-bowl.jpg', '021-60211002', 'APPROVED', 1),
(3, '谷物轻卡沙拉', '南区二食堂', '/static/img/light-food.jpg', '021-60211003', 'APPROVED', 1),
(4, '川湘风味餐线', '南区二食堂', '/static/img/night-food.jpg', '021-60211004', 'APPROVED', 0),
(5, '暖汤面食工坊', '西区三食堂', '/static/img/dishes/beef-brisket-noodles.jpg', '021-60211005', 'APPROVED', 0),
(6, '校园咖啡与烘焙', '图书馆一层', '/static/img/coffee.jpg', '021-60211006', 'APPROVED', 1);

INSERT INTO campus_admin_merchant_scope (user_id, merchant_id) VALUES
(3, 1), (3, 2),
(4, 3), (4, 4),
(5, 5), (5, 6);

INSERT INTO campus_dish_category (id, merchant_id, name, sort_order) VALUES
(1, 1, '轻食主餐', 1), (2, 1, '蛋白加餐', 2), (3, 1, '低糖饮品', 3),
(4, 2, '招牌盖饭', 1), (5, 2, '热卤小食', 2), (6, 2, '汤品', 3),
(7, 3, '轻卡沙拉', 1), (8, 3, '能量碗', 2), (9, 3, '鲜榨饮品', 3),
(10, 4, '湘味现炒', 1), (11, 4, '川味现炒', 2), (12, 4, '米饭套餐', 3),
(13, 5, '汤面', 1), (14, 5, '拌面', 2), (15, 5, '浇头小菜', 3),
(16, 6, '手冲咖啡', 1), (17, 6, '低糖奶咖', 2), (18, 6, '烘焙轻食', 3);

INSERT INTO campus_dish (id, merchant_id, category_id, name, description, price, image_url, on_sale, calories) VALUES
(1, 1, 1, '香煎鸡胸能量餐', '鸡胸肉+藜麦+时蔬，蛋白均衡', 23.00, '/static/img/dishes/chicken-breast-bowl.jpg', 1, 460),
(2, 1, 1, '黑椒牛肉能量餐', '黑椒牛肉搭配糙米饭', 26.00, '/static/img/dishes/black-pepper-beef-rice.jpg', 1, 520),
(3, 1, 2, '水煮蛋双拼', '双蛋补充优质蛋白', 6.00, '/static/img/dishes/boiled-eggs.jpg', 1, 140),
(4, 1, 3, '无糖柠檬气泡水', '0蔗糖低负担饮品', 8.00, '/static/img/dishes/lemon-sparkling-water.jpg', 1, 15),
(5, 2, 4, '黑椒牛肉盖饭', '经典盖饭，分量充足', 22.00, '/static/img/dishes/beef-rice-bowl.jpg', 1, 680),
(6, 2, 4, '照烧鸡排盖饭', '鸡排现烤，咸甜平衡', 20.00, '/static/img/dishes/teriyaki-chicken-rice.jpg', 1, 640),
(7, 2, 5, '卤香鸡翅中', '每日现卤，口感入味', 12.00, '/static/img/dishes/braised-chicken-wings.jpg', 1, 280),
(8, 2, 6, '紫菜蛋花汤', '现煮热汤，清爽解腻', 5.00, '/static/img/dishes/egg-drop-soup.jpg', 1, 85),
(9, 3, 7, '牛油果鸡肉沙拉', '低脂高蛋白，口感清新', 24.00, '/static/img/dishes/avocado-chicken-salad.jpg', 1, 390),
(10, 3, 7, '金枪鱼藜麦沙拉', '高纤维组合，饱腹感好', 25.00, '/static/img/dishes/tuna-quinoa-salad.jpg', 1, 410),
(11, 3, 8, '三文鱼能量碗', '三文鱼+谷物+蔬菜', 29.00, '/static/img/dishes/salmon-bowl.jpg', 1, 500),
(12, 3, 9, '鲜榨橙汁', '现榨现售，不额外加糖', 10.00, '/static/img/dishes/orange-juice.jpg', 1, 95),
(13, 4, 10, '小炒黄牛肉', '湘味现炒，微辣下饭', 24.00, '/static/img/dishes/stir-fried-beef.jpg', 1, 620),
(14, 4, 10, '农家小炒肉', '青椒小炒，香辣开胃', 21.00, '/static/img/dishes/stir-fried-pork.jpg', 1, 590),
(15, 4, 11, '水煮肉片', '川味经典，麻辣过瘾', 23.00, '/static/img/dishes/spicy-pork-slices.jpg', 1, 610),
(16, 4, 12, '番茄鸡蛋套餐', '家常口味，营养均衡', 18.00, '/static/img/dishes/scrambled-egg-tomato-rice.jpg', 1, 520),
(17, 5, 13, '番茄牛腩面', '慢炖牛腩，汤底浓郁', 20.00, '/static/img/dishes/beef-brisket-noodles.jpg', 1, 640),
(18, 5, 13, '菌菇鸡汤面', '鲜菌慢煮，口感清爽', 18.00, '/static/img/dishes/mushroom-chicken-noodles.jpg', 1, 560),
(19, 5, 14, '葱油拌面', '经典拌面，香而不腻', 14.00, '/static/img/dishes/scallion-noodles.jpg', 1, 490),
(20, 5, 15, '卤蛋海带拼盘', '高性价比加餐', 7.00, '/static/img/dishes/braised-egg-kelp.jpg', 1, 160),
(21, 6, 16, '美式咖啡', '中度烘焙，口感清爽', 12.00, '/static/img/coffee.jpg', 1, 8),
(22, 6, 17, '燕麦拿铁', '低糖燕麦奶配方', 16.00, '/static/img/dishes/oat-latte.jpg', 1, 150),
(23, 6, 17, '轻甜卡布奇诺', '奶泡细腻，甜度可控', 15.00, '/static/img/dishes/cappuccino.jpg', 1, 160),
(24, 6, 18, '全麦鸡蛋三明治', '早餐轻食优选', 13.00, '/static/img/dishes/egg-sandwich.jpg', 1, 320);

INSERT INTO campus_package (id, merchant_id, name, theme, status, price, description) VALUES
(1, 1, '减脂训练午餐包', '健身轻卡', 'ONLINE', 31.00, '鸡胸能量餐+双拼蛋+无糖气泡水'),
(2, 2, '高性价比盖饭包', '晚餐主食', 'ONLINE', 26.00, '照烧鸡排盖饭+紫菜蛋花汤'),
(3, 3, '沙拉高纤组合', '轻食优选', 'ONLINE', 33.00, '牛油果鸡肉沙拉+鲜榨橙汁'),
(4, 4, '川湘双拼套餐', '重口味精选', 'ONLINE', 39.00, '小炒黄牛肉+番茄鸡蛋套餐'),
(5, 5, '暖胃面食套餐', '夜间加餐', 'ONLINE', 24.00, '菌菇鸡汤面+卤蛋海带拼盘'),
(6, 6, '学习续航咖啡包', '图书馆伴学', 'ONLINE', 26.00, '燕麦拿铁+全麦鸡蛋三明治'),
(7, 3, '低GI晚餐组合', '控糖推荐', 'ONLINE', 34.00, '金枪鱼藜麦沙拉+鲜榨橙汁'),
(8, 1, '高蛋白恢复包', '运动恢复', 'ONLINE', 32.00, '黑椒牛肉能量餐+双拼蛋');

INSERT INTO campus_package_dish (package_id, dish_id, quantity) VALUES
(1, 1, 1), (1, 3, 1), (1, 4, 1),
(2, 6, 1), (2, 8, 1),
(3, 9, 1), (3, 12, 1),
(4, 13, 1), (4, 16, 1),
(5, 18, 1), (5, 20, 1),
(6, 22, 1), (6, 24, 1),
(7, 10, 1), (7, 12, 1),
(8, 2, 1), (8, 3, 1);

INSERT INTO campus_study_room (id, name, location, open_time, close_time, max_hours, daily_limit) VALUES
(1, '图书馆三层A区', '图书馆3F东侧', '08:00:00', '22:00:00', 4, 2),
(2, '图书馆四层静音区', '图书馆4F北侧', '08:00:00', '22:00:00', 4, 2),
(3, '创新中心共享自习室', '创新中心2F', '09:00:00', '21:00:00', 3, 2);

INSERT INTO campus_reservation_rule (id, study_room_id, max_hours, daily_limit, cancel_before_minutes, enabled) VALUES
(1, 1, 4, 2, 30, 1),
(2, 2, 4, 2, 30, 1),
(3, 3, 3, 2, 30, 1);

INSERT INTO campus_seat (id, study_room_id, seat_code, floor_no, zone_name, status) VALUES
(1, 1, 'A301', 3, '临窗区', 'FREE'), (2, 1, 'A302', 3, '临窗区', 'FREE'), (3, 1, 'A303', 3, '临窗区', 'FREE'),
(4, 1, 'A304', 3, '临窗区', 'FREE'), (5, 1, 'A305', 3, '临窗区', 'FREE'), (6, 1, 'A306', 3, '临窗区', 'FREE'),
(7, 1, 'A321', 3, '安静区', 'FREE'), (8, 1, 'A322', 3, '安静区', 'FREE'), (9, 1, 'A323', 3, '安静区', 'FREE'),
(10, 1, 'A324', 3, '安静区', 'FREE'), (11, 1, 'A325', 3, '安静区', 'FREE'), (12, 1, 'A326', 3, '安静区', 'FREE'),
(13, 2, 'B401', 4, '静音区', 'FREE'), (14, 2, 'B402', 4, '静音区', 'FREE'), (15, 2, 'B403', 4, '静音区', 'FREE'),
(16, 2, 'B404', 4, '静音区', 'FREE'), (17, 2, 'B405', 4, '静音区', 'FREE'), (18, 2, 'B406', 4, '静音区', 'FREE'),
(19, 2, 'B421', 4, '研讨区', 'FREE'), (20, 2, 'B422', 4, '研讨区', 'FREE'), (21, 2, 'B423', 4, '研讨区', 'FREE'),
(22, 2, 'B424', 4, '研讨区', 'FREE'), (23, 2, 'B425', 4, '研讨区', 'FREE'), (24, 2, 'B426', 4, '研讨区', 'FREE'),
(25, 3, 'C201', 2, '共享区', 'FREE'), (26, 3, 'C202', 2, '共享区', 'FREE'), (27, 3, 'C203', 2, '共享区', 'FREE'),
(28, 3, 'C204', 2, '共享区', 'FREE'), (29, 3, 'C205', 2, '共享区', 'FREE'), (30, 3, 'C206', 2, '共享区', 'FREE'),
(31, 3, 'C221', 2, '专注区', 'FREE'), (32, 3, 'C222', 2, '专注区', 'FREE'), (33, 3, 'C223', 2, '专注区', 'FREE'),
(34, 3, 'C224', 2, '专注区', 'FREE'), (35, 3, 'C225', 2, '专注区', 'FREE'), (36, 3, 'C226', 2, '专注区', 'FREE');

-- 扩容至专业演示规模：每个自习室 220 座，总计 660 座（兼容 MySQL 5.7+）
DELIMITER $$
DROP PROCEDURE IF EXISTS seed_study_seats_240$$
CREATE PROCEDURE seed_study_seats_240()
BEGIN
    DECLARE i INT DEFAULT 1;

    -- room 1 add 208 seats: A401-A608
    SET i = 1;
    WHILE i <= 208 DO
        INSERT INTO campus_seat (study_room_id, seat_code, floor_no, zone_name, status)
        VALUES (
            1,
            CONCAT('A', LPAD(400 + i, 3, '0')),
            3,
            CASE
                WHEN i <= 70 THEN '临窗区'
                WHEN i <= 140 THEN '安静区'
                ELSE '开放学习区'
            END,
            'FREE'
        );
        SET i = i + 1;
    END WHILE;

    -- room 2 add 208 seats: B501-B708
    SET i = 1;
    WHILE i <= 208 DO
        INSERT INTO campus_seat (study_room_id, seat_code, floor_no, zone_name, status)
        VALUES (
            2,
            CONCAT('B', LPAD(500 + i, 3, '0')),
            4,
            CASE
                WHEN i <= 70 THEN '静音区'
                WHEN i <= 140 THEN '研讨区'
                ELSE '开放学习区'
            END,
            'FREE'
        );
        SET i = i + 1;
    END WHILE;

    -- room 3 add 208 seats: C301-C508
    SET i = 1;
    WHILE i <= 208 DO
        INSERT INTO campus_seat (study_room_id, seat_code, floor_no, zone_name, status)
        VALUES (
            3,
            CONCAT('C', LPAD(300 + i, 3, '0')),
            2,
            CASE
                WHEN i <= 70 THEN '共享区'
                WHEN i <= 140 THEN '专注区'
                ELSE '开放学习区'
            END,
            'FREE'
        );
        SET i = i + 1;
    END WHILE;
END$$
CALL seed_study_seats_240()$$

-- normalize floors: every study room has 1F/2F/3F
SET @rn := 0$$
UPDATE campus_seat s
JOIN (
    SELECT id, (@rn := @rn + 1) AS rn
    FROM campus_seat
    WHERE study_room_id = 1
    ORDER BY id
) t ON s.id = t.id
SET s.floor_no = CASE
    WHEN t.rn <= 74 THEN 1
    WHEN t.rn <= 147 THEN 2
    ELSE 3
END
WHERE s.study_room_id = 1$$

SET @rn := 0$$
UPDATE campus_seat s
JOIN (
    SELECT id, (@rn := @rn + 1) AS rn
    FROM campus_seat
    WHERE study_room_id = 2
    ORDER BY id
) t ON s.id = t.id
SET s.floor_no = CASE
    WHEN t.rn <= 74 THEN 1
    WHEN t.rn <= 147 THEN 2
    ELSE 3
END
WHERE s.study_room_id = 2$$

SET @rn := 0$$
UPDATE campus_seat s
JOIN (
    SELECT id, (@rn := @rn + 1) AS rn
    FROM campus_seat
    WHERE study_room_id = 3
    ORDER BY id
) t ON s.id = t.id
SET s.floor_no = CASE
    WHEN t.rn <= 74 THEN 1
    WHEN t.rn <= 147 THEN 2
    ELSE 3
END
WHERE s.study_room_id = 3$$

DROP PROCEDURE seed_study_seats_240$$
DELIMITER ;

INSERT INTO campus_activity (id, title, summary, location, poster_url, start_time, end_time, max_participants, status) VALUES
(1, '春季职业发展工作坊', '简历优化与面试模拟，面向大三大四学生', '学术交流中心101', '/static/img/activity-1.svg', '2026-05-06 14:00:00', '2026-05-06 16:30:00', 120, 'OPEN'),
(2, '校园轻食健康周', '营养讲座+食堂轻食试吃，推广健康饮食', '北区一食堂中庭', '/static/img/activity-2.svg', '2026-05-10 11:30:00', '2026-05-10 13:30:00', 180, 'OPEN'),
(3, 'AI 应用实践公开课', '面向全校的AI工具实操训练营', '图书馆报告厅', '/static/img/activity-3.svg', '2026-05-12 18:30:00', '2026-05-12 20:30:00', 200, 'OPEN'),
(4, '创新项目路演日', '学生团队项目展示与评审交流', '创新中心路演厅', '/static/img/activity-1.svg', '2026-05-18 13:30:00', '2026-05-18 17:00:00', 150, 'OPEN'),
(5, '图书馆高效学习法沙龙', '针对期中复习的学习方法分享', '图书馆四层研修区', '/static/img/activity-2.svg', '2026-05-20 19:00:00', '2026-05-20 20:30:00', 90, 'OPEN'),
(6, '毕业季就业政策咨询会', '企业宣讲与就业政策答疑', '大学生活动中心', '/static/img/activity-3.svg', '2026-05-24 14:00:00', '2026-05-24 17:00:00', 160, 'OPEN');

INSERT INTO campus_activity (id, title, summary, location, poster_url, start_time, end_time, max_participants, status) VALUES
(7, '校园夜跑打卡计划', '联合体育部开展夜跑打卡与运动恢复分享', '操场主看台集合点', '/static/img/activity-1.svg', '2026-05-08 19:00:00', '2026-05-08 20:30:00', 220, 'OPEN'),
(8, '四六级冲刺自习营', '提供冲刺讲义、模考资料与晚间答疑', '图书馆三层共享研讨区', '/static/img/activity-2.svg', '2026-05-09 18:00:00', '2026-05-09 21:00:00', 260, 'OPEN'),
(9, '校园咖啡烘焙体验课', '面向咖啡爱好者的手冲与烘焙体验活动', '图书馆一层咖啡角', '/static/img/activity-3.svg', '2026-05-14 15:00:00', '2026-05-14 17:00:00', 80, 'OPEN'),
(10, '考研经验分享午间会', '邀请上岸学长学姐分享择校与复习策略', '学术交流中心202', '/static/img/activity-1.svg', '2026-05-16 12:10:00', '2026-05-16 13:20:00', 140, 'OPEN'),
(11, '食堂新品试吃开放日', '集中展示轻食、面食、咖啡新品并收集反馈', '北区一食堂中庭', '/static/img/activity-2.svg', '2026-05-17 11:00:00', '2026-05-17 13:00:00', 300, 'OPEN'),
(12, '学生组织招新宣讲会', '多个学生组织联合宣讲，介绍项目与岗位', '大学生活动中心A厅', '/static/img/activity-3.svg', '2026-05-22 18:30:00', '2026-05-22 20:30:00', 260, 'OPEN'),
(13, '图书馆静音学习挑战', '连续专注学习打卡，完成即可领取校园文创', '图书馆四层静音区', '/static/img/activity-2.svg', '2026-05-26 09:00:00', '2026-05-26 18:00:00', 120, 'OPEN'),
(14, '春季社团联合展演', '音乐、舞蹈、主持与戏剧社联合演出', '露天音乐广场', '/static/img/activity-1.svg', '2026-05-28 18:00:00', '2026-05-28 20:30:00', 500, 'OPEN');

INSERT INTO campus_activity_registration (id, activity_id, user_id, real_name, student_no, phone, status, registered_at) VALUES
(1, 1, 6, '陈宇', '2023101101', '18810000001', 'REGISTERED', '2026-04-15 10:20:00'),
(2, 1, 7, '林熙', '2023101102', '18810000002', 'REGISTERED', '2026-04-15 10:25:00'),
(3, 2, 8, '王昊', '2023101103', '18810000003', 'REGISTERED', '2026-04-16 09:10:00'),
(4, 3, 9, '张琪', '2023101104', '18810000004', 'REGISTERED', '2026-04-16 13:40:00'),
(5, 3, 10, '孙怡', '2023101105', '18810000005', 'REGISTERED', '2026-04-17 11:30:00'),
(6, 4, 11, '何静', '2023101106', '18810000006', 'REGISTERED', '2026-04-17 15:50:00'),
(7, 5, 12, '唐宇', '2023101107', '18810000007', 'REGISTERED', '2026-04-18 18:05:00'),
(8, 6, 13, '罗安', '2023101108', '18810000008', 'REGISTERED', '2026-04-18 20:15:00');

INSERT INTO campus_activity_registration (id, activity_id, user_id, real_name, student_no, phone, status, registered_at) VALUES
(9, 7, 14, '周默', '2023101109', '18810000009', 'REGISTERED', '2026-04-19 08:40:00'),
(10, 7, 15, '晓雨', '2023101110', '18810000010', 'REGISTERED', '2026-04-19 08:45:00'),
(11, 8, 16, '裴琳', '2023101111', '18810000011', 'REGISTERED', '2026-04-19 09:05:00'),
(12, 8, 17, '宇辰', '2023101112', '18810000012', 'REGISTERED', '2026-04-19 09:08:00'),
(13, 8, 18, '若溪', '2023101113', '18810000013', 'REGISTERED', '2026-04-19 09:12:00'),
(14, 9, 19, '言汀', '2023101114', '18810000014', 'REGISTERED', '2026-04-19 10:30:00'),
(15, 9, 20, '江南', '2023101115', '18810000015', 'REGISTERED', '2026-04-19 10:35:00'),
(16, 10, 21, '开心', '2023101116', '18810000016', 'REGISTERED', '2026-04-19 11:00:00'),
(17, 10, 22, '晨曦', '2023101117', '18810000017', 'REGISTERED', '2026-04-19 11:06:00'),
(18, 11, 23, '静雅', '2023101118', '18810000018', 'REGISTERED', '2026-04-19 11:20:00'),
(19, 11, 24, '天昊', '2023101119', '18810000019', 'REGISTERED', '2026-04-19 11:26:00'),
(20, 12, 6, '陈宇', '2023101101', '18810000001', 'REGISTERED', '2026-04-19 12:05:00'),
(21, 12, 7, '林熙', '2023101102', '18810000002', 'REGISTERED', '2026-04-19 12:07:00'),
(22, 13, 8, '王昊', '2023101103', '18810000003', 'REGISTERED', '2026-04-19 12:30:00'),
(23, 13, 9, '张琪', '2023101104', '18810000004', 'REGISTERED', '2026-04-19 12:36:00'),
(24, 14, 10, '孙怡', '2023101105', '18810000005', 'REGISTERED', '2026-04-19 13:10:00'),
(25, 14, 11, '何静', '2023101106', '18810000006', 'REGISTERED', '2026-04-19 13:12:00'),
(26, 6, 14, '周默', '2023101109', '18810000009', 'REGISTERED', '2026-04-19 13:35:00'),
(27, 3, 15, '晓雨', '2023101110', '18810000010', 'REGISTERED', '2026-04-19 13:38:00'),
(28, 4, 16, '裴琳', '2023101111', '18810000011', 'REGISTERED', '2026-04-19 13:42:00'),
(29, 5, 17, '宇辰', '2023101112', '18810000012', 'REGISTERED', '2026-04-19 13:46:00'),
(30, 11, 18, '若溪', '2023101113', '18810000013', 'REGISTERED', '2026-04-19 13:52:00');

INSERT INTO campus_order (id, user_id, merchant_id, item_type, item_name, total_amount, status, pay_channel, paid_at, created_at) VALUES
(1, 6, 1, 'PACKAGE', '减脂训练午餐包', 31.00, 'PAID', 'WECHAT', '2026-04-17 12:02:00', '2026-04-17 11:58:00'),
(2, 7, 2, 'DISH', '照烧鸡排盖饭', 20.00, 'PAID', 'ALIPAY', '2026-04-17 18:40:00', '2026-04-17 18:35:00'),
(3, 8, 3, 'PACKAGE', '沙拉高纤组合', 33.00, 'PAID', 'CAMPUS_CARD', '2026-04-18 12:16:00', '2026-04-18 12:11:00'),
(4, 9, 4, 'DISH', '番茄鸡蛋套餐', 18.00, 'PAID', 'WECHAT', '2026-04-18 18:20:00', '2026-04-18 18:12:00'),
(5, 10, 5, 'PACKAGE', '暖胃面食套餐', 24.00, 'PAID', 'ALIPAY', '2026-04-18 20:11:00', '2026-04-18 20:05:00'),
(6, 11, 6, 'DISH', '燕麦拿铁', 16.00, 'PAID', 'WECHAT', '2026-04-19 08:15:00', '2026-04-19 08:12:00'),
(7, 12, 1, 'DISH', '香煎鸡胸能量餐', 23.00, 'PAID', 'CAMPUS_CARD', '2026-04-19 12:20:00', '2026-04-19 12:15:00'),
(8, 13, 3, 'DISH', '金枪鱼藜麦沙拉', 25.00, 'UNPAID', NULL, NULL, '2026-04-19 12:40:00'),
(9, 6, 6, 'PACKAGE', '学习续航咖啡包', 26.00, 'PAID', 'WECHAT', '2026-04-19 14:05:00', '2026-04-19 14:01:00'),
(10, 7, 2, 'PACKAGE', '高性价比盖饭包', 26.00, 'PAID', 'ALIPAY', '2026-04-19 18:13:00', '2026-04-19 18:08:00'),
(11, 8, 5, 'DISH', '番茄牛腩面', 20.00, 'PAID', 'WECHAT', '2026-04-19 18:42:00', '2026-04-19 18:35:00'),
(12, 9, 4, 'DISH', '小炒黄牛肉', 24.00, 'UNPAID', NULL, NULL, '2026-04-19 19:10:00');

INSERT INTO campus_order (id, user_id, merchant_id, item_type, item_name, total_amount, status, pay_channel, paid_at, created_at) VALUES
(13, 14, 1, 'DISH', '黑椒牛肉能量餐', 26.00, 'PAID', 'WECHAT', '2026-04-20 08:05:00', '2026-04-20 08:01:00'),
(14, 15, 6, 'PACKAGE', '学习续航咖啡包', 26.00, 'PAID', 'ALIPAY', '2026-04-20 08:16:00', '2026-04-20 08:10:00'),
(15, 16, 2, 'PACKAGE', '高性价比盖饭包', 26.00, 'PAID', 'WECHAT', '2026-04-20 11:32:00', '2026-04-20 11:26:00'),
(16, 17, 3, 'DISH', '三文鱼能量碗', 29.00, 'PAID', 'CAMPUS_CARD', '2026-04-20 11:58:00', '2026-04-20 11:53:00'),
(17, 18, 4, 'DISH', '农家小炒肉', 21.00, 'PAID', 'ALIPAY', '2026-04-20 12:22:00', '2026-04-20 12:18:00'),
(18, 19, 5, 'DISH', '菌菇鸡汤面', 18.00, 'PAID', 'WECHAT', '2026-04-20 12:31:00', '2026-04-20 12:28:00'),
(19, 20, 6, 'DISH', '全麦鸡蛋三明治', 13.00, 'PAID', 'WECHAT', '2026-04-20 13:18:00', '2026-04-20 13:15:00'),
(20, 21, 1, 'PACKAGE', '减脂训练午餐包', 31.00, 'PAID', 'CAMPUS_CARD', '2026-04-20 17:40:00', '2026-04-20 17:35:00'),
(21, 22, 3, 'PACKAGE', '低GI晚餐组合', 34.00, 'PAID', 'ALIPAY', '2026-04-20 17:48:00', '2026-04-20 17:42:00'),
(22, 23, 4, 'DISH', '水煮肉片', 23.00, 'PAID', 'WECHAT', '2026-04-20 18:16:00', '2026-04-20 18:11:00'),
(23, 24, 5, 'PACKAGE', '暖胃面食套餐', 24.00, 'PAID', 'ALIPAY', '2026-04-20 18:42:00', '2026-04-20 18:37:00'),
(24, 6, 2, 'DISH', '黑椒牛肉盖饭', 22.00, 'PAID', 'WECHAT', '2026-04-20 19:01:00', '2026-04-20 18:57:00'),
(25, 7, 6, 'DISH', '美式咖啡', 12.00, 'PAID', 'CAMPUS_CARD', '2026-04-21 08:08:00', '2026-04-21 08:06:00'),
(26, 8, 1, 'DISH', '无糖柠檬气泡水', 8.00, 'PAID', 'WECHAT', '2026-04-21 08:42:00', '2026-04-21 08:39:00'),
(27, 9, 3, 'DISH', '牛油果鸡肉沙拉', 24.00, 'PAID', 'ALIPAY', '2026-04-21 11:46:00', '2026-04-21 11:42:00'),
(28, 10, 4, 'PACKAGE', '川湘双拼套餐', 39.00, 'PAID', 'WECHAT', '2026-04-21 12:09:00', '2026-04-21 12:03:00'),
(29, 11, 5, 'DISH', '葱油拌面', 14.00, 'PAID', 'ALIPAY', '2026-04-21 12:37:00', '2026-04-21 12:34:00'),
(30, 12, 6, 'DISH', '轻甜卡布奇诺', 15.00, 'PAID', 'WECHAT', '2026-04-21 13:26:00', '2026-04-21 13:22:00'),
(31, 13, 2, 'DISH', '卤香鸡翅中', 12.00, 'CANCELLED', NULL, NULL, '2026-04-21 18:06:00'),
(32, 14, 1, 'DISH', '水煮蛋双拼', 6.00, 'UNPAID', NULL, NULL, '2026-04-21 18:30:00'),
(33, 15, 3, 'DISH', '鲜榨橙汁', 10.00, 'PAID', 'CAMPUS_CARD', '2026-04-21 19:00:00', '2026-04-21 18:56:00'),
(34, 16, 6, 'DISH', '燕麦拿铁', 16.00, 'PAID', 'ALIPAY', '2026-04-21 19:24:00', '2026-04-21 19:21:00'),
(35, 17, 4, 'DISH', '番茄鸡蛋套餐', 18.00, 'UNPAID', NULL, NULL, '2026-04-21 19:40:00'),
(36, 18, 5, 'DISH', '番茄牛腩面', 20.00, 'PAID', 'WECHAT', '2026-04-21 20:05:00', '2026-04-21 20:01:00');

INSERT INTO campus_reservation_record (id, user_id, study_room_id, seat_id, reservation_date, start_time, end_time, status, voucher_code, created_at) VALUES
(1, 6, 1, 1, '2026-04-19', '09:00:00', '11:00:00', 'BOOKED', 'RSV-A10001', '2026-04-18 20:00:00'),
(2, 7, 1, 2, '2026-04-19', '13:00:00', '15:00:00', 'BOOKED', 'RSV-A10002', '2026-04-18 20:05:00'),
(3, 8, 2, 13, '2026-04-19', '14:00:00', '16:00:00', 'BOOKED', 'RSV-B20001', '2026-04-18 20:08:00'),
(4, 9, 2, 14, '2026-04-20', '09:00:00', '12:00:00', 'BOOKED', 'RSV-B20002', '2026-04-19 08:30:00'),
(5, 10, 3, 25, '2026-04-20', '10:00:00', '12:00:00', 'BOOKED', 'RSV-C30001', '2026-04-19 09:10:00'),
(6, 11, 1, 7, '2026-04-21', '15:00:00', '17:00:00', 'BOOKED', 'RSV-A10003', '2026-04-19 10:00:00'),
(7, 12, 2, 19, '2026-04-21', '18:00:00', '20:00:00', 'BOOKED', 'RSV-B20003', '2026-04-19 10:20:00'),
(8, 13, 3, 31, '2026-04-22', '09:00:00', '11:00:00', 'BOOKED', 'RSV-C30002', '2026-04-19 11:00:00');

INSERT INTO campus_reservation_record (id, user_id, study_room_id, seat_id, reservation_date, start_time, end_time, status, voucher_code, created_at) VALUES
(9, 14, 1, 40, '2026-04-22', '10:00:00', '12:00:00', 'BOOKED', 'RSV-A10004', '2026-04-20 08:10:00'),
(10, 15, 1, 58, '2026-04-22', '13:00:00', '15:00:00', 'BOOKED', 'RSV-A10005', '2026-04-20 08:16:00'),
(11, 16, 2, 120, '2026-04-22', '14:00:00', '16:00:00', 'BOOKED', 'RSV-B20004', '2026-04-20 09:02:00'),
(12, 17, 2, 162, '2026-04-22', '18:00:00', '20:00:00', 'BOOKED', 'RSV-B20005', '2026-04-20 09:10:00'),
(13, 18, 3, 240, '2026-04-23', '09:00:00', '11:00:00', 'BOOKED', 'RSV-C30003', '2026-04-20 09:25:00'),
(14, 19, 3, 266, '2026-04-23', '11:00:00', '13:00:00', 'BOOKED', 'RSV-C30004', '2026-04-20 09:28:00'),
(15, 20, 1, 88, '2026-04-23', '14:00:00', '17:00:00', 'BOOKED', 'RSV-A10006', '2026-04-20 10:12:00'),
(16, 21, 2, 178, '2026-04-23', '19:00:00', '21:00:00', 'BOOKED', 'RSV-B20006', '2026-04-20 10:20:00'),
(17, 22, 3, 320, '2026-04-24', '08:00:00', '10:00:00', 'BOOKED', 'RSV-C30005', '2026-04-20 11:02:00'),
(18, 23, 1, 109, '2026-04-24', '10:00:00', '12:00:00', 'BOOKED', 'RSV-A10007', '2026-04-20 11:08:00'),
(19, 24, 2, 201, '2026-04-24', '13:00:00', '15:00:00', 'BOOKED', 'RSV-B20007', '2026-04-20 11:14:00'),
(20, 6, 3, 349, '2026-04-24', '15:00:00', '17:00:00', 'BOOKED', 'RSV-C30006', '2026-04-20 11:30:00'),
(21, 7, 1, 125, '2026-04-25', '09:00:00', '12:00:00', 'BOOKED', 'RSV-A10008', '2026-04-20 12:10:00'),
(22, 8, 2, 214, '2026-04-25', '13:00:00', '16:00:00', 'BOOKED', 'RSV-B20008', '2026-04-20 12:16:00'),
(23, 9, 3, 388, '2026-04-25', '18:00:00', '20:00:00', 'BOOKED', 'RSV-C30007', '2026-04-20 12:20:00'),
(24, 10, 1, 142, '2026-04-26', '09:00:00', '11:00:00', 'BOOKED', 'RSV-A10009', '2026-04-20 13:06:00'),
(25, 11, 2, 228, '2026-04-26', '14:00:00', '16:00:00', 'BOOKED', 'RSV-B20009', '2026-04-20 13:08:00'),
(26, 12, 3, 412, '2026-04-26', '18:00:00', '21:00:00', 'BOOKED', 'RSV-C30008', '2026-04-20 13:12:00'),
(27, 13, 1, 166, '2026-04-27', '08:00:00', '10:00:00', 'BOOKED', 'RSV-A10010', '2026-04-20 13:30:00'),
(28, 14, 2, 246, '2026-04-27', '10:00:00', '12:00:00', 'BOOKED', 'RSV-B20010', '2026-04-20 13:32:00'),
(29, 15, 3, 436, '2026-04-27', '14:00:00', '16:00:00', 'BOOKED', 'RSV-C30009', '2026-04-20 13:34:00'),
(30, 16, 1, 190, '2026-04-27', '18:00:00', '20:00:00', 'BOOKED', 'RSV-A10011', '2026-04-20 13:38:00');

COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
