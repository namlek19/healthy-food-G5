<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User, model.Order, model.OrderItem, java.util.List, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lịch sử đơn hàng</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/footer.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-history.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header-user.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>
<body class="checkout-page">

  
    <jsp:include page="includes/header.jsp" />

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
                                if (count++ == 3) break;
                        %>
                            <div class="product-thumb">
                                <img src="<%= item.getImageUrl() %>" alt="<%= item.getProductName() %>">
                                <span class="product-name"><%= item.getProductName() %></span>
                            </div>
                        <% } %>
                        <% if (items.size() > 3) { %>
                            <span class="product-more">+<%= items.size() - 3 %> món nữa</span>
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

    
    <jsp:include page="includes/footer.jsp" /> 

</body>
</html>
