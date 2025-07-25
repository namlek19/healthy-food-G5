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

        <div class="container" style="margin-left: 270px; padding-top: 30px; width: 1250px">

            <c:if test="${not empty sessionScope.msg}">
                <div class="alert alert-info">${sessionScope.msg}</div>
                <c:remove var="msg" scope="session"/>
            </c:if>

            <h3 class="mb-4 text-success">Danh sách đơn hàng COD</h3>

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
                            <td>${(pageCOD - 1) * 3 + loop.index + 1}</td>
                            <td>${o.receiverName}</td>
                            <td><strong>
                                    <fmt:formatDate value="${o.orderDate}" pattern="HH:mm" />
                                </strong>
                                ngày
                                <strong>
                                    <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy" />
                                </strong>
                            </td>
                            <td><fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/> VNĐ</td>
                            <td>
                                <a href="orderDetail?orderID=${o.orderID}" class="btn btn-outline-success btn-sm">Xem chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="d-flex justify-content-end mb-3">
                <ul class="pagination">
                    <li class="page-item ${pageCOD == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="orderSeller?pageCOD=${pageCOD - 1}&pageQR=${pageQR}" tabindex="-1">Previous</a>
                    </li>
                    <c:forEach var="i" begin="1" end="${totalPageCOD}">
                        <li class="page-item ${i == pageCOD ? 'active' : ''}">
                            <a class="page-link" href="orderSeller?pageCOD=${i}&pageQR=${pageQR}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${pageCOD == totalPageCOD ? 'disabled' : ''}">
                        <a class="page-link" href="orderSeller?pageCOD=${pageCOD + 1}&pageQR=${pageQR}">Next</a>
                    </li>
                </ul>
            </div>
            <c:if test="${empty pendingOrders}">
                <div class="alert alert-info text-center">Hiện chưa có đơn hàng COD nào đang chờ xử lý.</div>
            </c:if>
            <h3 class="mb-4 text-success">Danh sách đơn hàng đã thanh toán online</h3>

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
                    <c:forEach var="o" items="${pendingQROrders}" varStatus="loop">
                        <tr>
                            <td>${(pageQR - 1) * 3 + loop.index + 1}</td>
                            <td>${o.receiverName}</td>
                            <td><strong>
                                    <fmt:formatDate value="${o.orderDate}" pattern="HH:mm" />
                                </strong>
                                ngày
                                <strong>
                                    <fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy" />
                                </strong>
                            </td>
                            <td><fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/> VNĐ</td>
                            <td>
                                <a href="orderDetail?orderID=${o.orderID}" class="btn btn-outline-success btn-sm">Xem chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="d-flex justify-content-end mb-3">
                <ul class="pagination">
                    <li class="page-item ${pageQR == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="orderSeller?pageCOD=${pageCOD}&pageQR=${pageQR-1}" tabindex="-1">Previous</a>
                    </li>
                    <c:forEach var="i" begin="1" end="${totalPageQR}">
                        <li class="page-item ${i == pageQR ? 'active' : ''}">
                            <a class="page-link" href="orderSeller?pageCOD=${pageCOD}&pageQR=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${pageQR == totalPageQR ? 'disabled' : ''}">
                        <a class="page-link" href="orderSeller?pageCOD=${pageCOD}&pageQR=${pageQR+1}">Next</a>
                    </li>
                </ul>
            </div>
            <c:if test="${empty pendingQROrders}">
                <div class="alert alert-info text-center">Hiện chưa có đơn hàng đã thanh toán nào đang chờ xử lý.</div>
            </c:if>
        </div>
    </body>
</html>
