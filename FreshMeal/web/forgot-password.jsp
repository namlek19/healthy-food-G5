<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FreshMeal - Forgot Password</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/loginstyle.css">
</head>
<body>
    <div class="container">
        <header class="header">
            <div class="logo">
                <img src="assets/images/logo.png" alt="FreshMeal">
            </div>
            <nav class="nav-links">
                <a href="index.jsp">Home</a>
                <a href="#">Order</a>
                <a href="#">Blog</a>
                <a href="#">About Us</a>
            </nav>
            <div class="auth-buttons">
                <a href="login.jsp" class="auth-button login-button">Log in</a>
                <a href="login.jsp?action=signup" class="auth-button signup-button">Sign up</a>
            </div>
        </header>
    </div>

    <div class="search-bar">
        <div class="container">
            <input type="text" placeholder="Searching for food...">
        </div>
    </div>

    <div class="container">
        <div class="breadcrumb">
            <a href="index.jsp">Home</a> > <a href="login.jsp">Log in</a> > Forgot Password
        </div>

        <div class="auth-container">
            <h2 style="text-align: center; margin: 20px 0; color: #333;">Reset Password</h2>
            
            <% if (request.getAttribute("error") != null) { %>
                <div style="color: #dc3545; text-align: center; margin-bottom: 15px;">
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <% if (request.getAttribute("message") != null) { %>
                <div style="color: #28a745; text-align: center; margin-bottom: 15px;">
                    <%= request.getAttribute("message") %>
                </div>
            <% } %>

            <div class="auth-form">
                <% if (request.getAttribute("showVerificationForm") == null) { %>
                    <!-- Email Form -->
                    <form action="forgotpassword" method="post">
                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" name="email" placeholder="Enter your email" required>
                        </div>
                        <button type="submit" class="submit-button">Send Reset Code</button>
                        <div class="social-login">
                            <p>Remember your password? <a href="login.jsp" style="color: #2ecc71; text-decoration: none;">Back to Login</a></p>
                        </div>
                    </form>
                <% } else { %>
                    <!-- Verification Form -->
                    <form action="forgotpassword" method="post">
                        <input type="hidden" name="action" value="verify">
                        <div class="form-group">
                            <label>Verification Code</label>
                            <input type="text" name="code" placeholder="Enter verification code" required pattern="[0-9]{6}">
                        </div>
                        <div class="form-group">
                            <label>New Password</label>
                            <input type="password" name="newPassword" placeholder="Enter new password" required>
                        </div>
                        <div class="form-group">
                            <label>Confirm Password</label>
                            <input type="password" name="confirmPassword" placeholder="Confirm new password" required>
                        </div>
                        <button type="submit" class="submit-button">Reset Password</button>
                        <div class="social-login">
                            <p>Didn't receive the code? <a href="forgotpassword?action=resend" style="color: #2ecc71; text-decoration: none;">Resend Code</a></p>
                        </div>
                    </form>
                <% } %>
            </div>
        </div>
    </div>

    <footer class="footer">
        <div class="container">
            <div class="footer-grid">
                <div>
                    <img src="assets/images/logo.png" alt="FreshMeal" class="footer-logo">
                    <p class="footer-description">
                        Healthy food provides essential nutrients for the body and helps prevent diseases while supporting energy and maintaining a healthy weight!
                    </p>
                </div>
                <div>
                    <h4 class="footer-heading">Quick links</h4>
                    <ul class="footer-links">
                        <li><a href="index.jsp">Home</a></li>
                        <li><a href="#">Order</a></li>
                        <li><a href="#">Blog</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="footer-heading">Quick links</h4>
                    <ul class="footer-links">
                        <li><a href="#">Trending</a></li>
                        <li><a href="#">About Us</a></li>
                        <li><a href="#">Contact</a></li>
                    </ul>
                </div>
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