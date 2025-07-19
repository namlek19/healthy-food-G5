<%@ page import="java.util.*, model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || admin.getRoleID() != 1) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<User> users = (List<User>) request.getAttribute("users");
    if (users == null) users = Collections.emptyList();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng - Admin</title>
    <link rel="stylesheet" href="assets/css/shipper.css">
</head>
<body>

<div class="navbar">
    <div class="navbar-left">
        <img src="assets/images/logotext.png" alt="Logo" style="height: 60px;">
    </div>
    <div class="navbar-right">
        <span>Xin chào, <strong><%= admin.getFullName() %> (Admin)</strong></span>
        <a href="login?action=logout" class="btn-logout">Đăng xuất</a>
    </div>
</div>

<div class="container">
    <h2>Danh sách người dùng</h2>

    <% if (request.getAttribute("message") != null) { %>
        <div class="success-message"><%= request.getAttribute("message") %></div>
    <% } else if (request.getAttribute("error") != null) { %>
        <div class="error-message"><%= request.getAttribute("error") %></div>
    <% } %>

    <table class="styled-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Họ tên</th>
                <th>Email</th>
                <th>Vai trò</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
        <% if (users.isEmpty()) { %>
            <tr>
                <td colspan="5" style="text-align:center;color:gray;">Không có người dùng nào.</td>
            </tr>
        <% } else {
            for (User u : users) { %>
            <tr>
                <td><%= u.getUserID() %></td>
                <td><%= u.getFullName() %></td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getRoleName() %></td> <!-- Lấy từ DB thông qua JOIN -->
                <td>
                    <form action="UpdateUserRoleServlet" method="post">
                        <input type="hidden" name="userId" value="<%= u.getUserID() %>"/>
                        <select name="role">
                            <option value="1" <%= (u.getRoleID() == 1) ? "selected" : "" %>>Admin</option>
                            <option value="2" <%= (u.getRoleID() == 2) ? "selected" : "" %>>Customer</option>
                            <option value="3" <%= (u.getRoleID() == 3) ? "selected" : "" %>>Manager</option>
                            <option value="4" <%= (u.getRoleID() == 4) ? "selected" : "" %>>Seller</option>
                            <option value="5" <%= (u.getRoleID() == 5) ? "selected" : "" %>>Nutritionist</option>
                            <option value="6" <%= (u.getRoleID() == 6) ? "selected" : "" %>>Shipper</option>
                        </select>
                        <button type="submit">Cập nhật</button>
                    </form>
                </td>
            </tr>
        <%  } } %>
        </tbody>
    </table>
</div>

</body>
</html>
