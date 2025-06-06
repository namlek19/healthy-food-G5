select * from Role;

select * from ProductCategory;

select * from Product;

select * from Menu;

select 
	m.MenuID,
	m.MenuName,
	m.Description,
	m.BMICategory,
	u.FullName
from Menu m join Users u on m.NutritionistID = u.UserID

select * from MenuProduct;

SELECT 
    m.MenuID,
    m.MenuName,
	m.BMICategory,
    p.Name AS ProductName
FROM 
    MenuProduct mp
JOIN 
    Menu m ON mp.MenuID = m.MenuID
JOIN 
    Product p ON mp.ProductID = p.ProductID
WHERE
	m.MenuID = 2; /* chọn số nè */