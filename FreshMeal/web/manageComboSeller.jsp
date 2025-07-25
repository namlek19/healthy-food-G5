
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý Combo</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="includes/sidebarSeller.jsp" />

        <div class="container" style="margin-left: 270px; padding-top: 30px; width: 1250px">
            <h3 class="mb-4 text-success">Danh sách Combo</h3>

            <table class="table table-bordered table-hover align-middle">
                <thead class="table-success">
                    <tr>
                        <th>#</th>
                        <th>Tên Combo</th>
                        <th>Tổng giá</th>
                        <th>Nhóm BMI</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${menuList}" varStatus="loop">
                        <tr>
                            <td>${(pageIndex-1) * 10 + loop.index + 1}</td>
                            <td>${c.menuName}</td>
                            <td><fmt:formatNumber value="${c.totalPrice}" type="number" maxFractionDigits="0" /> VNĐ</td>
                            <td>${c.bmiCategory}</td>
                            <td>
                                <a href="menudetail?id=${c.menuID}" class="btn btn-outline-success btn-sm"">Xem chi tiết</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <c:if test="${totalPages > 1}">    
                <ul class="pagination justify-content-end">
                    <li class="page-item ${pageIndex == 1 ? 'disabled' : ''}">
                        <a class="page-link"
                           href="manageComboSeller?page=${pageIndex - 1}"
                           tabindex="-1"
                           aria-disabled="${pageIndex == 1 ? 'true' : 'false'}">
                            Trước
                        </a>
                    </li>
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${i == pageIndex ? 'active' : ''}">
                            <a class="page-link" href="manageComboSeller?page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${pageIndex == totalPages ? 'disabled' : ''}">
                        <a class="page-link"
                           href="manageComboSeller?page=${pageIndex + 1}"
                           aria-disabled="${pageIndex == totalPages ? 'true' : 'false'}">
                            Sau
                        </a>
                    </li>
                </ul>
            </c:if>
            <c:if test="${empty menuList}">
                <div class="alert alert-info text-center">Hiện chưa có combo nào để hiển thị.</div>
            </c:if>
        </div>
    </body>
</html>