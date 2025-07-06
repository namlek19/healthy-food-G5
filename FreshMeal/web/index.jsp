<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Healthy Food</title>
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/header-user.css"> 
        <link rel="stylesheet" href="assets/css/footer.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        
    </head>
    <body>
        <jsp:include page="includes/header.jsp" />

        <div class="search-bar">
            <form action="search">
                <input type="text" placeholder="Searching for food..." required />        
            </form>
        </div>

        <section class="hero py-5">
            <div class="container">
                <div class="row align-items-center">
                    <!-- Cột chữ bên trái -->
                    <div class="col-md-6">
                        <div class="hero-text">
                            <h1>Healthy Food for a Healthy Life</h1>
                            <p>Eat fresh, stay healthy, and live better with our curated healthy meals delivered to your door.</p>
                            <a href="#" class="cta-button">Explore Menu</a>
                        </div>
                    </div>
                    <!-- Cột ảnh bên phải -->
                    <div class="col-md-6">
                        <div class="hero-image text-center">
                            <img src="assets/images/homepage.jpg" alt="Healthy Food" class="img-fluid">
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <section class="latest-products">
            <div class="container">
                <h2 class="section-title">Newest Healthy Dishes</h2>
                <div class="product-grid">
                    <div class="product-card">
                        <img src="assets/images/salmon-teriyaki-quinoa.jpg" alt="Salmon Teriyaki">
                        <h3>Salmon Teriyaki Quinoa Bowl</h3>
                        <p class="price">135,000đ</p>
                    </div>
                    <div class="product-card">
                        <img src="assets/images/healthy-tofu-tiramisu.jpg" alt="Tofu Tiramisu">
                        <h3>Tofu Tiramisu</h3>
                        <p class="price">58,000đ</p>
                    </div>
                    <div class="product-card">
                        <img src="assets/images/banana-oat-protein-smoothie.jpg" alt="Banana Smoothie">
                        <h3>Banana Oat Protein Smoothie</h3>
                        <p class="price">55,000đ</p>
                    </div>
                    <div class="product-card">
                        <img src="assets/images/kaffir-lime-chicken.jpg" alt="Kaffir Chicken">
                        <h3>Kaffir Lime Chicken</h3>
                        <p class="price">89,000đ</p>
                    </div>
                </div>
            </div>
        </section>
        <section class="latest-menus">
            <div class="container">
                <h2 class="section-title">Newest Healthy Menus</h2>
                <div class="menu-grid">
                    <div class="menu-card">
                        <img src="assets/images/rainbow-quinoa-salad.jpg" alt="Menu 1">
                        <h3>Rồng Bay Phượng Múa</h3>
                        <p>Combo for underweight BMI – rich in fiber & protein.</p>
                    </div>
                    <div class="menu-card">
                        <img src="assets/images/cha-ca-hanoi-healthy.jpg" alt="Menu 2">
                        <h3>Chiều Buồn Không Em</h3>
                        <p>Balanced menu for normal BMI and emotional healing.</p>
                    </div>
                    <div class="menu-card">
                        <img src="assets/images/grilled-tofu-lemongrass.jpg" alt="Menu 3">
                        <h3>Mãi Mãi Bên Nhau</h3>
                        <p>Low calorie, lots of veggies, ideal for weight control.</p>
                    </div>
                    <div class="menu-card">
                        <img src="assets/images/shrimp-zucchini-noodles.jpg" alt="Menu 4">
                        <h3>Cùng Nhau Giảm Béo</h3>
                        <p>For obesity control – high fiber, low fat.</p>
                    </div>
                </div>
            </div>
        </section>
        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
