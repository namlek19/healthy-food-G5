<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.*, java.util.*, dal.CartDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng - Healthy Meal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/header-user.css">
    <link rel="stylesheet" href="assets/css/footer.css">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body>


<jsp:include page="includes/header.jsp" />

<div class="container mt-5 mb-5">
    <h2 class="text-success text-center mb-4">Giỏ hàng của bạn</h2>

    <%
        List<CartItem> cart = null;
        if (user != null) {
            CartDAO cartDAO = new CartDAO();
            cart = cartDAO.getCartItemsByUser(user.getUserID());
        } else {
            cart = (List<CartItem>) session.getAttribute("guest_cart");
        }
        double total = 0;
        if (cart != null && !cart.isEmpty()) {
    %>

    <div class="table-responsive">
        <table class="table table-bordered text-center align-middle">
            <thead class="table-success">
                <tr>
                    <th>Mã SP</th>
                    <th>Tên</th>
                    <th>Ảnh</th>
                    <th>Giá</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                    <th>Xóa</th>
                </tr>
            </thead>
            <tbody>
            <%
                for (CartItem item : cart) {
                    Product p = item.getProduct();
                    double subtotal = item.getTotalPrice();
                    total += subtotal;

                    String imgUrl = p.getImageURL();
                    boolean isOnline = imgUrl != null && imgUrl.startsWith("http");
                    String finalImgUrl = isOnline ? imgUrl : "assets/images/" + imgUrl.replace("/images/", "");
            %>
                <tr>
                    <td><%= p.getProductID() %></td>
                    <td><%= p.getName() %></td>
                    <td><img src="<%= finalImgUrl %>" alt="<%= p.getName() %>" width="60" class="img-thumbnail" /></td>
                    <td><fmt:formatNumber value="<%= p.getPrice() %>" type="number" maxFractionDigits="0"/> đ</td>
                    <td>
                        <form action="UpdateCartServlet" method="post" class="d-inline">
                            <input type="hidden" name="id" value="<%= p.getProductID() %>" />
                            <input type="hidden" name="action" value="dec" />
                            <button type="submit" class="btn btn-sm btn-outline-secondary">−</button>
                        </form>
                        <strong><%= item.getQuantity() %></strong>
                        <form action="UpdateCartServlet" method="post" class="d-inline">
                            <input type="hidden" name="id" value="<%= p.getProductID() %>" />
                            <input type="hidden" name="action" value="inc" />
                            <button type="submit" class="btn btn-sm btn-outline-secondary">+</button>
                        </form>
                    </td>
                    <td><fmt:formatNumber value="<%= subtotal %>" type="number" maxFractionDigits="0"/> đ</td>
                    <td>
                        <form action="UpdateCartServlet" method="post">
                            <input type="hidden" name="id" value="<%= p.getProductID() %>" />
                            <input type="hidden" name="action" value="remove" />
                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                <i class="bi bi-trash"></i>
                            </button>
                        </form>
                    </td>
                </tr>
            <% } %>
                <tr class="table-success">
                    <td colspan="5" class="text-end fw-bold">Tổng cộng:</td>
                    <td colspan="2" class="fw-bold text-danger">
                        <fmt:formatNumber value="<%= total %>" type="number" maxFractionDigits="0"/> đ
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="text-center mt-4">
        <form action="checkout.jsp" method="get">
            <button type="submit" class="btn btn-success btn-lg">Thanh toán</button>
        </form>
    </div>

    <% } else { %>
        <div class="alert alert-warning text-center">Giỏ hàng trống.</div>
    <% } %>

    <div class="text-center mt-4">
        <a href="productlistcontrol?category=" class="btn btn-outline-success">
            <i class="bi bi-arrow-left"></i> Quay lại mua sắm
        </a>
    </div>
</div>


<jsp:include page="includes/footer.jsp" />

</body>
</html>
