<%@ page import="model.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Giỏ Hàng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
         <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header-user.css">
          <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
       
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <style>
            table {
                width: 80%;
                margin: auto;
                border-collapse: collapse;
            }
            th, td {
                padding: 10px;
                border: 1px solid #ddd;
                text-align: center;
            }
            h2 {
                text-align: center;
                margin-top: 20px;
            }
            .empty {
                text-align: center;
                color: gray;
                font-style: italic;
            }
            .back {
                text-align: center;
                margin-top: 20px;
            }
        </style>
    </head>
    <body>
         <!-- ===== HEADER BEGIN ===== -->
    <header class="bg-white shadow-sm">
        <div class="container d-flex align-items-center justify-content-between py-3">
            <div class="logo">
                <a href="index.jsp"><img src="assets/images/logo.png" alt="logo"></a>
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
        <h2>Giỏ hàng của bạn</h2>
        <%
            List<CartItem> cart = (List<CartItem>) session.getAttribute(
                session.getAttribute("user") != null ? "cart" : "guest_cart"
            );
            double total = 0;
            if (cart != null && !cart.isEmpty()) {
        %>
        <table>
            <tr>
                <th>Mã SP</th>
                <th>Tên</th>
                <th>Ảnh</th>
                <th>Giá</th>
                <th>Số lượng</th>
                <th>Thành tiền</th>
                <th>Xóa</th>
            </tr>
            <%
                for (CartItem item : cart) {
                    Product p = item.getProduct();
                    double subtotal = item.getTotalPrice();
                    total += subtotal;
            %>
            <tr>
                <td><%= p.getProductID() %></td>
                <td><%= p.getName() %></td>
                <td>
                    <%
                        String imgUrl = p.getImageURL();
                        boolean isOnline = imgUrl != null && imgUrl.startsWith("http");
                        String finalImgUrl = isOnline ? imgUrl : "assets/images/" + imgUrl.replace("/images/", "");
                    %>
                    <img src="<%= finalImgUrl %>" alt="<%= p.getName() %>" width="60"/>
                </td>
                <td><%= p.getPrice() %> đ</td>
                <td>
                    <form action="UpdateCartServlet" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= p.getProductID() %>" />
                        <input type="hidden" name="action" value="dec" />
                        <button type="submit">−</button>
                    </form>
                    <strong><%= item.getQuantity() %></strong>
                    <form action="UpdateCartServlet" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= p.getProductID() %>" />
                        <input type="hidden" name="action" value="inc" />
                        <button type="submit">+</button>
                    </form>
                </td>
                <td><%= subtotal %> đ</td>
                <td>
                    <form action="UpdateCartServlet" method="post">
                        <input type="hidden" name="id" value="<%= p.getProductID() %>" />
                        <input type="hidden" name="action" value="remove" />
                        <button type="submit" class="trash-button">
                            <img src="assets/images/delete.png" alt="Xóa" style="width:20px;">
                        </button>
                    </form>
                </td>
            </tr>
            <% } %>
            <tr>
                <td colspan="5" align="right"><strong>Tổng cộng:</strong></td>
                <td colspan="2"><strong><%= total %> đ</strong></td>
            </tr>
        </table>
        <div class="checkout-button" style="text-align:center; margin-top:20px;">
            <form action="checkout.jsp" method="get">
                <button type="submit" class="checkout-btn">Thanh toán</button>
            </form>
        </div>
        <%
            } else {
        %>
        <p class="empty">Giỏ hàng trống.</p>
        <% } %>

        <div class="back">
           <a href="productlistcontrol?category=">Quay lại mua sắm</a>
        </div>
    </body>
</html>
