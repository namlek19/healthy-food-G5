<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Product Detail</title>
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

        <div class="container mt-4">
            <c:choose>
                <c:when test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:when>
                <c:when test="${empty product}">
                    <div class="alert alert-danger">Sản phẩm không tồn tại hoặc đã bị xóa!</div>
                </c:when>
                <c:otherwise>
                    <h2 class="fw-bold mb-4 text-success">${product.name}</h2>
                    <div class="row">
                        <div class="col-md-9">
                            <div class="card mb-3">
                                <img src="${product.imageURL}"
                                     class="card-img-top"
                                     alt="Ảnh món ăn"
                                     style="width:100%; height:550px; object-fit:cover; border-top-left-radius: .5rem; border-top-right-radius: .5rem;">
                                <div class="card-body">
                                    <h5 class="card-title">Mô tả</h5>
                                    <p class="card-text">${product.description}</p>
                                    <div class="row mt-4 align-items-center">
                                        <div class="col-md-4 mb-2">
                                            <h5 class="text-success">
                                                <fmt:formatNumber value="${product.price}" type="number" maxFractionDigits="0"/> VNĐ
                                            </h5>
                                        </div>
                                        <div class="col-md-4 mb-2">
                                            <form action="CartServlet" method="post">
                                                <input type="hidden" name="id" value="${product.productID}">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="redirect" value="productdetail?id=${product.productID}">
                                                <button type="submit" class="btn btn-outline-success w-100"
                                                        onclick="alert('Thêm vào giỏ hàng thành công!');">Thêm vào giỏ</button>
                                            </form>
                                        </div>
                                        <div class="col-md-4 mb-2">
                                            <form action="CartServlet" method="post">
                                                <input type="hidden" name="id" value="${product.productID}">
                                                <input type="hidden" name="action" value="add">
                                                <input type="hidden" name="redirect" value="cart.jsp">
                                                <button type="submit" class="btn btn-success w-100">Mua ngay</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="card mb-3">
                                <div class="card-body">
                                    <h6 class="fw-bold mb-3 text-success">Danh mục</h6>
                                    <p>${catName}</p>
                                    <h6 class="fw-bold mt-4">Nutrition Info</h6>
                                    <p>${product.nutritionInfo}</p>
                                    <h6 class="fw-bold mt-4">Nguồn gốc</h6>
                                    <p>${product.origin}</p>
                                    <h6 class="fw-bold mt-4">Calories</h6>
                                    <p>${product.calories} kcal</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <jsp:include page="includes/footer.jsp" />
    </body>
</html>