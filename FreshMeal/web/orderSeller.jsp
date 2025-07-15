<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Đơn hàng đang chờ</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="includes/sidebarSeller.jsp"/>

        <div class="container" style="margin-left: 270px; padding-top: 30px;">
            <h3 class="mb-4 text-success">Danh sách đơn hàng đang chờ xử lý</h3>

            <c:if test="${not empty sessionScope.msg}">
                <div class="alert alert-info">${sessionScope.msg}</div>
                <c:remove var="msg" scope="session"/>
            </c:if>

            <table class="table table-bordered table-hover align-middle">
                <thead class="table-success">
                    <tr>
                        <th>#</th>
                        <th>Tên Người nhận</th>
                        <th>Thời gian đặt</th>
                        <th>Tổng tiền</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="o" items="${pendingOrders}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>${o.receiverName}</td>
                            <td><strong>
                                <fmt:formatDate value="${o.orderDate}" pattern="HH:mm" />
                                </strong>
                                ngày
                                <strong>
                                <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy" />
                                </strong>
                            </td>
                            <td>${o.totalAmount}đ</td>
                            <td>
                                <a href="orderDetail?orderID=${o.orderID}" class="btn btn-outline-info btn-sm">Xem chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <c:if test="${empty pendingOrders}">
                <div class="alert alert-info text-center">Hiện chưa có đơn hàng nào đang chờ xử lý.</div>
            </c:if>
        </div>
    </body>
</html>
