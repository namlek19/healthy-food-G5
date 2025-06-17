<%@ page import="model.User" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Healthy Food</title>
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/header-user.css"> 
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                font-family: 'Poppins', sans-serif;
            }
            .hero-text h1 {
                color: #2b9348;
            }
            .cta-button {
                background-color: #2b9348;
                color: white;
                padding: 10px 20px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 600;
            }
            .cta-button:hover {
                background-color: #238043;
                color: #fff;
            }
            .search-bar input {
                box-shadow: 0 0 12px rgba(0, 128, 0, 0.2);
                border-radius: 25px;
                padding: 10px 20px;
            }
        </style>
    </head>
    <body>
        <header class="bg-white shadow-sm">
            <div class="container d-flex align-items-center justify-content-between py-3">
                <div class="logo">
                    <img src="assets/images/logo.png" alt="logo">
                </div>
                <nav>
                    <ul class="nav">

                        <li class="nav-item"><a href="productlistcontrol?category=" class="nav-link text-dark" >Product</a></li>
                        <li class="nav-item"><a href="menucus?bmi=" class="nav-link text-dark" >Menu</a></li>
                        <li class="nav-item"><a href="blogcus" class="nav-link text-dark" >Blog</a></li>


                    </ul>
                </nav>
                <div class="header-right">

                    <a href="cart.jsp" class="cart-btn">
                        <span class="cart-icon-wrap">
                            <img src="assets/images/shopping-cart.png" alt="Cart" class="cart-icon">
                                                    </span>
                        <span class="cart-text">Giỏ hàng</span>
                    </a>

                    <% User user = (User) session.getAttribute("user"); %>
                    <% if (user != null) { %>
                    <!-- Dropdown menu cho user đã login -->
                    <div class="user-menu">
                        <button class="user-menu-btn" type="button">
                            <img src="assets/images/user-icon.png" alt="User" class="avatar">
                            <span>
                                <%= user.getFirstName() != null && !user.getFirstName().isEmpty()
                                    ? user.getFirstName()
                                    : user.getFullName() %>
                            </span>
                            <span class="dropdown-arrow">&#9662;</span>
                        </button>
                        <div class="user-dropdown">
                            <a href="profile.jsp">Thông tin cá nhân</a>
                            <a href="order-history">Lịch sử đơn hàng</a>
                            <a href="login?action=logout">Đăng xuất</a>
                        </div>
                    </div>
                    <% } else { %>
                    <div class="auth-buttons">
                        <a href="login.jsp" class="btn btn-outline-success btn-sm">Sign In</a>
                        <a href="login.jsp?action=signup" class="btn btn-outline-success btn-sm">Sign Up</a>
                    </div>
                    <% } %>
                </div>
            </div>
        </header>
        <!-- Dropdown JS -->
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                var userMenu = document.querySelector('.user-menu');
                if (userMenu) {
                    var btn = userMenu.querySelector('.user-menu-btn');
                    btn.addEventListener('click', function (e) {
                        e.stopPropagation();
                        userMenu.classList.toggle('open');
                    });
                    document.addEventListener('click', function () {
                        userMenu.classList.remove('open');
                    });
                }
            });
        </script>

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
        <footer class="bg-light text-center py-4 mt-5">
            <div class="container">
                <p class="mb-0 text-muted">&copy; 2025 HealthyFood. All rights reserved.</p>
            </div>
        </footer>
    </body>
</html>
