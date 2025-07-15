<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Chi tiết đơn hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="includes/sidebarSeller.jsp" />

        <div class="container" style="margin-left: 270px; padding-top: 30px;">
            <h3 class="text-success mb-4">Chi tiết Order #${order.orderID}</h3>

            <p><strong>Tên người mua:</strong> <c:out value="${order.receiverName}" default="null" /></p>
            <p><strong>Số điện thoại:</strong> <c:out value="${order.phone}" default="null" /></p>
            <p><strong>Địa chỉ:</strong> ${order.deliveryAddress}, ${order.district}</p>
            <p><strong>Email:</strong> <c:out value="${order.email}" default="null" /></p>

            <h5 class="mt-4">Danh sách món ăn</h5>
            <table class="table table-bordered">
                <thead class="table-success">
                    <tr>
                        <th>#</th>
                        <th>Tên món</th>
                        <th>Số lượng</th>
                        <th>Đơn giá</th>
                        <th>Xem món</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${order.items}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>${item.productName}</td>
                            <td>${item.quantity}</td>
                            <td>${item.price}đ</td>
                            <td><a class="btn btn-sm btn-outline-info" href="productdetail?id=${item.productID}">Xem món</a></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <h5 class="mt-3">Tổng tiền: <span class="text-danger fw-bold">${order.totalAmount}đ</span></h5>

            <form action="confirmOrder" method="post" class="mt-4">
                <input type="hidden" name="orderID" value="${order.orderID}" />
                <h5>Chọn shipper:</h5>
                <table class="table table-bordered table-hover">
                    <thead class="table-success">
                        <tr>
                            <th>#</th>
                            <th>Tên shipper</th>
                            <th>Chọn</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="shipper" items="${shippers}" varStatus="loop">
                            <tr>
                                <td>${loop.index + 1}</td>
                                <td>${shipper.fullName}</td>
                                <td>
                                    <input type="radio" name="shipperID" value="${shipper.userID}" required />
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <button type="submit" class="btn btn-success">Xác nhận</button>
            </form>

            <form action="rejectOrder" method="post" class="mt-2" onsubmit="return confirm('Bạn chắc chắn muốn từ chối đơn này?');">
                <input type="hidden" name="orderID" value="${order.orderID}" />
                <button class="btn btn-danger">Từ chối</button>
            </form>
        </div>
    </body>
</html>
