<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Healthy Food</title>
        <link rel="stylesheet" href="assets/css/style.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    </head>
    <body>
        <header>
            <div class="container">
                <div class="logo">
                    <img src="assets/images/logo.png" alt="logo">
                </div>
                <nav>
                    <ul>
                        <li><a href="#">Home</a></li>
                        <li><a href="#">Order</a></li>
                        <li><a href="#">Menu</a></li>
                        <li><a href="#">Blog</a></li>
                        <li><a href="#">About Us</a></li>
                    </ul>
                </nav>
                <a href="cart.jsp" class="cart" title="Giỏ hàng">
                    <img src="assets/images/shopping-cart.png" alt="Cart" />
                </a>

                <div class="auth-buttons">
                    <a href="#" class="auth-button">Sign In</a>
                    <a href="#" class="auth-button">Sign Up</a>
                </div>

            </div>
            
        </div>
    </header>
    

        <div class="search-bar">
            <form action="search">
                <input type="text" placeholder="Search food name..." required />        
            </form>

        </div>

        <section class="hero">


            <div class="container">
                <div class="hero-text">
                    <h1>Healthy Food for a Healthy Life</h1>
                    <p>Eat fresh, stay healthy, and live better with our curated healthy meals delivered to your door.</p>
                    <a href="#" class="cta-button">Explore Menu</a>
                </div>
                <div class="hero-image">
                    <img src="assets/images/homepage.jpg" alt="Healthy Food">
                </div>
            </div>
        </section>
        <footer>
            <div class="container">
                <p>&copy; 2025 HealthyFood. All rights reserved.</p>
            </div>
        </footer>
    </body>
</html>

