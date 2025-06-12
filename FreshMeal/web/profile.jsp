<%@ page import="model.User,dal.UserDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User user = (User) session.getAttribute("user");
    String edit = request.getParameter("edit");
    String message = null;
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String fullName = request.getParameter("fullName");
        String city = request.getParameter("city");
        String district = request.getParameter("district");
        String address = request.getParameter("address");
        float heightCm = Float.parseFloat(request.getParameter("heightCm"));
        float weightKg = Float.parseFloat(request.getParameter("weightKg"));
        user.setFullName(fullName);
        user.setCity(city);
        user.setDistrict(district);
        user.setAddress(address);
        user.setHeightCm(heightCm);
        user.setWeightKg(weightKg);
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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - <%= user.getFullName() %></title>
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/loginstyle.css">
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
    <div class="container">
        <div class="auth-container" style="max-width: 500px; margin: 40px auto;">
            <div style="text-align: center; margin-bottom: 24px;">
                <img src="assets/images/default-avatar.png" alt="User Avatar" style="width: 100px; height: 100px; border-radius: 50%; object-fit: cover; margin-bottom: 12px;">
                <h2 style="color: #27ae60; margin-bottom: 4px;"><%= user.getFullName() %></h2>
                <p style="color: #888; margin-bottom: 0;">Customer</p>
            </div>
            <% if (message != null) { %>
                <div class="alert alert-success" style="margin-bottom: 16px;"><%= message %></div>
            <% } %>
            <% if (edit == null) { %>
                <div class="form-group"><label>First Name:</label> <span><%= firstName %></span></div>
                <div class="form-group"><label>Last Name:</label> <span><%= lastName %></span></div>
                <div class="form-group"><label>Email:</label> <span><%= user.getEmail() %></span></div>
                <div class="form-group"><label>City:</label> <span><%= user.getCity() %></span></div>
                <div class="form-group"><label>District:</label> <span><%= user.getDistrict() %></span></div>
                <div class="form-group"><label>Address:</label> <span><%= user.getAddress() %></span></div>
                <div class="form-group"><label>Height (cm):</label> <span><%= user.getHeightCm() %></span></div>
                <div class="form-group"><label>Weight (kg):</label> <span><%= user.getWeightKg() %></span></div>
                <div class="form-group"><label>BMI:</label> <span><%= user.getBmi() %> (<%= user.getBmiCategory() %>)</span></div>
                <form method="get" style="text-align: center; margin-top: 24px;">
                    <input type="hidden" name="edit" value="true">
                    <button type="submit" class="auth-button">Edit Account</button>
                </form>
            <% } else { %>
                <form method="post" style="margin-top: 16px;">
                    <div class="form-group">
                        <label>Full Name:</label>
                        <input type="text" name="fullName" value="<%= user.getFullName() %>" required>
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
                    <div class="form-group">
                        <label>Height (cm):</label>
                        <input type="number" step="0.1" name="heightCm" value="<%= user.getHeightCm() %>" required>
                    </div>
                    <div class="form-group">
                        <label>Weight (kg):</label>
                        <input type="number" step="0.1" name="weightKg" value="<%= user.getWeightKg() %>" required>
                    </div>
                    <div style="text-align: center; margin-top: 24px;">
                        <button type="submit" class="auth-button">Save</button>
                        <a href="profile.jsp" class="auth-button" style="background: #ccc; color: #333; margin-left: 8px;">Cancel</a>
                    </div>
                </form>
            <% } %>
        </div>
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
</body>
</html> 