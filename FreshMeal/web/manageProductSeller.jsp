<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Quản lý món ăn</title>
        <link rel="stylesheet" href="assets/css/blog.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    </head>
    <body>
        <div class="d-flex">
            <jsp:include page="includes/sidebarSeller.jsp">
                <jsp:param name="currentPage" value="manageproductseller" />
            </jsp:include>

            <div style="margin-left: 250px; padding: 20px; width: 1250px">
                <h3 class="text-success">Danh sách món ăn</h3>
                <c:if test="${param.error == 'containedInMenu'}">
                    <div class="alert alert-danger">Không thể xóa! Món này đang nằm trong một combo.</div>
                </c:if>
                <c:if test="${param.message == 'deleted'}">
                    <div class="alert alert-success">Xóa món thành công!</div>
                </c:if>

                <table class="table table-striped table-bordered">
                    <thead class="table-success">
                        <tr>
                            <th>#</th>
                            <th>Tên món</th>
                            <th>Calories (kcal)</th>
                            <th>Giá</th>
                            <th>Xuất xứ</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${productList}" varStatus="loop">
                            <tr>
                                <td>${offset + loop.index + 1}</td>
                                <td>${p.name}</td>
                                <td>${p.calories}</td>
                                <td><fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/> VNĐ</td>
                                <td>${p.origin}</td>
                                <td>
                                    <a href="productdetail?id=${p.productID}" class="btn btn-outline-success btn-sm">Xem chi tiết</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <c:if test="${totalPages > 1}">    
                    <ul class="pagination justify-content-end">

                        <li class="page-item ${pageIndex == 1 ? 'disabled' : ''}">
                            <a class="page-link"
                               href="manageProductSeller?page=${pageIndex - 1}"
                               tabindex="-1"
                               aria-disabled="${pageIndex == 1 ? 'true' : 'false'}">
                                Trước
                            </a>
                        </li>


                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${i == pageIndex ? 'active' : ''}">
                                <a class="page-link" href="manageProductSeller?page=${i}">${i}</a>
                            </li>
                        </c:forEach>


                        <li class="page-item ${pageIndex == totalPages ? 'disabled' : ''}">
                            <a class="page-link"
                               href="manageProductSeller?page=${pageIndex + 1}"
                               aria-disabled="${pageIndex == totalPages ? 'true' : 'false'}">
                                Sau
                            </a>
                        </li>
                    </ul>
                </c:if>
            </div>    
        </div>
    </div>
</body>
</html>