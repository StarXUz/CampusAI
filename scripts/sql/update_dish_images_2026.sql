-- 将已存在数据库中的菜品图片批量更新为准确图片（无需重置全库）
-- 执行示例：mysql -uroot -p campus_service_manager_ai < scripts/sql/update_dish_images_2026.sql

UPDATE campus_merchant SET logo_url = '/static/img/light-food.jpg' WHERE name = '知味轻食厨房';
UPDATE campus_merchant SET logo_url = '/static/img/dishes/beef-rice-bowl.jpg' WHERE name = '匠心盖饭档口';
UPDATE campus_merchant SET logo_url = '/static/img/light-food.jpg' WHERE name = '谷物轻卡沙拉';
UPDATE campus_merchant SET logo_url = '/static/img/night-food.jpg' WHERE name = '川湘风味餐线';
UPDATE campus_merchant SET logo_url = '/static/img/dishes/beef-brisket-noodles.jpg' WHERE name = '暖汤面食工坊';
UPDATE campus_merchant SET logo_url = '/static/img/coffee.jpg' WHERE name = '校园咖啡与烘焙';

UPDATE campus_dish SET image_url = '/static/img/dishes/chicken-breast-bowl.jpg' WHERE name = '香煎鸡胸能量餐';
UPDATE campus_dish SET image_url = '/static/img/dishes/black-pepper-beef-rice.jpg' WHERE name = '黑椒牛肉能量餐';
UPDATE campus_dish SET image_url = '/static/img/dishes/boiled-eggs.jpg' WHERE name = '水煮蛋双拼';
UPDATE campus_dish SET image_url = '/static/img/dishes/lemon-sparkling-water.jpg' WHERE name = '无糖柠檬气泡水';
UPDATE campus_dish SET image_url = '/static/img/dishes/beef-rice-bowl.jpg' WHERE name = '黑椒牛肉盖饭';
UPDATE campus_dish SET image_url = '/static/img/dishes/teriyaki-chicken-rice.jpg' WHERE name = '照烧鸡排盖饭';
UPDATE campus_dish SET image_url = '/static/img/dishes/braised-chicken-wings.jpg' WHERE name = '卤香鸡翅中';
UPDATE campus_dish SET image_url = '/static/img/dishes/egg-drop-soup.jpg' WHERE name = '紫菜蛋花汤';
UPDATE campus_dish SET image_url = '/static/img/dishes/avocado-chicken-salad.jpg' WHERE name = '牛油果鸡肉沙拉';
UPDATE campus_dish SET image_url = '/static/img/dishes/tuna-quinoa-salad.jpg' WHERE name = '金枪鱼藜麦沙拉';
UPDATE campus_dish SET image_url = '/static/img/dishes/salmon-bowl.jpg' WHERE name = '三文鱼能量碗';
UPDATE campus_dish SET image_url = '/static/img/dishes/orange-juice.jpg' WHERE name = '鲜榨橙汁';
UPDATE campus_dish SET image_url = '/static/img/dishes/stir-fried-beef.jpg' WHERE name = '小炒黄牛肉';
UPDATE campus_dish SET image_url = '/static/img/dishes/stir-fried-pork.jpg' WHERE name = '农家小炒肉';
UPDATE campus_dish SET image_url = '/static/img/dishes/spicy-pork-slices.jpg' WHERE name = '水煮肉片';
UPDATE campus_dish SET image_url = '/static/img/dishes/scrambled-egg-tomato-rice.jpg' WHERE name = '番茄鸡蛋套餐';
UPDATE campus_dish SET image_url = '/static/img/dishes/beef-brisket-noodles.jpg' WHERE name = '番茄牛腩面';
UPDATE campus_dish SET image_url = '/static/img/dishes/mushroom-chicken-noodles.jpg' WHERE name = '菌菇鸡汤面';
UPDATE campus_dish SET image_url = '/static/img/dishes/scallion-noodles.jpg' WHERE name = '葱油拌面';
UPDATE campus_dish SET image_url = '/static/img/dishes/braised-egg-kelp.jpg' WHERE name = '卤蛋海带拼盘';
UPDATE campus_dish SET image_url = '/static/img/dishes/americano.jpg' WHERE name = '美式咖啡';
UPDATE campus_dish SET image_url = '/static/img/dishes/oat-latte.jpg' WHERE name = '燕麦拿铁';
UPDATE campus_dish SET image_url = '/static/img/dishes/cappuccino.jpg' WHERE name = '轻甜卡布奇诺';
UPDATE campus_dish SET image_url = '/static/img/dishes/egg-sandwich.jpg' WHERE name = '全麦鸡蛋三明治';
