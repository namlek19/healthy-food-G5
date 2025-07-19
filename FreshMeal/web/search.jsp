<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Healthy Food</title>
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/header-user.css"> 
        <link rel="stylesheet" href="assets/css/footer.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    </head>
    <body>
        <jsp:include page="includes/header.jsp" />

        <div class="container my-4">
            <h3 class="text-success text-center mb-4">
                Kết quả tìm kiếm cho từ khóa: 
                <span class="text-danger">
                    <c:out value="${keyword}"/>
                </span>
            </h3>

            <!-- Kết quả Món ăn -->
            <h4 class="text-success mb-3">Món ăn</h4>
            <div class="row">
                <c:choose>
                    <c:when test="${empty searchedProducts}">
                        <div class="alert alert-warning">Không tìm thấy món ăn nào.</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="p" items="${searchedProducts}">
                            <div class="col-md-3 mb-4">
                                <div class="card h-100 shadow-sm">
                                    <img src="${p.imageURL}" class="card-img-top custom-size" alt="${p.name}">
                                    <div class="card-body d-flex flex-column">
                                        <h5 class="card-title text-truncate">${p.name}</h5>
                                        <p class="card-text">Calories: ${p.calories} kcal</p>
                                        <p class="fw-bold text-success">
                                            <fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/> VNĐ
                                        </p>
                                        <a href="productdetail?id=${p.productID}" class="btn btn-outline-success mt-auto w-100">Xem chi tiết</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Kết quả Combo -->
            <h4 class="text-success mt-5 mb-3">Combo</h4>
            <div class="row">
                <c:choose>
                    <c:when test="${empty searchedMenus}">
                        <div class="alert alert-warning">Không tìm thấy combo nào.</div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="menu" items="${searchedMenus}">
                            <div class="col-md-3 mb-4">
                                <div class="card h-100 shadow-sm">
                                    <img src="${menu.imageURL}" class="card-img-top menu-card-img" alt="${menu.menuName}">
                                    <div class="card-body d-flex flex-column">
                                        <h5 class="card-title text-success text-truncate">${menu.menuName}</h5>
                                        <p class="card-text text-truncate">${menu.description}</p>
                                        <p class="fw-bold text-success">
                                            Tổng giá: <fmt:formatNumber value="${menu.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                                        </p>
                                        <a href="menudetail?id=${menu.menuID}" class="btn btn-outline-success mt-auto w-100">Xem chi tiết</a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>                       

        <jsp:include page="includes/footer.jsp" />
    </body>
</html>
