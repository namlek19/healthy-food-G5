<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <link rel="stylesheet" href="assets/css/homepage-style.css">

        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-ascale=1.0">
        <title>Healthy Food</title>


        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">


    </head>
    <body>

        <!-- HEADER -->
        <header class="main-header shadow-sm">
    <div class="container d-flex align-items-center justify-content-between flex-wrap py-3">
        <div class="d-flex align-items-center gap-4 flex-wrap">
            <a href="index.jsp" class="logo">
                <img src="assets/images/logo.png" alt="logo" style="height: 60px;">
            </a>

            <ul class="nav mb-0">
                <li class="nav-item"><a class="nav-link text-dark" href="#">Home</a></li>
                <li class="nav-item"><a class="nav-link text-dark" href="#">Order</a></li>
                <li class="nav-item"><a class="nav-link text-dark" href="#">Menu</a></li>
                <li class="nav-item"><a class="nav-link text-dark" href="#">Blog</a></li>
                <li class="nav-item"><a class="nav-link text-dark" href="#">About Us</a></li>
            </ul>
        </div>

        <!-- Search bar inline -->
        <form class="search-form d-flex align-items-center" action="search">
            <input class="form-control search-input" type="text" placeholder="Search food name..." required>
        </form>

        <!-- Cart and buttons -->
        <div class="d-flex align-items-center gap-3 mt-2 mt-md-0">
            <a href="cart.jsp" title="Cart">
                <img src="assets/images/shopping-cart.png" alt="Cart" style="width: 24px;">
            </a>
            <a href="#" class="btn btn-outline-success btn-sm">Sign In</a>
            <a href="#" class="btn btn-success btn-sm">Sign Up</a>
        </div>
    </div>
</header>

      
        <!-- HERO SECTION -->
        <section class="hero py-5">
            <div class="container d-flex flex-column flex-md-row align-items-center justify-content-between">
                <div class="hero-text mb-4 mb-md-0">
                    <h1 class="display-5 fw-bold">Healthy Food for a Healthy Life</h1>
                    <p class="lead">Eat fresh, stay healthy, and live better with our curated healthy meals delivered to your door.</p>
                    <a href="#" class="cta-button mt-3">Explore Menu</a>
                </div>
                <div class="hero-image">
                    <img src="assets/images/homepage.jpg" alt="Healthy Food" class="img-fluid rounded-4 shadow-sm" style="max-width: 400px;">
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

        <!-- FOOTER -->
        <footer class="bg-light text-center py-4 mt-5">
            <div class="container">
                <p class="mb-0 text-muted">&copy; 2025 HealthyFood. All rights reserved.</p>
            </div>
        </footer>

        <!-- Bootstrap JS (optional if dropdowns/modal used) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
