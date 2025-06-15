<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Product Detail</title>
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/productlist.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <header class="bg-white shadow-sm">
            <div class="container d-flex align-items-center justify-content-between py-3">
                <div class="logo">
                    <a href="index.jsp">
                        <img src="assets/images/logo.png" alt="logo">
                    </a>
                </div>
                <nav>
                    <ul class="nav">
                        <li class="nav-item"><a href="productlistcontrol?category=" class="nav-link text-dark">Product</a></li>
                        <li class="nav-item"><a href="menucus?bmi=" class="nav-link text-dark">Menu</a></li>
                        <li class="nav-item"><a href="blogcus.jsp" class="nav-link text-dark">Blog</a></li>
                    </ul>
                </nav>
                <div class="d-flex align-items-center gap-3">
                    <a href="cart.jsp" title="Cart">
                        <img src="assets/images/shopping-cart.png" alt="Cart" style="width: 24px;">
                    </a>
                    <div class="auth-button">
                        <c:choose>
                            <c:when test="${sessionScope.user == null}">
                                <a href="login.jsp" class="btn btn-outline-success btn-sm">Sign In</a>
                                <a href="login.jsp?action=signup" class="btn btn-outline-success btn-sm">Sign Up</a>
                            </c:when>
                            <c:otherwise>
                                <a href="profile.jsp" class="auth-button">
                                    Hello, <c:out value="${sessionScope.user.firstName != null && !empty sessionScope.user.firstName ? sessionScope.user.firstName : sessionScope.user.fullName}"/>
                                </a>
                                <a href="login?action=logout" class="auth-button">Logout</a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </header>

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

        <footer class="bg-light text-center py-4 mt-5">
            <div class="container">
                <p class="mb-0 text-muted">&copy; 2025 HealthyFood. All rights reserved.</p>
            </div>
        </footer>
    </body>
</html>