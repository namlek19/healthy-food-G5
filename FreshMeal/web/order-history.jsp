<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Order, model.OrderItem, java.util.List, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lịch sử đơn hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-history.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header-user.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>
<body class="checkout-page">
   
    <header class="bg-white shadow-sm">
        <div class="container d-flex align-items-center justify-content-between py-3">
            <div class="logo">
                <a href="index.jsp"><img src="assets/images/logoreal.png" alt="logo"></a>
            </div>
            <nav>
                <ul class="nav">
                    <li class="nav-item"><a href="productlistcontrol?category=" class="nav-link text-dark">Product</a></li>
                    <li class="nav-item"><a href="MenuCus.jsp" class="nav-link text-dark">Menu</a></li>
                    <li class="nav-item"><a href="blogcus.jsp" class="nav-link text-dark">Blog</a></li>
                </ul>
            </nav>
            <div class="header-right d-flex align-items-center gap-3">
                <a href="cart.jsp" class="cart-btn">
                    <span class="cart-icon-wrap">
                        <img src="assets/images/shopping-cart.png" alt="Cart" class="cart-icon">
                    </span>
                    <span class="cart-text">Giỏ hàng</span>
                </a>
                <%
                    User user = (User) session.getAttribute("user");
                %>
                <% if (user != null) { %>
                <div class="user-menu">
                    <button class="user-menu-btn" type="button">
                        <img src="assets/images/user-icon.png" alt="User" class="avatar" style="width:32px;">
                        <span>
                            <%= user.getFirstName() != null && !user.getFirstName().isEmpty()
                                ? user.getFirstName()
                                : user.getFullName() %>
                        </span>
                        <span class="dropdown-arrow">&#9662;</span>
                    </button>
                    <div class="user-dropdown">
                        <a href="profile.jsp">Thông tin cá nhân</a>
                        <a href="order-history">Lịch sử đơn hàng</a>
                        <a href="login?action=logout">Đăng xuất</a>
                    </div>
                </div>
                <% } else { %>
                <div class="auth-buttons">
                    <a href="login.jsp" class="btn btn-outline-success btn-sm">Sign In</a>
                    <a href="login.jsp?action=signup" class="btn btn-outline-success btn-sm">Sign Up</a>
                </div>
                <% } %>
            </div>
        </div>
    </header>
    <script>
    document.addEventListener('DOMContentLoaded', function () {
        var userMenu = document.querySelector('.user-menu');
        if (userMenu) {
            var btn = userMenu.querySelector('.user-menu-btn');
            btn.addEventListener('click', function (e) {
                e.stopPropagation();
                userMenu.classList.toggle('open');
            });
            document.addEventListener('click', function () {
                userMenu.classList.remove('open');
            });
        }
    });
    </script>
    <!-- ===== HEADER END ===== -->

    <div class="checkout-wrapper">
        <h2 class="order-history-title">Lịch sử đơn hàng của bạn</h2>
        <%
            List<Order> orders = (List<Order>) request.getAttribute("orders");
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        %>
        <%
            if (orders == null || orders.isEmpty()) {
        %>
            <div class="order-empty">
                Bạn chưa có đơn hàng nào.
            </div>
        <%
            } else {
        %>
        <table class="order-table">
            <tr>
                <th>MÃ ĐƠN</th>
                <th>NGÀY ĐẶT</th>
                <th>TỔNG TIỀN</th>
                <th>PHƯƠNG THỨC</th>
                <th>TRẠNG THÁI</th>
                <th>SẢN PHẨM</th>
                <th>XEM</th>
            </tr>
            <% for (Order order : orders) { %>
            <tr>
                <td>#<%= order.getOrderID() %></td>
                <td><%= sdf.format(order.getOrderDate()) %></td>
                <td><%= String.format("%,.0f", order.getTotalAmount()) %> đ</td>
                
                    <%
                        String status = order.getStatus();
                        String method = (status.startsWith("QR")) ? "QR" : "COD";
                        String statusText = "Lỗi";
                        switch (status) {
                            case "Pending":
                            case "QRPending":
                                statusText = "Chưa xác nhận";
                                break;
                            case "Confirmed":
                            case "QRConfirmed":
                                statusText = "Đã xác nhận";
                                break;
                            case "Delivering":
                            case "QRDelivering":
                                statusText = "Đang giao hàng";
                                break;
                            case "Delivered":
                            case "QRDelivered":
                                statusText = "Đã giao hàng";
                                break;
                        }
                    %>
                <td><%= method %></td>
                <td><%= statusText %></td>
                <td>
                    <div class="product-list">
                        <% 
                            List<OrderItem> items = order.getItems();
                            int count = 0;
                            for (OrderItem item : items) { 
                                if (count++ == 3) break; // chỉ hiện 3 sản phẩm đầu
                        %>
                            <div class="product-thumb">
                                <img src="<%= item.getImageUrl() %>" alt="<%= item.getProductName() %>">
                                <span class="product-name"><%= item.getProductName() %></span>
                            </div>
                        <% } %>
                        <% if (items.size() > 3) { %>
                            <span class="product-more">
                                +<%= items.size() - 3 %> món nữa
                            </span>
                        <% } %>
                    </div>
                </td>
                <td>
                    <a href="order-info?orderId=<%= order.getOrderID() %>" class="order-link">Chi tiết</a>
                </td>
            </tr>
            <% } %>
        </table>
        <% } %>
        <div style="text-align:center; margin-top:30px;">
            <a href="index.jsp" class="btn btn-outline-success">Quay lại trang chủ</a>
        </div>
    </div>
</body>
</html>
