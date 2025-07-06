 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%
    Map<String, String> signupData = (Map<String, String>) session.getAttribute("signupData");
    if (signupData != null) {
        session.removeAttribute("signupData");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Security-Policy" content="script-src 'self' 'unsafe-inline' https://apis.google.com https://accounts.google.com https://www.gstatic.com; frame-src 'self' https://accounts.google.com https://content.googleapis.com;">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FreshMeal - Login & Sign Up</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="assets/css/loginstyle.css">
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <style>
        .popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.3);
            z-index: 1000;
            text-align: center;
        }
        .popup.success {
            border-left: 5px solid #2ecc71;
        }
        .popup-content {
            margin-bottom: 15px;
        }
        .popup-button {
            background-color: #2ecc71;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }
        .small-text {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
            text-align: center;
        }
        .email-error {
            color: #e74c3c;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index: 999;
        }
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid transparent;
            border-radius: 4px;
            text-align: center;
        }
        
        .alert-success {
            color: #155724;
            background-color: #d4edda;
            border-color: #c3e6cb;
        }
        
        .alert-danger {
            color: #721c24;
            background-color: #f8d7da;
            border-color: #f5c6cb;
        }
        
        .password-hint {
            display: block;
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div id="successPopup" class="popup success">
        <div class="popup-content">
            <h3>Success!</h3>
            <p>Your account has been created successfully.</p>
        </div>
        <button class="popup-button" onclick="hidePopup()">OK</button>
    </div>
    <div id="overlay" class="overlay"></div>

    <div class="container">
        <header class="header">
            <div class="logo">
                <img src="assets/images/logoreal.png" alt="FreshMeal">
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


    <div class="container">
        <div class="breadcrumb">
            <a href="index.jsp">Home</a> > <%= request.getParameter("action") != null && request.getParameter("action").equals("signup") ? "Sign up" : "Log in" %>
        </div>

        <div class="auth-container">
            <%-- Display success message if present --%>
            <% 
                String successMessage = (String) session.getAttribute("successMessage");
                if (successMessage != null) {
                    session.removeAttribute("successMessage"); // Clear the message
            %>
                <div class="alert alert-success">
                    <%= successMessage %>
                </div>
            <% } %>

            <%-- Display error message if present --%>
            <% String errorMessage = (String) session.getAttribute("errorMessage"); %>
            <% if (errorMessage != null) { 
                session.removeAttribute("errorMessage");
            %>
                <div class="alert alert-danger" style="margin-top: 5px;"><%= errorMessage %></div>
            <%  } %>

            <div class="auth-tabs">
                <button class="auth-tab <%= request.getParameter("action") == null || !request.getParameter("action").equals("signup") ? "active" : "" %>" onclick="showTab('login')">Log in</button>
                <button class="auth-tab <%= request.getParameter("action") != null && request.getParameter("action").equals("signup") ? "active" : "" %>" onclick="showTab('signup')">Sign up</button>
            </div>

            <div id="loginForm" class="auth-form" <%= (request.getParameter("action") != null && request.getParameter("action").equals("signup")) ? "style=\"display: none;\"" : "style=\"display: block;\"" %>>
                <form action="login" method="post" onsubmit="return handleLogin(event)">
                    <input type="hidden" name="action" value="login">
                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" name="email" id="loginEmail" placeholder="Enter your email" required>
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="password" id="loginPassword" placeholder="Enter your password" required>
                    </div>
                    <div class="remember-forgot">
                        <div>
                            <input type="checkbox" id="remember" name="remember">
                            <label for="remember">Remember me?</label>
                        </div>
                        <a href="forgot-password.jsp">Forgot password?</a>
                    </div>
                    <button type="submit" class="submit-button">Log in</button>
                    <div class="social-login">
                        <p>or sign in with</p>
                        <!-- Google Sign-In Button (rendered by Google) -->
                        <div id="g_id_onload"
                             data-client_id="423890706733-eo05uhbjo9aup4pkpq714evrohqjqcq1.apps.googleusercontent.com"
                             data-context="signin"
                             data-ux_mode="popup"
                             data-callback="handleGoogleCredentialResponse">
                        </div>
                        <div class="g_id_signin" data-type="standard" data-size="large" data-theme="filled_blue" data-text="signin_with" data-shape="rectangular" data-width="auto"></div>
                    </div>
                </form>
            </div>

            <div id="signupForm" class="auth-form" <%= (request.getParameter("action") != null && request.getParameter("action").equals("signup")) ? "style=\"display: block;\"" : "style=\"display: none;\"" %>>
                <form action="login" method="post" onsubmit="return validateSignup(event)">
                    <input type="hidden" name="action" value="register">
                    <div class="form-group">
                        <label>First Name</label>
                        <input type="text" name="firstName" id="firstName" placeholder="Enter your first name" required value='<%= signupData != null && signupData.get("firstName") != null ? signupData.get("firstName") : "" %>'>
                    </div>
                    <div class="form-group">
                        <label>Last Name</label>
                        <input type="text" name="lastName" id="lastName" placeholder="Enter your last name" required value='<%= signupData != null && signupData.get("lastName") != null ? signupData.get("lastName") : "" %>'>
                    </div>
                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" name="email" id="signupEmail" placeholder="Enter your email" required onblur="checkEmailExists(this.value)" value='<%= signupData != null && signupData.get("email") != null ? signupData.get("email") : "" %>'>
                        <div id="emailError" class="email-error"></div>
                    </div>
                    
                    <div class="form-group">
                        <label>City</label>
                        <input type="text" name="city" id="city" placeholder="Enter your city" required value='<%= signupData != null && signupData.get("city") != null ? signupData.get("city") : "" %>'>
                    </div>
                    <div class="form-group">
                        <label>District</label>
                        <input type="text" name="district" id="district" placeholder="Enter your district" required value='<%= signupData != null && signupData.get("district") != null ? signupData.get("district") : "" %>'>
                    </div>
                    <div class="form-group">
                        <label>Address</label>
                        <input type="text" name="address" id="address" placeholder="Enter your address" required value='<%= signupData != null && signupData.get("address") != null ? signupData.get("address") : "" %>'>
                    </div>
                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="password" id="signupPassword" placeholder="Enter your password" required>
                        <small class="password-hint">Password must be at least 8 characters long and contain at least one number</small>
                    </div>
                    <div class="form-group">
                        <label>Confirm Password</label>
                        <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Confirm your password" required>
                    </div>
                    <button type="submit" class="submit-button">Sign up</button>
                    <div class="social-login">
                        <p>or sign in with</p>
                        <!-- Google Sign-In Button (rendered by Google) -->
                        <div class="g_id_signin" data-type="standard" data-size="large" data-theme="filled_blue" data-text="signin_with" data-shape="rectangular" data-width="auto"></div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function validatePassword(password) {
            // Check length
            if (password.length < 8) {
                return "Password must be at least 8 characters long";
            }
            
            // Check for numbers
            if (!/\d/.test(password)) {
                return "Password must contain at least one number";
            }
            
            return ""; // Empty string means valid
        }

        function validateSignup(event) {
            event.preventDefault();
            const password = document.getElementById('signupPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            // Check password requirements
            const passwordError = validatePassword(password);
            if (passwordError) {
                alert(passwordError);
                return false;
            }
            
            // Check if passwords match
            if (password !== confirmPassword) {
                alert('Passwords do not match!');
                return false;
            }
            
            // Submit the form normally
            event.target.submit();
            return false;
        }

        function showTab(tabName) {
            const loginForm = document.getElementById('loginForm');
            const signupForm = document.getElementById('signupForm');
            const tabs = document.getElementsByClassName('auth-tab');
            
            if (tabName === 'login') {
                loginForm.style.display = 'block';
                signupForm.style.display = 'none';
                tabs[0].classList.add('active');
                tabs[1].classList.remove('active');
                history.pushState(null, '', 'login.jsp');
            } else {
                loginForm.style.display = 'none';
                signupForm.style.display = 'block';
                tabs[0].classList.remove('active');
                tabs[1].classList.add('active');
                history.pushState(null, '', 'login.jsp?action=signup');
            }
        }

        function handleLogin(event) {
            event.preventDefault();
            const form = event.target;
            form.submit(); // Regular form submission for login
            return false;
        }

        function showPopup() {
            document.getElementById('successPopup').style.display = 'block';
            document.getElementById('overlay').style.display = 'block';
        }

        function hidePopup() {
            document.getElementById('successPopup').style.display = 'none';
            document.getElementById('overlay').style.display = 'none';
            window.location.href = 'login.jsp';
        }

        async function checkEmailExists(email) {
            if (!email) return;
            try {
                const response = await fetch('login?action=checkEmail&email=' + encodeURIComponent(email));
                const data = await response.json();
                const errorDiv = document.getElementById('emailError');
                const signupSubmitButton = document.querySelector('#signupForm button[type="submit"]');
                // const googleSignupBtn = document.getElementById('googleSignupBtn'); // No longer needed for Google-rendered button

                if (data.exists) {
                    errorDiv.textContent = 'This email is already registered';
                    errorDiv.style.display = 'block';
                    if (signupSubmitButton) signupSubmitButton.disabled = true;
                    // if (googleSignupBtn) googleSignupBtn.disabled = false; // No longer needed
                } else {
                    errorDiv.style.display = 'none';
                    if (signupSubmitButton) signupSubmitButton.disabled = false;
                    // if (googleSignupBtn) googleSignupBtn.disabled = false; // No longer needed
                }
            } catch (error) {
                console.error('Error checking email:', error);
            }
        }

        // New Google Identity Services (GIS) initialization
        let googleClient; // This variable is actually not needed anymore for the Google-rendered button.

        // This function is the callback for Google's library once a credential is received
        function handleGoogleCredentialResponse(response) {
            fetch('login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=googleLogin&idToken=' + encodeURIComponent(response.credential)
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    window.location.href = 'index.jsp';
                } else {
                    alert(data.message || 'Failed to sign in with Google.');
                }
            })
            .catch(() => alert('Failed to sign in with Google.'));
        }

    

    </script>
</body>
</html> 