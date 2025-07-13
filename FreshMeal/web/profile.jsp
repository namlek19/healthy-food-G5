<%@ page import="model.User,dal.UserDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    String edit = request.getParameter("edit");
    String message = null;
    String passwordMessage = (String) session.getAttribute("passwordMessage");
    Boolean passwordSuccess = (Boolean) session.getAttribute("passwordSuccess");
    session.removeAttribute("passwordMessage");
    session.removeAttribute("passwordSuccess");
    
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String city = request.getParameter("city");
        String district = request.getParameter("district");
        String address = request.getParameter("address");
        user.setFullName(fullName);
        user.setEmail(email);
        user.setCity(city);
        user.setDistrict(district);
        user.setAddress(address);
        UserDAO dao = new UserDAO();
        boolean updated = dao.updateUser(user);
        if (updated) {
            message = "Profile updated successfully.";
            session.setAttribute("user", user); // update session
        } else {
            message = "Failed to update profile.";
        }
    }
    String firstName = user.getFirstName() != null ? user.getFirstName() : "";
    String lastName = user.getLastName() != null ? user.getLastName() : "";
    String mode = request.getParameter("mode");
    if (mode == null) mode = "view";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - <%= user.getFullName() %></title>
    <link rel="stylesheet" href="assets/css/profile.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>
    <header>
        <div class="header-container">
            <div class="logo">
                <img src="assets/images/logo.png" alt="logo">
            </div>
            <nav>
                <ul>
                    <li><a href="index.jsp">Home</a></li>
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
                <a href="profile.jsp" class="auth-button">Hello, <%= firstName.isEmpty() ? user.getFullName() : firstName %></a>
                <a href="login?action=logout" class="auth-button">Logout</a>
            </div>
        </div>
    </header>
    <div class="search-bar">
        <form action="search">
            <input type="text" placeholder="Searching for food..." required />        
        </form>
    </div>
    <div class="container" style="display: flex; gap: 40px; margin-top: 40px; align-items: flex-start; min-height: 600px;">
        <!-- Sidebar -->
        <aside style="width: 280px; background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); padding: 32px 20px 24px 20px; text-align: center;">
            <img src="assets/images/default-avatar.png" alt="User Avatar" style="width: 90px; height: 90px; border-radius: 50%; object-fit: cover; margin-bottom: 16px;">
            <h3 style="margin-bottom: 4px; color: #222; font-size: 1.3rem;"><%= user.getFullName() %></h3>
            <p style="color: #888; margin-bottom: 24px;">Customer</p>
            <nav style="text-align: left;">
                <ul style="list-style: none; padding: 0; margin: 0;">
                    <li style="margin-bottom: 8px;">
                        <a href="order-history" style="display: flex; align-items: center; gap: 10px; padding: 10px 16px; border-radius: 6px; text-decoration: none; font-weight: 500; color: #333;">
                            <span style="font-size: 1.1em;">🛒</span> View Shopping History
                        </a>
                    </li>
                    <li style="margin-bottom: 8px;">
                        <a href="profile.jsp" style="display: flex; align-items: center; gap: 10px; padding: 10px 16px; border-radius: 6px; text-decoration: none; font-weight: 500; <%= (!"edit".equals(mode)) ? "background: #27ae60; color: #fff;" : "color: #333;" %>">
                            <span style="font-size: 1.1em;">👤</span> Profile
                        </a>
                    </li>
                    <li>
                        <a href="profile.jsp?mode=edit" style="display: flex; align-items: center; gap: 10px; padding: 10px 16px; border-radius: 6px; text-decoration: none; font-weight: 500; <%= ("edit".equals(mode)) ? "background: #27ae60; color: #fff;" : "color: #333;" %>">
                            <span style="font-size: 1.1em;">✏️</span> Update Profile
                        </a>
                    </li>
                </ul>
            </nav>
        </aside>
        <!-- Main Content -->
        <main style="flex: 1; background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.04); padding: 32px 32px 24px 32px; min-width: 0;">
            <% if (message != null) { %>
                <div class="alert alert-success" style="margin-bottom: 16px;"><%= message %></div>
            <% } %>
            <% if (passwordMessage != null) { %>
                <div class="alert <%= passwordSuccess ? "alert-success" : "alert-danger" %>" style="margin-bottom: 16px;">
                    <%= passwordMessage %>
                </div>
            <% } %>
            <% if (!"edit".equals(mode)) { %>
                <div class="section-header">Profile Details</div>
                <div class="form-group"><label>First Name:</label> <span><%= firstName %></span></div>
                <div class="form-group"><label>Last Name:</label> <span><%= lastName %></span></div>
                <div class="form-group"><label>Email:</label> <span><%= user.getEmail() %></span></div>
                <div class="form-group"><label>City:</label> <span><%= user.getCity() %></span></div>
                <div class="form-group"><label>District:</label> <span><%= user.getDistrict() %></span></div>
                <div class="form-group"><label>Address:</label> <span><%= user.getAddress() %></span></div>
            <% } else { %>
                <form method="post" action="profile" style="margin-top: 0;">
                    <div class="section-header">Update Profile</div>
                    <div class="form-group">
                        <label>Full Name:</label>
                        <input type="text" name="fullName" value="<%= user.getFullName() %>" required>
                    </div>
                    <div class="form-group">
                        <label>Email:</label>
                        <input type="email" name="email" value="<%= user.getEmail() %>" required>
                    </div>
                    <div class="form-group">
                        <label>City:</label>
                        <input type="text" name="city" value="<%= user.getCity() %>" required>
                    </div>
                    <div class="form-group">
                        <label>District:</label>
                        <input type="text" name="district" value="<%= user.getDistrict() %>" required>
                    </div>
                    <div class="form-group">
                        <label>Address:</label>
                        <input type="text" name="address" value="<%= user.getAddress() %>" required>
                    </div>
                    <div id="change-password-section">
                        <div class="form-group">
                            <label>Current Password:</label>
                            <input type="password" name="oldPassword" required>
                        </div>
                        <div class="form-group">
                            <label>New Password:</label>
                            <input type="password" name="newPassword" id="newPassword" required 
                                   pattern="^(?=.*[0-9]).{8,}$" 
                                   title="Password must be at least 8 characters long and contain at least one number">
                        </div>
                        <div class="form-group">
                            <label>Confirm New Password:</label>
                            <input type="password" name="confirmPassword" id="confirmPassword" required>
                        </div>
                    </div>
                    <div class="button-row">
                        <button type="submit" class="auth-button">Save Changes</button>
                        <a href="profile.jsp" class="auth-button" style="background: #ccc; color: #333;">Cancel</a>
                    </div>
                </form>
            <% } %>
        </main>
    </div>
    <footer>
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
    <script>
    function validatePasswordChange() {
        var newPassword = document.getElementById('newPassword').value;
        var confirmPassword = document.getElementById('confirmPassword').value;
        
        if (newPassword !== confirmPassword) {
            alert('New passwords do not match!');
            return false;
        }
        
        if (newPassword.length < 8 || !/\d/.test(newPassword)) {
            alert('Password must be at least 8 characters long and contain at least one number!');
            return false;
        }
        
        return true;
    }
    </script>
</body>
</html> 