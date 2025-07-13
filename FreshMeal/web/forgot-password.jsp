<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FreshMeal - Quên mật khẩu</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/loginstyle.css">
</head>
<body>
    <div class="container">
        <header class="header">
            <div class="logo">
                <img src="assets/images/logoreal.png" alt="FreshMeal">
            </div>
            <nav class="nav-links">
                <a href="index.jsp">Trang chủ</a>
                <a href="#">Đặt hàng</a>
                <a href="#">Blog</a>
                <a href="#">Về chúng tôi</a>
            </nav>
            <div class="auth-buttons">
                <a href="login.jsp" class="auth-button login-button">Đăng nhập</a>
                <a href="login.jsp?action=signup" class="auth-button signup-button">Đăng ký</a>
            </div>
        </header>
    </div>

    <div class="search-bar">
        <div class="container">
            <input type="text" placeholder="Tìm kiếm món ăn...">
        </div>
    </div>

    <div class="container">
        <div class="breadcrumb">
            <a href="index.jsp">Trang chủ</a> > <a href="login.jsp">Đăng nhập</a> > Quên mật khẩu
        </div>

        <div class="auth-container">
            <h2 style="text-align: center; margin: 20px 0; color: #333;">Đặt lại mật khẩu</h2>
            
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
                            <label>Địa chỉ Email</label>
                            <input type="email" name="email" placeholder="Nhập email của bạn" required>
                        </div>
                        <button type="submit" class="submit-button">Gửi mã đặt lại</button>
                        <div class="social-login">
                            <p>Bạn nhớ mật khẩu? <a href="login.jsp" style="color: #2ecc71; text-decoration: none;">Quay lại đăng nhập</a></p>
                        </div>
                    </form>
                <% } else { %>
                    <!-- Verification Form -->
                    <form action="forgotpassword" method="post">
                        <input type="hidden" name="action" value="verify">
                        <div class="form-group">
                            <label>Mã xác thực</label>
                            <input type="text" name="code" placeholder="Nhập mã xác thực" required pattern="[0-9]{6}">
                        </div>
                        <div class="form-group">
                            <label>Mật khẩu mới</label>
                            <input type="password" name="newPassword" placeholder="Nhập mật khẩu mới" required>
                        </div>
                        <div class="form-group">
                            <label>Xác nhận mật khẩu</label>
                            <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu" required>
                        </div>
                        <button type="submit" class="submit-button">Đặt lại mật khẩu</button>
                        <div class="social-login">
                            <p>Không nhận được mã? <a href="forgotpassword?action=resend" style="color: #2ecc71; text-decoration: none;">Gửi lại mã</a></p>
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
                    <img src="assets/images/logoreal.png" alt="FreshMeal" class="footer-logo">
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