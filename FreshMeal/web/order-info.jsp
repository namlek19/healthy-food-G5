<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Order, model.OrderItem, java.util.List, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Chi tiết đơn hàng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-info.css">
        <style>
            .order-detail-title {
                color: #25bb55;
                text-align: center;
                margin-bottom: 20px;
            }
            .order-detail-box {
                background: #fff;
                border-radius: 8px;
                padding: 24px 28px;
                max-width: 800px;
                margin: 32px auto 0 auto;
                box-shadow: 0 4px 24px #eef5f0;
            }
            .order-info-row {
                margin-bottom: 9px;
            }
            .order-info-label {
                font-weight: bold;
                color: #16793a;
            }
            .order-status {
                font-weight: bold;
                color: #25bb55;
            }
            .order-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 18px;
                background: #f9fff7;
            }
            .order-table th, .order-table td {
                padding: 9px;
                border-bottom: 1px solid #e6f6e9;
                text-align: center;
            }
            .order-table th {
                background: #25bb55;
                color: #fff;
            }
            .product-thumb-info {
                width: 58px;
                border-radius: 6px;
                object-fit: cover;
            }
            .back-history {
                margin-top: 24px;
                display: block;
                text-align: left;
                color: #25bb55;
                font-weight: bold;
                text-decoration: none;
            }
            .back-history:hover {
                color: #16793a;
            }
        </style>
    </head>
    <body class="checkout-page">
        <div class="order-detail-box">
            <h2 class="order-detail-title">Chi tiết đơn hàng</h2>
            <%
                Order order = (Order) request.getAttribute("order");
                List<OrderItem> items = order.getItems();
                SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            %>
            <div class="order-info-row"><span class="order-info-label">Mã đơn:</span> #<%= order.getOrderID() %></div>
            <div class="order-info-row"><span class="order-info-label">Ngày đặt:</span> <%= sdf.format(order.getOrderDate()) %></div>
            <div class="order-info-row"><span class="order-info-label">Người nhận:</span> <%= order.getReceiverName() %></div>
            <div class="order-info-row"><span class="order-info-label">Địa chỉ:</span> <%= order.getDeliveryAddress() %>, <%= order.getDistrict() %></div>
            <div class="order-info-row"><span class="order-info-label">Trạng thái:</span>
                <span class="order-status"><%= order.getStatus() %></span>
            </div>
            <div class="order-info-row"><span class="order-info-label">Tổng tiền:</span> <span style="color:#16793a; font-weight: bold;"><%= String.format("%,.0f", order.getTotalAmount()) %> đ</span></div>

            <h4 style="margin:20px 0 10px 0; color:#25bb55;">Danh sách sản phẩm:</h4>
            <table class="order-table">
                <tr>
                    <th>Ảnh</th>
                    <th>Tên sản phẩm</th>
                    <th>Số lượng</th>
                    <th>Đơn giá</th>
                    <th>Thành tiền</th>
                </tr>
                <%
                double total = 0;
                for (OrderItem item : items) {
                    double subtotal = item.getQuantity() * item.getPrice();
                    total += subtotal;
                %>
                <tr>
                    <td>
                        <img src="<%= item.getImageUrl() %>" alt="<%= item.getProductName() %>" class="product-thumb-info"/>
                    </td>
                    <td><%= item.getProductName() %></td>
                    <td><%= item.getQuantity() %></td>
                    <td><%= String.format("%,.0f", item.getPrice()) %> đ</td>
                    <td><%= String.format("%,.0f", subtotal) %> đ</td>
                </tr>
                <% } %>
                <tr>
                    <td colspan="4" style="text-align:right; font-weight:bold;">Tổng cộng:</td>
                    <td style="color:#25bb55; font-weight:bold;"><%= String.format("%,.0f", total) %> đ</td>
                </tr>
            </table>

            <a href="order-history" class="back-history">&#8592; Quay về lịch sử đơn hàng</a>
        </div>
    </body>
</html>
