<%@ page import="model.*, java.util.*, dal.CartDAO" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
   
    User user = (User) session.getAttribute("user");
%>
<html>
    <head>
        <title>Giỏ Hàng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header-user.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" href="assets/css/footer.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
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
    
    <jsp:include page="includes/header.jsp" />
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
        List<CartItem> cart = null;
        if (user != null) {
            // Lấy lại giỏ hàng từ database mỗi lần vào trang
            CartDAO cartDAO = new CartDAO();
            cart = cartDAO.getCartItemsByUser(user.getUserID());
        } else {
            cart = (List<CartItem>) session.getAttribute("guest_cart");
        }
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
    <jsp:include page="includes/footer.jsp" />
    </body>
</html>
