<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dal.MenuDAO, java.util.*, model.Menu, model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    MenuDAO dao = new MenuDAO();
    List<Menu> pendingMenus = dao.getMenusByStatus(1);

    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg = (String) session.getAttribute("errorMsg");
    if (successMsg != null) session.removeAttribute("successMsg");
    if (errorMsg != null) session.removeAttribute("errorMsg");
%>
<html>
<head>
    <title>Menu chờ duyệt | Quản lý</title>
    <link rel="stylesheet" href="assets/css/pendingmanager.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
    <!-- HEADER -->
    <header class="manager-header">
        <div class="container">
            <div class="logo">
                <img src="assets/images/logo.png" alt="logo">
                <span class="brand-name">freshmeal</span>
            </div>
            <div class="header-title">Menu chờ duyệt</div>
            <div class="header-right">
                <span class="username">Xin chào, <b><%= user.getFullName() %></b></span>
                <a href="login?action=logout" class="btn-logout">Đăng xuất</a>
            </div>
        </div>
    </header>

    <!-- NỘI DUNG CHÍNH -->
    <div class="container-main">
        <h2>Danh sách Menu chờ duyệt</h2>
        <% if (successMsg != null) { %>
            <div class="success-msg"><%= successMsg %></div>
        <% } %>
        <% if (errorMsg != null) { %>
            <div class="error-msg"><%= errorMsg %></div>
        <% } %>

        <table class="table-menus">
            <tr>
                <th>ID</th>
                <th>Tên Menu</th>
                <th>Hình ảnh</th>
                <th>Mô tả</th>
                <th>Nutritionist</th>
                <th>Duyệt Menu</th>
            </tr>
            <% for (Menu m : pendingMenus) { %>
            <tr>
                <td><%= m.getMenuID() %></td>
                <td><%= m.getMenuName() %></td>
                <td>
                    <img src="<%= m.getImageURL() %>" alt="menu" width="100">
                </td>
                <td><%= m.getDescription() %></td>
                <td><%= m.getNutritionistID() %></td>
                <td>
                    <!-- Nút DUYỆT -->
                    <form action="approveMenu" method="post" style="display:inline">
                        <input type="hidden" name="menuId" value="<%= m.getMenuID() %>">
                        <input type="hidden" name="action" value="approve">
                        <button type="submit"
                            onclick="return confirm('Bạn chắc chắn DUYỆT menu này?')"
                            style="background:#2ecc71;color:#fff;border:none;padding:7px 16px;border-radius:4px;font-weight:500;">
                            Duyệt
                        </button>
                    </form>
                    <!-- Nút TỪ CHỐI -->
                    <form action="approveMenu" method="post" style="display:inline">
                        <input type="hidden" name="menuId" value="<%= m.getMenuID() %>">
                        <input type="hidden" name="action" value="reject">
                        <button type="submit"
                            onclick="return confirm('Bạn muốn TỪ CHỐI menu này?')"
                            style="background:#e74c3c;color:#fff;border:none;padding:7px 16px;border-radius:4px;font-weight:500;margin-left:8px;">
                            Từ chối
                        </button>
                    </form>
                </td>
            </tr>
            <% } %>
        </table>
        <% if (pendingMenus == null || pendingMenus.isEmpty()) { %>
            <div style="margin-top:20px;color:#189654;font-weight:600;">Không có menu nào đang chờ duyệt.</div>
        <% } %>
    </div>
</body>
</html>
