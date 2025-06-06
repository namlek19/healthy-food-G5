CREATE DATABASE SWPproject;
GO
USE SWPproject;
GO

-- 1. Role
CREATE TABLE Role (
    RoleID INT IDENTITY PRIMARY KEY,
    RoleName NVARCHAR(50) UNIQUE NOT NULL
);

-- 2. Users
CREATE TABLE Users (
    UserID INT IDENTITY PRIMARY KEY,
    FullName NVARCHAR(100),
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    City NVARCHAR(100),
    District NVARCHAR(100),
    Address NVARCHAR(255),
    HeightCm FLOAT,
    WeightKg FLOAT,
    BMI AS (WeightKg / POWER(HeightCm / 100.0, 2)) PERSISTED,
    BMICategory NVARCHAR(50),
    RoleID INT FOREIGN KEY REFERENCES Role(RoleID)
);

-- 3. ProductCategory
CREATE TABLE ProductCategory (
    CategoryID INT IDENTITY PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL
);

-- 4. Product
CREATE TABLE Product (
    ProductID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100),
    Description NVARCHAR(MAX),
    Calories INT,
    NutritionInfo NVARCHAR(MAX),
    Origin NVARCHAR(100),
    ImageURL NVARCHAR(255),
    StorageInstructions NVARCHAR(255),
    Price DECIMAL(10,2),
    CreatedAt DATETIME DEFAULT GETDATE(),
    CategoryID INT FOREIGN KEY REFERENCES ProductCategory(CategoryID)
);

-- 5. Menu (Combo)
CREATE TABLE Menu (
    MenuID INT IDENTITY PRIMARY KEY,
    MenuName NVARCHAR(100),
    Description NVARCHAR(MAX),
    BMICategory NVARCHAR(50),
    NutritionistID INT FOREIGN KEY REFERENCES Users(UserID),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 6. MenuProduct
CREATE TABLE MenuProduct (
    MenuID INT,
    ProductID INT,
    PRIMARY KEY (MenuID, ProductID),
    FOREIGN KEY (MenuID) REFERENCES Menu(MenuID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

-- 7. Blog
CREATE TABLE Blog (
    BlogID INT IDENTITY PRIMARY KEY,
    Title NVARCHAR(200),
    ImageURL NVARCHAR(255),
    Description NVARCHAR(MAX),
    NutritionistID INT FOREIGN KEY REFERENCES Users(UserID),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 8. BlogComment
CREATE TABLE BlogComment (
    CommentID INT IDENTITY PRIMARY KEY,
    BlogID INT FOREIGN KEY REFERENCES Blog(BlogID),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    ParentCommentID INT NULL,
    Content NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 9. BlogLike
CREATE TABLE BlogLike (
    BlogID INT,
    UserID INT,
    PRIMARY KEY (BlogID, UserID),
    FOREIGN KEY (BlogID) REFERENCES Blog(BlogID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- 10. Cart
CREATE TABLE Cart (
    CartID INT IDENTITY PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 11. CartItem
CREATE TABLE CartItem (
    CartItemID INT IDENTITY PRIMARY KEY,
    CartID INT FOREIGN KEY REFERENCES Cart(CartID),
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    Quantity INT
);

-- 12. Order
CREATE TABLE [Order] (
    OrderID INT IDENTITY PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    ReceiverName NVARCHAR(100),
    DeliveryAddress NVARCHAR(255),
    District NVARCHAR(100),
    TotalAmount DECIMAL(10,2),
    OrderDate DATETIME DEFAULT GETDATE(),
    Status NVARCHAR(50)
);

-- 13. OrderItem
CREATE TABLE OrderItem (
    OrderItemID INT IDENTITY PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES [Order](OrderID),
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    Quantity INT,
    Price DECIMAL(10,2)
);

-- 14. AllowedDistrict
CREATE TABLE AllowedDistrict (
    DistrictName NVARCHAR(100) PRIMARY KEY
);

-- 15. PasswordResetOTP (for OTP via email)
CREATE TABLE PasswordResetOTP (
    OTPID INT IDENTITY PRIMARY KEY,
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    OTPCode NVARCHAR(10),
    ExpirationTime DATETIME,
    IsUsed BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE()
);