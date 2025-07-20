<%@ page import="model.User" %>
<%@ page import="model.Product" %>
<%@ page import="dal.ProductDAO" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>product list</title>
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/productlist.css">
        <link rel="stylesheet" href="assets/css/header-user.css"> 
        <link rel="stylesheet" href="assets/css/footer.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <jsp:include page="includes/header.jsp" />

        <div class="container">
            <form method="get" action="productlistcontrol">
                <div class="row justify-content-center g-3 mb-4">
                    <div class="col-md-4">
                        <select class="form-select" name="category">
                            <option value="">Tất cả danh mục</option>
                            <option value="1">Món chính</option>
                            <option value="2">Món phụ</option>
                            <option value="3">Tráng miệng</option>
                            <option value="4">Đồ uống</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">Lọc</button>
                    </div>
                </div>
            </form>
        </div> 
        <div class="container mb-3 text-center">
            <h5 class="fw-bold text-success">${categoryName}</h5>
        </div>

        <div class="container">
            <c:forEach var="p" items="${productList}" varStatus="status">
                <c:if test="${status.index % 3 == 0}">
                    <div class="row mb-4">
                    </c:if>

                    <div class="col-md-4 mb-4 d-flex">
                        <div class="card h-100 shadow-sm w-100">
                            <img src="${p.imageURL}" class="card-img-top custom-size" alt="Ảnh món ăn">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title text-truncate">${p.name}</h5>
                                <p class="card-text text-truncate">Calories: ${p.calories} kcal</p>
                                <p class="fw-bold text-success">
                                    Giá: <fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/> VNĐ
                                </p>
                                <a href="productdetail?id=${p.productID}" class="btn btn-success mt-auto w-100">Xem chi tiết</a>
                            </div>
                        </div>
                    </div>

                    <c:if test="${status.index % 3 == 2 || status.last}">
                    </div>
                </c:if>
            </c:forEach>

            <div class="container mt-4 d-flex justify-content-center">
                <ul class="pagination">
                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <li class="page-item ${i == page ? 'active' : ''}">
                            <a class="page-link" href="productlistcontrol?category=${category}&page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                </ul>
            </div>

        </div>       
        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
