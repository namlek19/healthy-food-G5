<%@ page import="model.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Giỏ Hàng</title>
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
        <header>
            <div class="container">
                <div class="logo">
                    <img src="assets/images/logo.png" alt="logo">
                </div>
                <nav>
                    <ul>
                        <li><a href="#">Home</a></li>
                        <li><a href="#">Order</a></li>
                        <li><a href="#">Menu</a></li>
                        <li><a href="#">Blog</a></li>
                        <li><a href="#">About Us</a></li>
                    </ul>
                </nav>
                <a href="cart.jsp" class="cart" title="Giỏ hàng">
                    <img src="assets/images/shopping-cart.png" alt="Cart" />
                </a>

                <div class="auth-buttons">
                    <a href="#" class="auth-button">Sign In</a>
                    <a href="#" class="auth-button">Sign Up</a>
                </div>

            </div>
        </header>
        <h2>Giỏ hàng của bạn</h2>
        <%
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
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
                <td><img src="assets/images/<%= p.getImageURL() %>" width="60"/></td>
                <td><%= p.getPrice() %> đ</td>
                <td><%= item.getQuantity() %></td>
                <td><%= subtotal %> đ</td>
            </tr>
            <%
                    }
            %>
            <tr>
                <td colspan="5" align="right"><strong>Tổng cộng:</strong></td>
                <td><strong><%= total %> đ</strong></td>
            </tr>
        </table>
        <%
            } else {
        %>
        <p class="empty">Giỏ hàng trống.</p>
        <%
            }
        %>
        <div class="back">
            <a href="index.jsp">Quay lại mua sắm</a>
        </div>
    </body>
</html>
