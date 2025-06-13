<%-- 
    Document   : index
    Created on : May 30, 2025, 9:13:24 AM
    Author     : ducna
--%>

<%@ page import="model.User" %>
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
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
                <button class="cart">
                    <img src="assets/images/shopping-cart.png">
                </button>
                <div class="auth-buttons">
                    <% User user = (User) session.getAttribute("user"); %>
                    <% if (user == null) { %>
                        <a href="login.jsp" class="auth-button">Sign In</a>
                        <a href="login.jsp?action=signup" class="auth-button">Sign Up</a>
                    <% } else { %>
                        <a href="profile.jsp" class="auth-button">Hello, <%= user.getFirstName() != null && !user.getFirstName().isEmpty() ? user.getFirstName() : user.getFullName() %></a>
                        <a href="login?action=logout" class="auth-button">Logout</a>
                    <% } %>
                </div>
            </div>
        </header>

        <div class="search-bar">
            <form action="search">
                <input type="text" placeholder="Searching for food..." required />        
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
                <div class="footer-grid">
                    <!-- Logo and Description -->
                    <div>
                        <img src="assets/images/logo.png" alt="FreshMeal" class="footer-logo">
                        <p class="footer-description">
                            Healthy food provides essential nutrients for the body and helps prevent diseases while supporting energy and maintaining a healthy weight!
                        </p>
                    </div>

                    <!-- Quick links -->
                    <div>
                        <h4 class="footer-heading">Quick links</h4>
                        <ul class="footer-links">
                            <li><a href="index.jsp">Home</a></li>
                            <li><a href="#">Order</a></li>
                            <li><a href="#">Blog</a></li>
                        </ul>
                    </div>

                    <!-- Quick links -->
                    <div>
                        <h4 class="footer-heading">Quick links</h4>
                        <ul class="footer-links">
                            <li><a href="#">Trending</a></li>
                            <li><a href="#">About Us</a></li>
                            <li><a href="#">Contact</a></li>
                        </ul>
                    </div>

                    <!-- Legal -->
                    <div>
                        <h4 class="footer-heading">Legal</h4>
                        <ul class="footer-links">
                            <li><a href="#">Term Of Use</a></li>
                            <li><a href="#">Privacy & Cookie</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </footer>
    </body>
</html>

