<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Order, model.OrderItem, java.util.List, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
    
<head>
    
    <title>Lịch sử đơn hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-history.css">
</head>
<body class="checkout-page">
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
                <th>TRẠNG THÁI</th>
                <th>SẢN PHẨM</th>
                <th>XEM</th>
            </tr>
            <% for (Order order : orders) { %>
            <tr>
                <td>#<%= order.getOrderID() %></td>
                <td><%= sdf.format(order.getOrderDate()) %></td>
                <td><%= String.format("%,.0f", order.getTotalAmount()) %> đ</td>
                <td><%= order.getStatus() %></td>
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
    </div>
</body>
</html>
