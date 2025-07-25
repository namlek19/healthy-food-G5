<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FreshMeal - Forgot Password</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/loginstyle.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/header-user.css"> 
    <link rel="stylesheet" href="assets/css/footer.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="includes/header.jsp" />

    <div class="container">
        <div class="auth-container">
            <h2 style="text-align: center; margin: 20px 0; color: #333;">Forgot Password</h2>
            
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

    <jsp:include page="includes/footer.jsp" />
</body>
</html> 