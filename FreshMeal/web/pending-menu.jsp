<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dal.MenuDAO, java.util.*, model.Menu, model.Product, model.User" %>
<%
    /* ====== Kiểm tra đăng nhập ====== */
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    /* ====== Lấy danh sách menu chờ duyệt ====== */
    MenuDAO dao = new MenuDAO();
    List<Menu> pendingMenus = dao.getMenusByStatus(1);     // 1 = Chờ duyệt

    /* ====== Thông báo thành công / lỗi ====== */
    String successMsg = (String) session.getAttribute("successMsg");
    String errorMsg   = (String) session.getAttribute("errorMsg");
    if (successMsg != null) session.removeAttribute("successMsg");
    if (errorMsg   != null) session.removeAttribute("errorMsg");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Menu chờ duyệt | Quản lý</title>
    <!-- CSS riêng của trang -->
    <link rel="stylesheet" href="assets/css/pendingmanager.css?v=2">
    <!-- Responsive -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>


<header class="manager-header">
    <div class="container">
        <!-- Logo + brand -->
        <div class="logo">
            <img src="assets/images/logotext.png" alt="logo" />
           
        </div>


        <div class="header-title">Menu chờ duyệt</div>


        <div class="header-right">
            <span class="username">
                Xin chào, <b><%= user.getFullName() %></b>
            </span>
            <a href="login?action=logout" class="btn-logout">Đăng xuất</a>
        </div>
    </div>
</header>

<!-- ========================= NỘI DUNG CHÍNH ========================= -->
<div class="container-main">
    <h2>Danh sách Menu chờ duyệt</h2>

    <!-- Thông báo -->
    <% if (successMsg != null) { %>
        <div class="success-msg"><%= successMsg %></div>
    <% } %>
    <% if (errorMsg != null) { %>
        <div class="error-msg"><%= errorMsg %></div>
    <% } %>

    <!-- BẢNG MENU -->
    <table class="table-menus">
        <tr>
            <th>ID</th>
            <th>Tên Menu</th>
            <th>Sản phẩm (Ảnh / Tên / Giá)</th>
            <th>Mô tả</th>
            <th>Nutritionist</th>
            <th>Tổng giá</th>
            <th>Duyệt</th>
        </tr>

        <% for (Menu m : pendingMenus) { %>
        <tr>
            <!-- ID & tên -->
            <td><%= m.getMenuID() %></td>
            <td><%= m.getMenuName() %></td>

            <!-- Danh sách sản phẩm -->
            <td class="product-list">
                <% for (Product p : m.getProducts()) { %>
                    <div class="prod-item">
                        <img src="<%= p.getImageURL() %>" alt="<%= p.getName() %>" />
                        <div class="prod-info">
                            <span class="prod-name"><%= p.getName() %></span>
                            <span class="prod-price">
                                <%= String.format("%,.0f ₫", p.getPrice()) %>
                            </span>
                        </div>
                    </div>
                <% } %>
            </td>

          
            <td><%= m.getDescription() %></td>
            <td><%= m.getNutritionistID() %></td>

        
            <td class="tot-price">
                <%= String.format("%,.0f ₫", m.getTotalPrice()) %>
            </td>

           
            <td>
                
                <form action="approveMenu" method="post" style="display:inline">
                    <input type="hidden" name="menuId" value="<%= m.getMenuID() %>" />
                    <input type="hidden" name="action" value="approve" />
                    <button type="submit" class="btn-approve"
                            onclick="return confirm('Bạn chắc chắn DUYỆT menu này?')">
                        Duyệt
                    </button>
                </form>

          
                <form action="approveMenu" method="post" style="display:inline">
                    <input type="hidden" name="menuId" value="<%= m.getMenuID() %>" />
                    <input type="hidden" name="action" value="reject" />
                    <button type="submit" class="btn-reject"
                            onclick="return confirm('Bạn muốn TỪ CHỐI menu này?')">
                        Từ chối
                    </button>
                </form>
            </td>
        </tr>
        <% } %>
    </table>


    <% if (pendingMenus == null || pendingMenus.isEmpty()) { %>
        <div style="margin-top:20px;color:#189654;font-weight:600;">
            Không có menu nào đang chờ duyệt.
        </div>
    <% } %>
</div>

</body>
</html>
