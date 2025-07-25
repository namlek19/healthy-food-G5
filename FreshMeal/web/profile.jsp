<%@ page import="model.User, model.StaffProfile, dal.UserDAO, dal.StaffProfileDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("user");
    String edit = request.getParameter("edit");
    String message = null;
    String passwordMessage = (String) session.getAttribute("passwordMessage");
    Boolean passwordSuccess = (Boolean) session.getAttribute("passwordSuccess");
    session.removeAttribute("passwordMessage");
    session.removeAttribute("passwordSuccess");

    int roleID = (user != null) ? user.getRoleID() : -1;
    boolean isSeller = (roleID == 4);
    boolean isNutritionist = (roleID == 5);
    boolean isCustomer = (roleID == 2);
    boolean isGuest = (roleID == -1);

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Lấy StaffProfile nếu user là Seller hoặc Nutritionist
    StaffProfile staffProfile = null;
    if (isSeller || isNutritionist) {
        StaffProfileDAO staffDAO = new StaffProfileDAO();
        staffProfile = staffDAO.getStaffProfileByUserId(user.getUserID());
    }

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String fullName = request.getParameter("fullName");
        String city = request.getParameter("city");
        String district = request.getParameter("district");
        String address = request.getParameter("address");
        
        user.setFullName(fullName);
        user.setCity(city);
        user.setDistrict(district);
        user.setAddress(address);

        UserDAO userDAO = new UserDAO();
        boolean userUpdated = userDAO.updateUser(user); // Cập nhật thông tin chung của User

        boolean staffProfileUpdated = true; // Giả định thành công nếu không phải staff
        if (isSeller || isNutritionist) {
            String avatarURL = request.getParameter("avatarURL"); 
            String description = request.getParameter("description");

            StaffProfileDAO staffDAO = new StaffProfileDAO();
            if (staffProfile == null) { // Nếu chưa có StaffProfile, tạo mới
                staffProfile = new StaffProfile(0, user.getUserID(), avatarURL, description);
                staffProfileUpdated = staffDAO.insertStaffProfile(staffProfile);
            } else { // Nếu đã có, cập nhật
                staffProfile.setAvatarURL(avatarURL); 
                staffProfile.setDescription(description);
                staffProfileUpdated = staffDAO.updateStaffProfile(staffProfile);
            }
        }

        if (userUpdated && staffProfileUpdated) {
            message = "Profile updated successfully.";
            session.setAttribute("user", user); // Cập nhật lại user trong session (cho thông tin chung)
            // Lưu ý: StaffProfile sẽ được load lại khi trang refresh hoặc chuyển hướng
        } else {
            message = "Failed to update profile.";
        }
    }
    
    String firstName = user.getFirstName() != null ? user.getFirstName() : "";
    String lastName = user.getLastName() != null ? user.getLastName() : "";
    
    // Quyết định URL ảnh đại diện để hiển thị
    String userAvatarURL = "assets/images/default-avatar.png"; // Mặc định là ảnh này
    if (isSeller || isNutritionist) {
        if (staffProfile != null && staffProfile.getAvatarURL() != null && !staffProfile.getAvatarURL().isEmpty()) {
            userAvatarURL = staffProfile.getAvatarURL();
        }
    } else if (isCustomer) {
        // Nếu là Customer, luôn dùng ảnh mặc định và không cố gắng lấy từ StaffProfile
        // Nếu bạn có cột avatar trong bảng User cho Customer, bạn có thể uncomment dòng dưới:
        // if (user.getAvatarURL() != null && !user.getAvatarURL().isEmpty()) {
        //     userAvatarURL = user.getAvatarURL();
        // }
        // Hiện tại, nó sẽ luôn là default-avatar.png cho Customer
        userAvatarURL = "assets/images/default-avatar.png"; 
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - <%= user.getFullName() %></title>

    <link rel="stylesheet" href="assets/css/style.css">
    <% if (isCustomer) { %>
    <link rel="stylesheet" href="assets/css/footer.css">
    <link rel="stylesheet" href="assets/css/header-user.css">
    <% } %>
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

    <style>
        :root {
            --primary-color: #27ae60;
            --secondary-color: #f39c12;
            --text-color: #333;
            --light-gray: #f8f8f8;
            --border-color: #eee;
            --red-color: #e74c3c;
        }

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--light-gray);
            color: var(--text-color);
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* --- Profile Page Specific Styles --- */
        .profile-container {
            background-color: #fff;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            max-width: 600px;
            /* Điều chỉnh margin-top để tạo khoảng cách với header (chỉ khi header hiển thị) */
            margin: <%= isCustomer ? "40px auto" : "80px auto" %>;
            text-align: center;
        }

        .profile-header {
            margin-bottom: 30px;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 15px;
            border: 3px solid var(--primary-color);
            /* Thêm border cho ảnh profile */
            box-shadow: 0 4px 8px rgba(0,0,0,0.1); /* Hiệu ứng đổ bóng nhẹ */
        }
        
        .profile-name {
            color: var(--primary-color);
            margin-bottom: 5px;
            font-size: 1.8em;
            font-weight: 600;
        }

        .profile-role {
            color: #888;
            font-size: 0.95em;
            text-transform: capitalize; /* Viết hoa chữ cái đầu */
        }

        .alert {
            padding: 12px 20px;
            margin-bottom: 20px;
            border-radius: 8px;
            text-align: left;
            font-weight: 500;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--text-color);
        }

        .form-group span {
            display: block;
            padding: 10px 15px;
            background-color: var(--light-gray);
            border-radius: 8px;
            border: 1px solid var(--border-color);
            color: #555;
        }

        .form-group input[type="text"],
        .form-group input[type="email"], 
        .form-group input[type="url"], 
        .form-group input[type="password"],
        .form-group textarea { 
            width: calc(100% - 30px); 
            padding: 12px 15px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1em;
            box-sizing: border-box; 
        }

        .form-group input[type="text"]:focus,
        .form-group input[type="email"]:focus,
        .form-group input[type="url"]:focus, 
        .form-group input[type="password"]:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(39, 174, 96, 0.2);
        }

        .auth-button {
            display: inline-block;
            padding: 12px 25px;
            background-color: var(--primary-color);
            color: #fff;
            text-decoration: none;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1em;
            font-weight: 600;
            transition: background-color 0.3s ease, transform 0.2s ease;
            margin: 0 5px; 
        }

        .auth-button:hover {
            background-color: #229a54;
            transform: translateY(-2px);
        }

        .auth-button.cancel-button {
            background-color: #ccc;
            color: #333;
        }

        .auth-button.cancel-button:hover {
            background-color: #bbb;
        }

        h3 {
            color: var(--text-color);
            margin-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 10px;
            font-size: 1.4em;
            text-align: left;
        }
    </style>
</head>
<body>
    <%-- Chỉ hiển thị Header nếu là Customer hoặc Guest --%>
    <% if (isSeller) { %>
        <jsp:include page="includes/sidebarSeller.jsp" />
    <% } else if (isNutritionist) { %>
        <%@ include file="sidebar.jsp" %>
    <% } else if (isCustomer || isGuest) { %>
        <jsp:include page="includes/header.jsp" />
    <% } %>

    <div class="container">
        <div class="profile-container">
            <div class="profile-header">
                <%-- Hiển thị ảnh profile CHỈ KHI KHÔNG PHẢI LÀ CUSTOMER --%>
                <% if (!isCustomer) { %>
                    <img src="<%= userAvatarURL %>" alt="User Avatar" class="profile-avatar">
                <% } %>
                
                <h2 class="profile-name"><%= user.getFullName() %></h2>
                <p class="profile-role">
                    <%
                        if (isCustomer) out.print("Customer");
                        else if (isSeller) out.print("Seller");
                        else if (isNutritionist) out.print("Nutritionist");
                        else out.print("Guest");
                    %>
                </p>
            </div>

            <% if (message != null) { %>
                <div class="alert alert-success"><%= message %></div>
            <% } %>
            <% if (passwordMessage != null) { %>
                <div class="alert <%= passwordSuccess ? "alert-success" : "alert-danger" %>">
                    <%= passwordMessage %>
                </div>
            <% } %>

            <% if (edit == null) { %>
                <%-- Thông tin hiển thị cho tất cả các role --%>
                <div class="form-group"><label>Email:</label> <span><%= user.getEmail() %></span></div>
                <div class="form-group"><label>Full Name:</label> <span><%= user.getFullName() %></span></div>

                <%-- Thông tin bổ sung cho Customer --%>
                <% if (isCustomer) { %>
                <div class="form-group"><label>City:</label> <span><%= user.getCity() %></span></div>
                <div class="form-group"><label>District:</label> <span><%= user.getDistrict() %></span></div>
                <div class="form-group"><label>Address:</label> <span><%= user.getAddress() %></span></div>
                <% } %>

                <%-- Thông tin bổ sung cho Seller/Nutritionist --%>
                <% if (isSeller || isNutritionist) { %>
                <div class="form-group"><label>Mô tả / Chứng chỉ:</label> <span><%= (staffProfile != null && staffProfile.getDescription() != null && !staffProfile.getDescription().isEmpty()) ? staffProfile.getDescription() : "Chưa có mô tả" %></span></div>
                <% } %>
                
                <form method="get" style="margin-top: 30px;">
                    <input type="hidden" name="edit" value="true">
                    <button type="submit" class="auth-button">Edit Account</button>
                </form>
            <% } else { %>
                <form method="post" action="profile" onsubmit="return validatePasswordChange();">
                    <%-- Các trường có thể chỉnh sửa chung --%>
                    <div class="form-group">
                        <label>Full Name:</label>
                        <input type="text" name="fullName" value="<%= user.getFullName() %>" required>
                    </div>

                    <%-- Thông tin chỉnh sửa cho Customer --%>
                    <% if (isCustomer) { %>
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
                    <% } %>

                    <%-- Thông tin chỉnh sửa cho Seller/Nutritionist --%>
                    <% if (isSeller || isNutritionist) { %>
                    <%-- Thêm lại trường nhập avatarURL ở đây, vì ảnh trên cùng vẫn hiển thị cho Seller/Nutritionist --%>
                    <div class="form-group">
                        <label>Ảnh đại diện (URL):</label>
                        <input type="url" name="avatarURL" value="<%= (staffProfile != null && staffProfile.getAvatarURL() != null) ? staffProfile.getAvatarURL() : "" %>" placeholder="Dán đường dẫn ảnh vào đây">
                        <p style="font-size: 0.85em; color: #777; margin-top: 5px;">
                            (Đường dẫn trực tiếp đến ảnh đại diện của bạn)
                        </p>
                    </div>
                    <div class="form-group">
                        <label>Mô tả / Chứng chỉ:</label>
                        <textarea name="description" rows="4" placeholder="Nhập mô tả hoặc thông tin chứng chỉ của bạn" style="width: calc(100% - 30px); padding: 12px 15px; border: 1px solid var(--border-color); border-radius: 8px; font-size: 1em; box-sizing: border-box;"><%= (staffProfile != null && staffProfile.getDescription() != null) ? staffProfile.getDescription() : "" %></textarea>
                    </div>
                    <% } %>
                    
                    <div style="margin-top: 40px; padding-top: 30px; border-top: 1px solid var(--border-color);">
                        <h3>Change Password</h3>
                        <div class="form-group">
                            <label>Current Password:</label>
                            <input type="password" name="oldPassword" required>
                        </div>
                        <div class="form-group">
                            <label>New Password:</label>
                            <input type="password" name="newPassword" id="newPassword" required
                                   pattern="^(?=.*[0-9]).{8,}$"
                                   title="Mật khẩu phải dài ít nhất 8 ký tự và chứa ít nhất một chữ số">
                        </div>
                        <div class="form-group">
                            <label>Confirm New Password:</label>
                            <input type="password" name="confirmPassword" id="confirmPassword" required>
                        </div>
                    </div>

                    <div style="margin-top: 30px;">
                        <button type="submit" class="auth-button">Save Changes</button>
                        <a href="profile.jsp" class="auth-button cancel-button">Cancel</a>
                    </div>
                </form>
            <% } %>
        </div>
    </div>

    <%-- Chỉ hiển thị Footer nếu là Customer hoặc Guest --%>
    <% if (isCustomer || isGuest) { %>
    <jsp:include page="includes/footer.jsp" />
    <% } %>

    <script>
        function validatePasswordChange() {
            var newPassword = document.getElementById('newPassword').value;
            var confirmPassword = document.getElementById('confirmPassword').value;

            // Only validate if newPassword fields are not empty (assuming user wants to change password)
            if (newPassword || confirmPassword) {
                if (newPassword !== confirmPassword) {
                    alert('Mật khẩu mới và xác nhận mật khẩu không khớp!');
                    return false;
                }

                // Check pattern only if newPassword is not empty. The pattern attribute handles this mostly, but good to have a JS fallback.
                var passwordPattern = /^(?=.*[0-9]).{8,}$/;
                if (!passwordPattern.test(newPassword)) {
                    alert('Mật khẩu phải dài ít nhất 8 ký tự và chứa ít nhất một chữ số!');
                    return false;
                }
            }
            return true;
        }
    </script>
</body>
</html>