<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - YourApp</title>
    <link rel="stylesheet" href="css/style.css">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <nav class="navbar">
        <div class="logo">
            <img src="images/logo.png" alt="Logo">
        </div>
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="order.jsp">Order</a>
            <a href="blog.jsp">Blog</a>
            <a href="about.jsp">About Us</a>
        </div>
        <div class="auth-buttons">
            <a href="login.jsp" class="login-btn">Log in</a>
            <a href="signup.jsp" class="signup-btn">Sign up</a>
        </div>
    </nav>

    <div class="search-bar">
        <input type="text" placeholder="Searching for food?">
        <button type="submit"><i class="fas fa-search"></i></button>
    </div>

    <div class="breadcrumb">
        <a href="index.jsp">Home</a> > <span class="current-page">Log in</span>
    </div>

    <main class="login-container">
        <div class="login-tabs">
            <div class="tab" onclick="switchTab('login')">Log in</div>
            <div class="tab" onclick="switchTab('signup')">Sign up</div>
        </div>

        <!-- Display error message if any -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                ${errorMessage}
            </div>
        </c:if>

        <!-- Display success message if any -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                ${successMessage}
            </div>
        </c:if>

        <!-- Login Form -->
        <form class="login-form" id="loginForm" action="LoginServlet" method="POST">
            <input type="hidden" name="action" value="login">
            <div class="form-group">
                <label for="login-email">Email Address</label>
                <input type="email" id="login-email" name="email" placeholder="ex: mymail@mail.com" required>
            </div>

            <div class="form-group">
                <label for="login-password">Password</label>
                <div class="password-input">
                    <input type="password" id="login-password" name="password" placeholder="Enter Password" required>
                    <i class="fas fa-eye toggle-password" onclick="togglePassword('login-password')"></i>
                </div>
            </div>

            <div class="form-options">
                <label class="remember-me">
                    <input type="checkbox" id="remember" name="remember">
                    <span>Remember me?</span>
                </label>
                <a href="#" class="forgot-password" onclick="showForgotPassword(event)">Forgot password?</a>
            </div>

            <button type="submit" class="submit-button">Log in</button>

            <div class="divider">
                <span>or log in with</span>
            </div>

            <button type="button" class="google-login" onclick="window.location.href='GoogleAuthServlet'">
                <img src="images/google-icon.png" alt="Google">
                Google
            </button>
        </form>

        <!-- Forgot Password Form -->
        <div class="forgot-password-container hidden" id="forgotPasswordContainer">
            <div class="back-to-login">
                <button onclick="showLoginForm()" class="back-button">
                    <i class="fas fa-arrow-left"></i> Back to Login
                </button>
            </div>
            
            <div class="forgot-password-header">
                <h2>Forgot Password</h2>
                <p>Enter your email address below and we'll send you instructions to reset your password.</p>
            </div>

            <form class="forgot-password-form" id="forgotPasswordForm" action="ForgotPasswordServlet" method="POST">
                <div class="form-group">
                    <label for="forgot-email">Email Address</label>
                    <input type="email" id="forgot-email" name="email" placeholder="Enter your email address" required>
                </div>

                <button type="submit" class="submit-button">Send Reset Link</button>
            </form>

            <!-- Success Message (hidden by default) -->
            <div class="message-box success hidden" id="successMessage">
                <i class="fas fa-check-circle"></i>
                <h3>Check Your Email</h3>
                <p>We have sent a password reset link to your email address. Please check your inbox and follow the instructions.</p>
                <p class="small">Don't see the email? Check your spam folder or <a href="#" onclick="handleResendEmail(event)">click here to resend</a>.</p>
                <button onclick="showLoginForm()" class="submit-button" style="margin-top: 1rem;">
                    Back to Login
                </button>
            </div>

            <!-- Error Message (hidden by default) -->
            <div class="message-box error hidden" id="errorMessage">
                <i class="fas fa-exclamation-circle"></i>
                <h3>Error</h3>
                <p>Sorry, we couldn't process your request. Please try again later.</p>
            </div>
        </div>

        <!-- Signup Form -->
        <form class="signup-form hidden" id="signupForm" action="SignupServlet" method="POST">
            <div class="form-row">
                <div class="form-group half">
                    <label for="first-name">First name</label>
                    <input type="text" id="first-name" name="firstName" placeholder="Enter First name" required>
                </div>
                <div class="form-group half">
                    <label for="last-name">Last name</label>
                    <input type="text" id="last-name" name="lastName" placeholder="Enter Last name" required>
                </div>
            </div>

            <div class="form-group">
                <label for="phone">Phone Number</label>
                <input type="tel" id="phone" name="phone" placeholder="Enter your phone number" required>
            </div>

            <div class="form-group">
                <label for="signup-email">Email Address</label>
                <input type="email" id="signup-email" name="email" placeholder="ex: mymail@mail.com" required>
            </div>

            <div class="form-group">
                <label for="signup-password">Password</label>
                <div class="password-input">
                    <input type="password" id="signup-password" name="password" placeholder="Enter Password" required>
                    <i class="fas fa-eye toggle-password" onclick="togglePassword('signup-password')"></i>
                </div>
            </div>

            <div class="form-group">
                <label for="confirm-password">Confirm Password</label>
                <div class="password-input">
                    <input type="password" id="confirm-password" name="confirmPassword" placeholder="Enter Password" required>
                    <i class="fas fa-eye toggle-password" onclick="togglePassword('confirm-password')"></i>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group half">
                    <label for="height">Your Height</label>
                    <input type="text" id="height" name="height" placeholder="Enter your height" required>
                </div>
                <div class="form-group half">
                    <label for="weight">Your Weight</label>
                    <input type="text" id="weight" name="weight" placeholder="Enter your weight" required>
                </div>
            </div>

            <div class="form-group">
                <label for="city">Your City</label>
                <input type="text" id="city" name="city" placeholder="Enter your city" required>
            </div>

            <div class="form-group">
                <label for="address">Home Address</label>
                <input type="text" id="address" name="address" placeholder="Enter your home address" required>
            </div>

            <button type="submit" class="submit-button">Sign up</button>

            <div class="divider">
                <span>or sign up with</span>
            </div>

            <button type="button" class="google-login" onclick="window.location.href='GoogleAuthServlet'">
                <img src="images/google-icon.png" alt="Google">
                Google
            </button>
        </form>
    </main>

    <footer class="footer">
        <div class="footer-content">
            <div class="footer-logo">
                <img src="images/logo.png" alt="Logo">
                <p>Bringing local groceries shopping directly to the table and help prevent illnesses, while support the eating and sharing a meal together.</p>
            </div>
            <div class="footer-links">
                <div class="footer-column">
                    <h3>Quick links</h3>
                    <a href="index.jsp">Home</a>
                    <a href="order.jsp">Order</a>
                    <a href="blog.jsp">Blog</a>
                </div>
                <div class="footer-column">
                    <h3>Quick links</h3>
                    <a href="trending.jsp">Trending</a>
                    <a href="about.jsp">About us</a>
                    <a href="contact.jsp">Contact</a>
                </div>
                <div class="footer-column">
                    <h3>Legal</h3>
                    <a href="terms.jsp">Terms Of Use</a>
                    <a href="privacy.jsp">Privacy & Cookie</a>
                </div>
            </div>
        </div>
    </footer>

    <script>
        // ... existing JavaScript code ...
    </script>
</body>
</html> 