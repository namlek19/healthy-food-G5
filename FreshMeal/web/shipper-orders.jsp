<%@ page import="java.util.*, model.Order, model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User shipper = (User) session.getAttribute("user");
    if (shipper == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Order> orders = (List<Order>) request.getAttribute("orders");
    if (orders == null) orders = Collections.emptyList();
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

        <!-- ✅ MAIN CONTENT -->
        <div class="container">
            <h2>Đơn hàng được giao</h2>

            <% if (request.getAttribute("message") != null) { %>
            <div class="success-message"><%= request.getAttribute("message") %></div>
            <% } else if (request.getAttribute("error") != null) { %>
            <div class="error-message"><%= request.getAttribute("error") %></div>
            <% } %>

            <table class="styled-table">
                <thead>
                    <tr>
                        <th>Mã đơn</th>
                        <th>Khách hàng</th>
                        <th>Địa chỉ</th>
                        <th>Ngày đặt</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th>Cập nhật</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (orders.isEmpty()) { %>
                    <tr>
                        <td colspan="7" style="text-align:center;color:gray;">Không có đơn hàng nào để hiển thị.</td>
                    </tr>
                    <% } else {
            for (Order o : orders) { %>
                    <tr>
                        <td><%= o.getOrderID() %></td>
                        <td><%= o.getReceiverName() %></td>
                        <td><%= o.getDeliveryAddress() %>, <%= o.getDistrict() %></td>
                        <td><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(o.getOrderDate()) %></td>
                        <td><%= String.format("%,.0f", o.getTotalAmount()) %> đ</td>
                        <td>
                            <form action="UpdateOrderStatusServlet" method="post">
                                
                                    <select name="status" <%= "Delivered".equals(o.getStatus()) ? "disabled" : "" %>>
                                        <option value="Confirmed" <%= "Confirmed".equals(o.getStatus()) ? "selected" : "" %>>Confirmed</option>
                                        <option value="Delivering" <%= "Delivering".equals(o.getStatus()) ? "selected" : "" %>>Delivering</option>
                                        <option value="Delivered" <%= "Delivered".equals(o.getStatus()) ? "selected" : "" %>>Delivered</option>
                                    </select>
                                

                        </td>
                        <td>
                            <input type="hidden" name="orderId" value="<%= o.getOrderID() %>"/>
                            <button type="submit">Cập nhật</button>
                            </form>
                        </td>
                    </tr>
                    <%  } } %>
                </tbody>
            </table>
        </div>

    </body>
</html>
