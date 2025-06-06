
INSERT INTO Role (RoleName) VALUES
('Admin'),
('Customer'),
('Manager'),
('Seller'),
('Nutritionist'),
('Shipper');


INSERT INTO ProductCategory (CategoryName) VALUES
(N'Món chính'),
(N'Món phụ'),
(N'Tráng miệng'),
(N'Đồ uống');



INSERT INTO Product (Name, Description, NutritionInfo, Origin, ImageURL, StorageInstructions, Price, CategoryID, Calories) VALUES 
-- DANH MỤC 1: MÓN CHÍNH
(
    N'Cơm Gạo Lứt Gà Nướng Herbs',
    N'Cơm gạo lứt organic với ức gà nướng thảo mộc, rau củ nướng và sốt yogurt tự nhiên.',
    N'Protein: 38g, Carbs: 45g, Fat: 12g, Fiber: 6g, Vitamin B, Iron',
    N'Việt Nam',
    N'/images/brown-rice-grilled-chicken.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, hâm nóng trước khi ăn',
    95000.00,
    1,
    450
),
(
    N'Bowl Cá Hồi Teriyaki Quinoa',
    N'Cá hồi nướng sốt teriyaki với quinoa, edamame, cà rốt julienne và rong biển.',
    N'Protein: 42g, Carbs: 38g, Fat: 20g, Omega-3, Vitamin D, B12',
    N'Na Uy - Việt Nam',
    N'/images/salmon-teriyaki-quinoa.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, không đông lạnh',
    135000.00,
    1,
    520
),
(
    N'Thịt Bò Nạc Xào Bông Cải',
    N'Thịt bò nạc xào với bông cải xanh, nấm shiitake và gạo lứt đen.',
    N'Protein: 35g, Carbs: 42g, Fat: 16g, Iron, Zinc, Vitamin C',
    N'Việt Nam',
    N'/images/beef-broccoli-bowl.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, hâm nóng trước khi ăn',
    110000.00,
    1,
    480
),
(
    N'Cà Ri Gà Ít Dầu Với Khoai Lang',
    N'Cà ri gà nhẹ với khoai lang, cà rốt và cơm gạo lứt. Ít dầu, nhiều rau củ.',
    N'Protein: 32g, Carbs: 48g, Fat: 10g, Beta-carotene, Vitamin A',
    N'Việt Nam',
    N'/images/chicken-curry-sweet-potato.jpg',
    N'Bảo quản trong tủ lạnh 2-3 ngày, hâm nóng trước khi ăn',
    88000.00,
    1,
    420
),
(
    N'Tôm Nướng Zucchini Noodles',
    N'Tôm nướng với "mì" từ bí xanh, cà chua bi và sốt pesto tự làm.',
    N'Protein: 28g, Carbs: 18g, Fat: 15g, Iodine, Vitamin C, K',
    N'Việt Nam',
    N'/images/shrimp-zucchini-noodles.jpg',
    N'Bảo quản trong tủ lạnh 1 ngày, tách riêng sốt',
    125000.00,
    1,
    320
),
(
    N'Đậu Hũ Nướng Sả Ớt',
    N'Đậu hũ nướng sả ớt với rau muống xào và cơm quinoa đỏ.',
    N'Protein: 22g, Carbs: 45g, Fat: 12g, Isoflavones, Folate',
    N'Việt Nam',
    N'/images/grilled-tofu-lemongrass.jpg',
    N'Bảo quản trong tủ lạnh 2 ngày, hâm nóng trước khi ăn',
    75000.00,
    1,
    380
),
(
    N'Cá Diêu Hồng Nướng Muối Ớt',
    N'Cá diêu hồng nướng muối ớt với khoai tây baby và salad rau mầm.',
    N'Protein: 36g, Carbs: 35g, Fat: 14g, Omega-3, Selenium',
    N'Việt Nam',
    N'/images/grilled-fish-baby-potato.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, không đông lạnh',
    98000.00,
    1,
    440
),
(
    N'Gà Tần Nấm Linh Chi',
    N'Gà ta tần với nấm linh chi, kỷ tử và đông trùng hạ thảo. Món ăn bổ dưỡng.',
    N'Protein: 40g, Carbs: 12g, Fat: 16g, Collagen, Vitamin B',
    N'Việt Nam',
    N'/images/chicken-lingzhi-soup.jpg',
    N'Bảo quản trong tủ lạnh 2-3 ngày, hâm nóng trước khi dùng',
    145000.00,
    1,
    350
),
(
    N'Chả Cá Thăng Long Healthy',
    N'Chả cá làng Vòng với ít dầu, nhiều thì là và bánh tráng nướng ngũ cốc.',
    N'Protein: 30g, Carbs: 35g, Fat: 13g, Protein, Iron, Zinc',
    N'Việt Nam',
    N'/images/cha-ca-hanoi-healthy.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, hâm nóng trước khi ăn',
    115000.00,
    1,
    390
),
(
    N'Lẩu Thái Chay Nấm Rơm',
    N'Lẩu thái chay với nấm rơm, đậu hũ, rau củ tươi và nước dùng từ xương heo hầm.',
    N'Protein: 18g, Carbs: 32g, Fat: 8g, Fiber: 10g, Vitamin C',
    N'Việt Nam - Thái Lan',
    N'/images/thai-vegetarian-hotpot.jpg',
    N'Dùng ngay, không bảo quản được lâu',
    85000.00,
    1,
    280
),
(
    N'Gà Nướng Mật Ong Quinoa',
    N'Ức gà nướng mật ong với quinoa trộn rau củ và sốt chanh dây tự nhiên.',
    N'Protein: 36g, Carbs: 40g, Fat: 10g, Fiber: 5g, Vitamin C, Magnesium',
    N'Việt Nam',
    N'/images/honey-grilled-chicken-quinoa.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, hâm nóng trước khi ăn',
    92000.00,
    1,
    430
),
(
    N'Cá Thu Nướng Sả Gừng',
    N'Cá thu nướng sả gừng với khoai lang tím và rau cải xào tỏi.',
    N'Protein: 38g, Carbs: 35g, Fat: 18g, Omega-3, Vitamin D, Selenium',
    N'Việt Nam',
    N'/images/mackerel-lemongrass-ginger.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, không đông lạnh',
    105000.00,
    1,
    460
),
(
    N'Bò Áp Chảo Hạt Điều',
    N'Thịt bò áp chảo với hạt điều rang, bông cải xanh và cơm gạo lứt.',
    N'Protein: 40g, Carbs: 38g, Fat: 15g, Iron, Zinc, Vitamin E',
    N'Việt Nam',
    N'/images/beef-cashew-stirfry.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, hâm nóng trước khi ăn',
    115000.00,
    1,
    490
),
(
    N'Tôm Xào Nấm Hương Quinoa',
    N'Tôm xào nấm hương và cải thìa, ăn kèm quinoa trắng và sốt gừng.',
    N'Protein: 30g, Carbs: 36g, Fat: 12g, Iodine, Vitamin C, Fiber',
    N'Việt Nam',
    N'/images/shrimp-shiitake-quinoa.jpg',
    N'Bảo quản trong tủ lạnh 1 ngày, hâm nóng trước khi ăn',
    120000.00,
    1,
    380
),
(
    N'Gà Hấp Lá Chanh Kaffir',
    N'Gà ta hấp lá chanh Kaffir với gạo lứt đỏ và rau củ hấp.',
    N'Protein: 35g, Carbs: 42g, Fat: 8g, Vitamin B6, Potassium',
    N'Việt Nam',
    N'/images/kaffir-lime-chicken.jpg',
    N'Bảo quản trong tủ lạnh 2-3 ngày, hâm nóng trước khi ăn',
    89000.00,
    1,
    410
),
(
    N'Cá Hồi Áp Chảo Sốt Cam',
    N'Cá hồi áp chảo với sốt cam tươi, khoai tây nghiền và măng tây.',
    N'Protein: 42g, Carbs: 30g, Fat: 22g, Omega-3, Vitamin C, A',
    N'Na Uy - Việt Nam',
    N'/images/salmon-orange-sauce.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, không đông lạnh',
    140000.00,
    1,
    520
),
(
    N'Đậu Hũ Xào Cải Ngọt',
    N'Đậu hũ xào cải ngọt và nấm đông cô, ăn kèm cơm gạo lứt đen.',
    N'Protein: 20g, Carbs: 40g, Fat: 10g, Isoflavones, Fiber, Calcium',
    N'Việt Nam',
    N'/images/tofu-chinese-greens.jpg',
    N'Bảo quản trong tủ lạnh 2 ngày, hâm nóng trước khi ăn',
    72000.00,
    1,
    360
),
(
    N'Lẩu Gà Lá Giang',
    N'Lẩu gà ta với lá giang, nấm rơm và rau muống, ăn kèm bún gạo lứt.',
    N'Protein: 38g, Carbs: 28g, Fat: 12g, Vitamin C, Iron',
    N'Việt Nam',
    N'/images/chicken-jiang-leaf-hotpot.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, hâm nóng trước khi dùng',
    95000.00,
    1,
    400
),
(
    N'Thịt Heo Nướng Hạt Mắc Khén',
    N'Thịt heo nướng hạt mắc khén với khoai môn chiên và rau củ hấp.',
    N'Protein: 34g, Carbs: 38g, Fat: 14g, Vitamin B12, Zinc',
    N'Việt Nam',
    N'/images/pork-mackhen-grilled.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, hâm nóng trước khi ăn',
    98000.00,
    1,
    450
),
(
    N'Cá Lóc Hấp Bầu',
    N'Cá lóc hấp bầu với gừng và hành lá, ăn kèm cơm quinoa đỏ.',
    N'Protein: 36g, Carbs: 35g, Fat: 10g, Vitamin C, Phosphorus',
    N'Việt Nam',
    N'/images/steamed-snakehead-gourd.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, không đông lạnh',
    90000.00,
    1,
    420
),
-- DANH MỤC 2: MÓN PHỤ
(
    N'Salad Quinoa Rau Củ Cầu Vồng',
    N'Salad quinoa với cà rót tím, cà rốt, dưa chuột và sốt dầu oliu balsamic.',
    N'Protein: 12g, Carbs: 40g, Fat: 9g, Fiber: 8g, Vitamin A, C',
    N'Việt Nam',
    N'/images/rainbow-quinoa-salad.jpg',
    N'Bảo quản trong tủ lạnh 2-3 ngày, tách riêng sốt',
    65000.00,
    2,
    280
),
(
    N'Gỏi Đu Đủ Tôm Khô',
    N'Gỏi đu đủ truyền thống với tôm khô, cà rốt và đậu phộng rang.',
    N'Protein: 8g, Carbs: 25g, Fat: 6g, Vitamin C, A, Fiber',
    N'Việt Nam',
    N'/images/papaya-salad-dried-shrimp.jpg',
    N'Dùng ngay sau khi trộn, không bảo quản quá 1 ngày',
    45000.00,
    2,
    180
),
(
    N'Salad Bí Đỏ Nướng Hạt Lanh',
    N'Bí đỏ nướng với rau arugula, hạt lanh và sốt mù tạt mật ong.',
    N'Protein: 6g, Carbs: 32g, Fat: 8g, Beta-carotene, Omega-3',
    N'Việt Nam',
    N'/images/roasted-pumpkin-flax-salad.jpg',
    N'Bảo quản trong tủ lạnh 2 ngày, tách riêng sốt',
    55000.00,
    2,
    220
),
(
    N'Súp Rong Biển Đậu Hũ',
    N'Súp rong biển với đậu hũ non, nấm kim châm và hành lá.',
    N'Protein: 10g, Carbs: 12g, Fat: 4g, Iodine, Calcium',
    N'Việt Nam',
    N'/images/seaweed-tofu-soup.jpg',
    N'Bảo quản trong tủ lạnh 2-3 ngày, hâm nóng trước khi dùng',
    38000.00,
    2,
    120
),
(
    N'Gỏi Ngó Sen Tôm Thịt',
    N'Gỏi ngó sen giòn với tôm và thịt heo luộc, rau thơm tươi.',
    N'Protein: 15g, Carbs: 18g, Fat: 7g, Vitamin C, Fiber',
    N'Việt Nam',
    N'/images/lotus-stem-salad.jpg',
    N'Dùng ngay sau khi trộn, bảo quản tối đa 1 ngày',
    58000.00,
    2,
    200
),
(
    N'Canh Chua Cá Bông Lau',
    N'Canh chua cá bông lau với dứa, đậu bắp và rau thơm miền Tây.',
    N'Protein: 18g, Carbs: 12g, Fat: 3g, Vitamin C, Phosphorus',
    N'Việt Nam',
    N'/images/sour-fish-soup.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, hâm nóng trước khi dùng',
    48000.00,
    2,
    150
),
(
    N'Salad Bắp Cải Tím Táo Xanh',
    N'Salad bắp cải tím với táo xanh, cà rốt và sốt yogurt chanh dây.',
    N'Protein: 4g, Carbs: 28g, Fat: 4g, Vitamin C, K, Anthocyanins',
    N'Việt Nam',
    N'/images/purple-cabbage-apple-salad.jpg',
    N'Bảo quản trong tủ lạnh 2-3 ngày, tách riêng sốt',
    42000.00,
    2,
    160
),
(
    N'Súp Bí Đao Thịt Băm',
    N'Súp bí đao trong với thịt heo băm, nấm hương và hành tây.',
    N'Protein: 12g, Carbs: 15g, Fat: 8g, Vitamin C, Potassium',
    N'Việt Nam',
    N'/images/winter-melon-minced-meat-soup.jpg',
    N'Bảo quản trong tủ lạnh 2-3 ngày, hâm nóng trước khi dùng',
    52000.00,
    2,
    180
),
(
    N'Gỏi Cuốn Tôm Thịt Không Bánh Tráng',
    N'Gỏi cuốn rau củ tươi với tôm, thịt heo luộc, thay bánh tráng bằng lá cải.',
    N'Protein: 12g, Carbs: 8g, Fat: 6g, Vitamin A, C, Folate',
    N'Việt Nam',
    N'/images/lettuce-wrap-shrimp-pork.jpg',
    N'Dùng ngay sau khi làm, không bảo quản được lâu',
    48000.00,
    2,
    140
),
(
    N'Salad Ức Gà Xé Phay',
    N'Salad ức gà xé phay với bắp cải trắng, cà rốt và sốt mè rang.',
    N'Protein: 25g, Carbs: 12g, Fat: 8g, Protein, Vitamin B6',
    N'Việt Nam',
    N'/images/shredded-chicken-salad.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, tách riêng sốt',
    55000.00,
    2,
    220
),
(
    N'Salad Dưa Leo Hạt Óc Chó',
    N'Salad dưa leo với hạt óc chó, rau mầm và sốt dầu giấm mè.',
    N'Protein: 6g, Carbs: 15g, Fat: 10g, Omega-3, Vitamin K',
    N'Việt Nam',
    N'/images/cucumber-walnut-salad.jpg',
    N'Bảo quản trong tủ lạnh 2 ngày, tách riêng sốt',
    48000.00,
    2,
    180
),
(
    N'Canh Nấm Tươi Rau Cải',
    N'Canh nấm tươi với cải xanh và cà rốt, nước dùng rau củ thanh nhẹ.',
    N'Protein: 8g, Carbs: 12g, Fat: 3g, Fiber, Vitamin A',
    N'Việt Nam',
    N'/images/mushroom-greens-soup.jpg',
    N'Bảo quản trong tủ lạnh 2-3 ngày, hâm nóng trước khi dùng',
    40000.00,
    2,
    130
),
(
    N'Gỏi Bắp Chuối Tôm',
    N'Gỏi bắp chuối bào mỏng với tôm luộc, rau răm và nước mắm chanh.',
    N'Protein: 10g, Carbs: 18g, Fat: 5g, Vitamin C, Fiber',
    N'Việt Nam',
    N'/images/banana-blossom-shrimp-salad.jpg',
    N'Dùng ngay sau khi trộn, bảo quản tối đa 1 ngày',
    52000.00,
    2,
    160
),
(
    N'Salad Rau Xanh Hạt Dưa',
    N'Salad rau xanh hỗn hợp với hạt dưa, cà chua bi và sốt chanh leo.',
    N'Protein: 5g, Carbs: 20g, Fat: 7g, Vitamin A, C, Antioxidants',
    N'Việt Nam',
    N'/images/green-salad-pumpkin-seeds.jpg',
    N'Bảo quản trong tủ lạnh 2-3 ngày, tách riêng sốt',
    45000.00,
    2,
    170
),
(
    N'Canh Rau Muống Nấm Đông Cô',
    N'Canh rau muống với nấm đông cô và tỏi phi, nước dùng trong.',
    N'Protein: 7g, Carbs: 10g, Fat: 4g, Vitamin C, Iron',
    N'Việt Nam',
    N'/images/morning-glory-shiitake-soup.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, hâm nóng trước khi dùng',
    38000.00,
    2,
    120
),
-- DANH MỤC 3: TRÁNG MIỆNG
(
    N'Pudding Chia Seed Dừa',
    N'Pudding hạt chia với nước cốt dừa tươi, mật ong và trái cây nhiệt đới.',
    N'Protein: 6g, Carbs: 18g, Fat: 14g, Omega-3, Fiber, Calcium',
    N'Việt Nam',
    N'/images/coconut-chia-pudding.jpg',
    N'Bảo quản trong tủ lạnh 2-3 ngày, đậy kín',
    45000.00,
    3,
    220
),
(
    N'Chè Đậu Đen Không Đường',
    N'Chè đậu đen truyền thống với nước cốt dừa, thay đường bằng stevia tự nhiên.',
    N'Protein: 8g, Carbs: 28g, Fat: 5g, Anthocyanins, Fiber',
    N'Việt Nam',
    N'/images/sugar-free-black-bean-che.jpg',
    N'Bảo quản trong tủ lạnh 2-3 ngày, hâm nóng hoặc dùng lạnh',
    35000.00,
    3,
    180
),
(
    N'Yogurt Hy Lạp Granola Tự Làm',
    N'Yogurt Hy Lạp nguyên chất với granola yến mạch, hạt và mật ong.',
    N'Protein: 18g, Carbs: 32g, Fat: 9g, Probiotics, Calcium',
    N'Việt Nam',
    N'/images/greek-yogurt-homemade-granola.jpg',
    N'Bảo quản trong tủ lạnh 3-5 ngày, tách riêng granola',
    52000.00,
    3,
    280
),
(
    N'Bánh Flan Đậu Xanh Healthy',
    N'Bánh flan đậu xanh với sữa đậu nành, ít đường và gelatin tự nhiên.',
    N'Protein: 6g, Carbs: 24g, Fat: 4g, Protein thực vật, Folate',
    N'Việt Nam',
    N'/images/healthy-mung-bean-flan.jpg',
    N'Bảo quản trong tủ lạnh 3-4 ngày, đậy kín',
    38000.00,
    3,
    160
),
(
    N'Mousse Chocolate Avocado',
    N'Mousse chocolate từ bơ, cacao nguyên chất và mật ong, không dairy.',
    N'Protein: 4g, Carbs: 20g, Fat: 16g, Folate, Vitamin K, Antioxidants',
    N'Việt Nam',
    N'/images/avocado-chocolate-mousse.jpg',
    N'Bảo quản trong tủ lạnh 2-3 ngày, đậy kín',
    48000.00,
    3,
    240
),
(
    N'Panna Cotta Matcha Đậu Đỏ',
    N'Panna cotta matcha Nhật Bản với đậu đỏ, sữa dừa và agar tự nhiên.',
    N'Protein: 5g, Carbs: 26g, Fat: 8g, Antioxidants, L-theanine',
    N'Nhật Bản - Việt Nam',
    N'/images/matcha-red-bean-panna-cotta.jpg',
    N'Bảo quản trong tủ lạnh 2-3 ngày, không đông lạnh',
    55000.00,
    3,
    200
),
(
    N'Chè Bưởi Sữa Dừa',
    N'Chè bưởi tươi với sữa dừa, thạch rau câu và hạt é đường phèn.',
    N'Protein: 3g, Carbs: 28g, Fat: 4g, Vitamin C, Fiber',
    N'Việt Nam',
    N'/images/pomelo-coconut-milk-che.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, dùng lạnh',
    42000.00,
    3,
    150
),
(
    N'Tiramisu Đậu Hũ Healthy',
    N'Tiramisu làm từ đậu hũ tơi, cà phê arabica và bột cacao không đường.',
    N'Protein: 10g, Carbs: 18g, Fat: 12g, Isoflavones, Caffeine',
    N'Ý - Việt Nam',
    N'/images/healthy-tofu-tiramisu.jpg',
    N'Bảo quản trong tủ lạnh 2-3 ngày, đậy kín',
    58000.00,
    3,
    220
),
(
    N'Bánh Panna Cotta Dưa Hấu',
    N'Panna cotta dưa hấu tươi mát với bạc hà và lime, không đường nhân tạo.',
    N'Protein: 4g, Carbs: 18g, Fat: 3g, Lycopene, Vitamin C',
    N'Việt Nam',
    N'/images/watermelon-panna-cotta.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, dùng lạnh',
    45000.00,
    3,
    120
),
(
    N'Chè Thái Hạt Lựu Mix',
    N'Chè thái truyền thống với hạt lựu, thạch dừa và sữa đặc ít đường.',
    N'Protein: 4g, Carbs: 32g, Fat: 6g, Vitamin C, Fiber',
    N'Thái Lan - Việt Nam',
    N'/images/thai-che-mixed-jelly.jpg',
    N'Bảo quản trong tủ lạnh 1-2 ngày, dùng lạnh',
    48000.00,
    3,
    190
),
-- DANH MỤC 4: ĐỒ UỐNG
(
    N'Smoothie Xanh Detox Supreme',
    N'Sinh tố xanh từ rau bina, cần tây, táo xanh, chanh và gừng tươi.',
    N'Protein: 4g, Carbs: 35g, Fat: 2g, Vitamin C, K, Chlorophyll',
    N'Việt Nam',
    N'/images/supreme-green-detox-smoothie.jpg',
    N'Dùng ngay sau khi pha, không bảo quản quá 6 giờ',
    45000.00,
    4,
    180
),
(
    N'Nước Ép Cần Tây Táo Chanh',
    N'Nước ép tươi từ cần tây, táo xanh và chanh tây, không đường.',
    N'Protein: 2g, Carbs: 28g, Fat: 0g, Vitamin C, Potassium',
    N'Việt Nam',
    N'/images/celery-apple-lime-juice.jpg',
    N'Dùng ngay sau khi ép, không bảo quản quá 4 giờ',
    38000.00,
    4,
    120
),
(
    N'Trà Gừng Mật Ong Chanh Dây',
    N'Trà gừng ấm với mật ong rừng và chanh dây tươi, tăng cường miễn dịch.',
    N'Protein: 1g, Carbs: 20g, Fat: 0g, Gingerol, Vitamin C',
    N'Việt Nam',
    N'/images/ginger-honey-passion-tea.jpg',
    N'Dùng ấm ngay sau khi pha, có thể bảo quản 1 ngày',
    32000.00,
    4,
    80
),
(
    N'Smoothie Protein Chuối Yến Mạch',
    N'Smoothie protein từ chuối, yến mạch, sữa hạnh nhân và bơ đậu phộng.',
    N'Protein: 18g, Carbs: 45g, Fat: 8g, Fiber, Potassium',
    N'Việt Nam',
    N'/images/banana-oat-protein-smoothie.jpg',
    N'Dùng ngay sau khi pha, không bảo quản quá 12 giờ',
    55000.00,
    4,
    320
),
(
    N'Nước Dừa Tươi Chia Seed',
    N'Nước dừa tươi nguyên chất với hạt chia ngâm, bạc hà tươi.',
    N'Protein: 3g, Carbs: 18g, Fat: 8g, Electrolytes, Omega-3',
    N'Việt Nam',
    N'/images/fresh-coconut-chia-drink.jpg',
    N'Bảo quản trong tủ lạnh 1 ngày, lắc đều trước khi uống',
    42000.00,
    4,
    160
),
(
    N'Trà Hoa Cúc Mật Ong',
    N'Trà hoa cúc khô pha với mật ong acacia, giúp thư giãn và ngủ ngon.',
    N'Protein: 0g, Carbs: 15g, Fat: 0g, Apigenin, Antioxidants',
    N'Việt Nam',
    N'/images/chamomile-honey-tea.jpg',
    N'Dùng ấm ngay sau khi pha, có thể uống lạnh',
    28000.00,
    4,
    60
),
(
    N'Smoothie Bowl Pitaya Dragon Fruit',
    N'Smoothie thanh long ruột đỏ với chuối, dừa nạo và granola.',
    N'Protein: 6g, Carbs: 52g, Fat: 6g, Betalains, Vitamin C',
    N'Việt Nam',
    N'/images/pitaya-smoothie-bowl-drink.jpg',
    N'Dùng ngay sau khi làm, có thể bảo quản 2 giờ',
    48000.00,
    4,
    280
),
(
    N'Nước Ép Cà Rốt Cam Gừng',
    N'Nước ép cà rốt, cam tươi và gừng non, giàu vitamin A và C.',
    N'Protein: 3g, Carbs: 32g, Fat: 1g, Beta-carotene, Vitamin C',
    N'Việt Nam',
    N'/images/carrot-orange-ginger-juice.jpg',
    N'Dùng ngay sau khi ép, không bảo quản quá 6 giờ',
    42000.00,
    4,
    140
),
(
    N'Kombucha Ginger Lemon Homemade',
    N'Kombucha tự ủ tại nhà với gừng và chanh, giàu probiotics.',
    N'Protein: 0g, Carbs: 7g, Fat: 0g, Probiotics, Vitamin C',
    N'Việt Nam',
    N'/images/homemade-ginger-lemon-kombucha.jpg',
    N'Bảo quản trong tủ lạnh 1 tuần, đậy kín',
    52000.00,
    4,
    30
),
(
    N'Trà Xanh Matcha Latte Sữa Yến Mạch',
    N'Matcha latte với sữa yến mạch, không đường, giàu chất chống oxi hóa.',
    N'Protein: 6g, Carbs: 22g, Fat: 7g, L-theanine, Catechins',
    N'Nhật Bản - Việt Nam',
    N'/images/matcha-oat-milk-latte.jpg',
    N'Dùng ấm hoặc lạnh ngay sau khi pha',
    48000.00,
    4,
    180
);


INSERT INTO Users (FullName, Email, PasswordHash, City, District, Address, HeightCm, WeightKg, BMICategory, RoleID)
VALUES 
(N'Marky Nguyễn', 'nutri1@gmail.com', 'hashedpassword1', N'Hà Nội', N'Cầu Giấy', N'Số 10, đường Láng', 160, 52, N'Bình Thường', 5),
(N'Nguyễn Mai Anh', 'nutri2@gmail.com', 'hashedpassword2', N'Hồ Chí Minh', N'Quận 1', N'123 Nguyễn Huệ', 170, 68, N'Bình Thường', 5),
(N'Nguyễn Thị hoa', 'nutri3@gmail.com', 'hashedpassword3', N'Đà Nẵng', N'Hải Châu', N'456 Bạch Đằng', 158, 50, N'Bình Thường', 5);

select * from Users;

INSERT INTO Menu (MenuName, Description, BMICategory, NutritionistID)
VALUES 
(N'Rồng Bay Phượng Múa', 
 N'Bữa ăn giàu dinh dưỡng cùng Rồng Bay Phượng Múa, cho sức khỏe tăng cường, trái tim khỏe mạnh như Rồng, Phượng.', 
 N'Gầy', 1),
(N'Chim Sẻ Hóa Đại Bàng', 
 N'Combo giàu chất dinh dưỡng, phù hợp với những khách hàng muốn tăng cân. Từ chú chim bé nhỏ hóa thành đại bàng tung cánh hiên ngang', 
 N'Gầy', 1),
 (N'Chiều Buồn Không Em', 
 N'Thực đơn cân đối với đủ nhóm chất, thích hợp để duy trì vóc dáng và tăng cường sức khỏe cho người có chỉ số BMI lý tưởng cũng như đang thất tình.', 
 N'Bình Thường', 2),

(N'Trái Tim Hóa Đá', 
 N'Bữa ăn hài hòa giữa đạm, rau xanh và carb phức, không chỉ giữ dáng mà còn hỗ trợ tiêu hóa và sức khỏe lâu dài. Khi sức khỏe và trái tim của bạn đều hóa đá!', 
 N'Bình Thường', 2),

 (N'Mãi Mãi Bên Nhau', 
 N'Thực đơn ít calo, ưu tiên rau củ và đạm nạc, giúp kiểm soát cân nặng mà vẫn đủ năng lượng cho hoạt động hàng ngày.', 
 N'Thừa Cân', 3),

(N'Cùng Nhau giảm béo', 
 N'Giải pháp ăn uống chuyên sâu cho người béo phì, giàu chất xơ, cùng nhau tăng sức khỏe, giảm cân và tăng sức trẻ.', 
 N'Béo Phì', 1);

INSERT INTO MenuProduct (MenuID, ProductID)
VALUES	(2, 1), 
		(2, 31),
		(2, 41),
		(2, 51),

		(3, 2),
		(3, 32),
		(3, 42),
		(3, 52),


		(4, 3),
		(4, 33),
		(4, 43),
		(4, 53),


		(5, 4),
		(5, 34),
		(5, 44),
		(5, 54),

		(6, 5),
		(6, 35),
		(6, 38),
		(6, 55),

		(7, 6),
		(7, 22),
		(7, 46),
		(7, 48);
