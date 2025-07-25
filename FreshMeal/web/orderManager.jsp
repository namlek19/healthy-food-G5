<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Tất cả đơn hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="includes/sidebarSeller.jsp"/>

        <div class="container" style="margin-left: 270px; padding-top: 30px; width: 1350px">
            <h3 class="mb-4 text-success">Danh sách tất cả đơn hàng</h3>
            <table class="table table-bordered table-hover align-middle">
                <thead class="table-success">
                    <tr>
                        <th>Mã đơn</th>
                        <th>Tên người nhận</th>
                        <th>Địa chỉ giao</th>
                        <th>Số điện thoại</th>
                        <th>Email</th>
                        <th>Các món + số lượng</th>
                        <th>Thời gian đặt</th>
                        <th>Thành Tiền</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="o" items="${orders}">
                        <tr>
                            <td>#${o.orderID}</td>
                            <td>${o.receiverName}</td>
                            <td>
                                ${o.deliveryAddress}<br>
                                ${o.district}
                            </td>
                            <td>${o.phone}</td>
                            <td>${o.email}</td>
                            <td>
                                <c:forEach var="item" items="${o.items}">
                                    ${item.productName} (SL: ${item.quantity})<br/>
                                </c:forEach>
                            </td>
                            <td>
                                <fmt:formatDate value="${o.orderDate}" pattern="HH:mm dd/MM/yyyy" />
                            </td>
                            <td>
                                <fmt:formatNumber value="${o.totalAmount}" type="number" maxFractionDigits="0"/> VNĐ
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${o.status == 'Pending' or o.status == 'QRPending'}">
                                        <span>Chưa xác nhận</span>
                                    </c:when>
                                    <c:when test="${o.status == 'Confirmed' or o.status == 'QRConfirmed'}">
                                        <span>Đã xác nhận</span>
                                    </c:when>
                                    <c:when test="${o.status == 'Delivering' or o.status == 'QRDelivering'}">
                                        <span>Đang giao</span>
                                    </c:when>
                                    <c:when test="${o.status == 'Delivered' or o.status == 'QRDelivered'}">
                                        <span>Đã giao</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span>${o.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div class="d-flex justify-content-end mb-3">
                <ul class="pagination">
                    <!-- Nút Previous -->
                    <li class="page-item ${page == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="orderManager?page=${page - 1}" tabindex="-1">Previous</a>
                    </li>
                    <!-- Các trang -->
                    <c:forEach var="i" begin="1" end="${totalPage}">
                        <li class="page-item ${i == page ? 'active' : ''}">
                            <a class="page-link" href="orderManager?page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    <!-- Nút Next -->
                    <li class="page-item ${page == totalPage ? 'disabled' : ''}">
                        <a class="page-link" href="orderManager?page=${page + 1}">Next</a>
                    </li>
                </ul>
            </div>
            <c:if test="${empty orders}">
                <div class="alert alert-info text-center">Không có đơn hàng nào.</div>
            </c:if>
        </div>
    </body>
</html>
