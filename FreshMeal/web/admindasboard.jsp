<%-- 
    Document   : admindasboard
    Created on : Jun 30, 2025, 8:34:29 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Admin Dashboard - User Management</title>
    <link rel="stylesheet" href="assets/css/admin-dashboard.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="admin-sidebar">
        <div class="admin-avatar">
            <img src="assets/images/user-icon.png" alt="Admin" style="width:60px;height:60px;border-radius:50%;">
        </div>
        <h2>Admin</h2>
        <div class="admin-welcome">Chào mừng bạn trở lại</div>
        <ul class="admin-nav">
            <li><a href="#" class="active">Danh sách người dùng</a></li>
            <li><a href="adduser.jsp">Thêm người dùng mới</a></li>
            <li><a href="index.jsp">Xem cửa hàng</a></li>
            <li><form action="login" method="get" style="display:inline;"><button type="submit" name="action" value="logout" style="background:none;border:none;color:#fff;cursor:pointer;padding:0;">Đăng xuất</button></form></li>
        </ul>
    </div>
    <div class="admin-main">
        <div class="admin-card">
            <div class="admin-card-header">
                <h1>Danh Sách Người Dùng</h1>
                <div class="admin-search">
                    <form action="<%= request.getContextPath() %>/admin-dashboard" method="get" style="display:flex;align-items:center;gap:8px;">
                        <input type="text" name="search" placeholder="Tìm kiếm..." value="${param.search}" />
                        <button type="submit">Tìm kiếm</button>
                    </form>
                </div>
            </div>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID khách hàng</th>
                        <th>Tên khách hàng</th>
                        <th>Email</th>
                        <th>Địa chỉ</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th>Tính năng</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${userList}">
                        <tr>
                            <td>${user.userID}</td>
                            <td>${user.fullName}</td>
                            <td>${user.email}</td>
                            <td>${user.address}</td>
                            <td>
                                <form method="post" action="login" class="inline">
                                    <input type="hidden" name="action" value="editUser" />
                                    <input type="hidden" name="userID" value="${user.userID}" />
                                    <select name="roleID" data-old-value="${user.roleID}" onchange="confirmRoleChange(this, ${user.userID});">
                                        <option value="1" ${user.roleID == 1 ? 'selected' : ''}>Admin</option>
                                        <option value="2" ${user.roleID == 2 ? 'selected' : ''}>Customer</option>
                                        <option value="3" ${user.roleID == 3 ? 'selected' : ''}>Manager</option>
                                        <option value="4" ${user.roleID == 4 ? 'selected' : ''}>Seller</option>
                                        <option value="5" ${user.roleID == 5 ? 'selected' : ''}>Nutritionist</option>
                                        <option value="6" ${user.roleID == 6 ? 'selected' : ''}>Shipper</option>
                                    </select>
                                </form>
                            </td>
                            <td>
                                <form method="post" action="login" class="inline">
                                    <input type="hidden" name="action" value="editUser" />
                                    <input type="hidden" name="userID" value="${user.userID}" />
                                    <input type="hidden" name="roleID" value="${user.roleID}" />
                                    <select name="isActive" onchange="confirmActiveChange(this, ${user.userID});">
                                        <option value="1" ${user.active == 1 ? 'selected' : ''}>Active</option>
                                        <option value="0" ${user.active == 0 ? 'selected' : ''}>Inactive</option>
                                    </select>
                                </form>
                            </td>
                            <td>
                                <form method="post" action="login" class="inline" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this user?');">
                                    <input type="hidden" name="action" value="deleteUser" />
                                    <input type="hidden" name="userID" value="${user.userID}" />
                                    <button type="submit" class="admin-action-btn delete" title="Delete"><span>&#128465;</span></button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <!-- Pagination placeholder -->
            <div class="admin-pagination">
                <button disabled>Lùi</button>
                <span class="active">1</span>
                <button disabled>Tiếp</button>
            </div>
        </div>
    </div>
    <script>
    function confirmRoleChange(select, userID) {
        var oldValue = select.getAttribute('data-old-value');
        var newValue = select.value;
        if (oldValue === newValue) return;
        var form = select.closest('form');
        if (confirm('Bạn có chắc muốn thay đổi vai trò người dùng này?')) {
            form.submit();
        } else {
            select.value = oldValue;
        }
    }
    function confirmActiveChange(select, userID) {
        var oldValue = select.getAttribute('data-old-value') || (select.options[0].selected ? '1' : '0');
        var newValue = select.value;
        if (oldValue === newValue) return;
        var form = select.closest('form');
        if (confirm('Bạn có chắc muốn thay đổi trạng thái tài khoản này?')) {
            form.submit();
        } else {
            select.value = oldValue;
        }
    }
    window.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('select[name="roleID"]').forEach(function(select) {
            select.setAttribute('data-old-value', select.value);
            select.addEventListener('change', function() {
                confirmRoleChange(this, this.form.userID.value);
            });
        });
        document.querySelectorAll('select[name="isActive"]').forEach(function(select) {
            select.setAttribute('data-old-value', select.value);
            select.addEventListener('change', function() {
                confirmActiveChange(this, this.form.userID.value);
            });
        });
    });
    </script>
</body>
</html>
