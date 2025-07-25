<%@ page import="java.util.*, model.Order, model.OrderItem, model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User shipper = (User) session.getAttribute("user");
    if (shipper == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Order> orders = (List<Order>) request.getAttribute("orders");
    if (orders == null) orders = Collections.emptyList();

    List<Order> QRorders = (List<Order>) request.getAttribute("QRorders");
    if (QRorders == null) QRorders = Collections.emptyList();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý đơn hàng - Shipper</title>
        <link rel="stylesheet" href="assets/css/shipper.css">
    </head>
    <body>

        <div class="navbar">
            <div class="navbar-left">
                <img src="assets/images/logotext.png" alt="Logo" style="height: 60px;">
            </div>
            <div class="navbar-right">
                <span>Xin chào, <strong><%= shipper.getFullName() %></strong></span>
                <a href="login?action=logout" class="btn-logout">Đăng xuất</a>
            </div>
        </div>

        <div class="container">
            <h2>Đơn hàng COD cần giao</h2>

            <% if (request.getAttribute("message") != null) { %>
            <div class="success-message"><%= request.getAttribute("message") %></div>
            <% } else if (request.getAttribute("error") != null) { %>
            <div class="error-message"><%= request.getAttribute("error") %></div>
            <% } %>

            <!-- ======= COD Orders Table ======= -->
            <table class="styled-table">
                <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Khách hàng</th>
                        <th>Địa chỉ</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Chi tiết món</th>
                        <th>Trạng thái</th>
                        <th>Cập nhật</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (orders.isEmpty()) { %>
                    <tr><td colspan="8" style="text-align:center;color:gray;">Không có đơn hàng nào để hiển thị.</td></tr>
                    <% } else {
                        for (Order o : orders) {
                    %>
                    <tr>
                        <td><%= o.getOrderID() %></td>
                        <td><%= o.getReceiverName() %></td>
                        <td><%= o.getDeliveryAddress() %>, <%= o.getDistrict() %></td>
                        <td><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(o.getOrderDate()) %></td>
                        <td><%= String.format("%,.0f", o.getTotalAmount()) %> đ</td>
                        <td>
                            <% for (OrderItem item : o.getItems()) { %>
                            <div><%= item.getProductName() %>, số lượng: <%= item.getQuantity() %></div>
                            <% } %>

                        </td>
                        <td>
                            <form action="UpdateOrderStatusServlet" method="post">
                                <select name="status" <%= "Delivered".equals(o.getStatus()) ? "disabled" : "" %>>
                                    <option value="Confirmed" <%= "Confirmed".equals(o.getStatus()) ? "selected" : "" %> <%= !"Confirmed".equals(o.getStatus()) ? "disabled" : "" %>>Đã xác nhận</option>
                                    <option value="Delivering" <%= "Delivering".equals(o.getStatus()) ? "selected" : "" %> <%= "Delivered".equals(o.getStatus()) ? "disabled" : "" %>>Đang giao</option>
                                    <option value="Delivered" <%= "Delivered".equals(o.getStatus()) ? "selected" : "" %>>Đã giao</option>
                                </select>
                        </td>
                        <td>
                            <input type="hidden" name="orderId" value="<%= o.getOrderID() %>"/>
                            <button type="submit">Cập nhật</button>
                            </form>
                        </td>
                    </tr>
                    <% }} %>
                </tbody>
            </table>

            <!-- ======= QR Orders Table ======= -->
            <h2>Đơn hàng đã thanh toán QR cần giao</h2>
            <table class="styled-table">
                <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Khách hàng</th>
                        <th>Địa chỉ</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Chi tiết món</th>
                        <th>Trạng thái</th>
                        <th>Cập nhật</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (QRorders.isEmpty()) { %>
                    <tr><td colspan="8" style="text-align:center;color:gray;">Không có đơn hàng nào để hiển thị.</td></tr>
                    <% } else {
                        for (Order o : QRorders) {
                    %>
                    <tr>
                        <td><%= o.getOrderID() %></td>
                        <td><%= o.getReceiverName() %></td>
                        <td><%= o.getDeliveryAddress() %>, <%= o.getDistrict() %></td>
                        <td><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(o.getOrderDate()) %></td>
                        <td><%= String.format("%,.0f", o.getTotalAmount()) %> đ</td>
                        <td>
                            <% for (OrderItem item : o.getItems()) { %>
                            <div><%= item.getProductName() %>, số lượng: <%= item.getQuantity() %></div>
                            <% } %>

                        </td>
                        <td>
                            <form action="UpdateOrderStatusServlet" method="post">
                                <select name="status" <%= "QRDelivered".equals(o.getStatus()) ? "disabled" : "" %>>
                                    <option value="QRConfirmed" <%= "QRConfirmed".equals(o.getStatus()) ? "selected" : "" %> <%= !"QRConfirmed".equals(o.getStatus()) ? "disabled" : "" %>>Đã xác nhận</option>
                                    <option value="QRDelivering" <%= "QRDelivering".equals(o.getStatus()) ? "selected" : "" %> <%= "QRDelivered".equals(o.getStatus()) ? "disabled" : "" %>>Đang giao</option>
                                    <option value="QRDelivered" <%= "QRDelivered".equals(o.getStatus()) ? "selected" : "" %>>Đã giao</option>
                                </select>
                        </td>
                        <td>
                            <input type="hidden" name="orderId" value="<%= o.getOrderID() %>"/>
                            <button type="submit">Cập nhật</button>
                            </form>
                        </td>
                    </tr>
                    <% }} %>
                </tbody>
            </table>
        </div>

    </body>
</html>
