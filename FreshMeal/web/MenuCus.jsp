<%@ page import="model.User" %>
<%@ page import="model.Menu" %>
<%@ page import="model.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Menu theo BMI</title>
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/productlist.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .menu-card-img {
                max-height: 180px;
                object-fit: cover;
                border-radius: 12px 12px 0 0;
            }
            .menu-products-list li {
                font-size: 0.95em;
                color: #345;
            }
        </style>
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
                        <li class="nav-item"><a href="productlistcontrol?category=" class="nav-link text-dark" >Product</a></li>
                        <li class="nav-item"><a href="menucus?bmi=" class="nav-link text-dark" >Menu</a></li>
                        <li class="nav-item"><a href="blogcus.jsp" class="nav-link text-dark" >Blog</a></li>
                    </ul>
                </nav>
                <div class="d-flex align-items-center gap-3">
                    <a href="cart.jsp" title="Cart">
                        <img src="assets/images/shopping-cart.png" alt="Cart" style="width: 24px;">
                    </a>
                    <div class="auth-button">
                        <% User user = (User) session.getAttribute("user"); %>
                        <% if (user == null) { %>
                        <a href="login.jsp" class="btn btn-outline-success btn-sm">Sign In</a>
                        <a href="login.jsp?action=signup" class="btn btn-outline-success btn-sm">Sign Up</a>
                        <% } else { %>
                        <a href="profile.jsp" class="auth-button">Hello, <%= user.getFirstName() != null && !user.getFirstName().isEmpty() ? user.getFirstName() : user.getFullName() %></a>
                        <a href="login?action=logout" class="auth-button">Logout</a>
                        <% } %>
                    </div>
                </div>
            </div>
        </header>

        <div class="search-bar">
            <form action="search">
                <input type="text" placeholder="Searching for menu..." required />        
            </form>
        </div>

        <div class="container">
            <form method="get" action="menucus">
                <div class="row justify-content-center g-3 mb-4">
                    <div class="col-md-4">
                        <select class="form-select" name="bmi">
                            <option value="">Tất cả nhóm BMI</option>
                            <option value="Underweight">Gầy (Underweight)</option>
                            <option value="Normal">Bình thường (Normal)</option>
                            <option value="Overweight">Thừa cân (Overweight)</option>
                            <option value="Obese">Béo phì (Obese)</option>
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
            <c:forEach var="menu" items="${menuList}" varStatus="status">
                <c:if test="${status.index % 3 == 0}">
                    <div class="row mb-4">
                    </c:if>
                    <div class="col-md-4 mb-4 d-flex">
                        <div class="card h-100 shadow-sm w-100">
                            <img src="${menu.imageURL}" class="card-img-top menu-card-img" alt="Ảnh thực đơn">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title text-truncate text-success">${menu.menuName}</h5>
                                <p class="card-text text-truncate">${menu.description}</p>
                                <p class="fw-bold text-success">
                                    Giá: <fmt:formatNumber value="${menu.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                                </p>
                                <ul class="menu-products-list">
                                    <c:forEach var="p" items="${menu.products}">
                                        <li>${p.name} (<span class="text-muted">${p.calories} kcal</span>)</li>
                                        </c:forEach>
                                </ul>
                                <a href="menudetail?id=${menu.menuID}" class="btn btn-success mt-auto w-100">Xem chi tiết</a>
                            </div>
                        </div>
                    </div>
                    <c:if test="${status.index % 3 == 2 || status.last}">
                    </div>
                </c:if>
            </c:forEach>
            <c:if test="${empty menuList}">
                <div class="alert alert-info text-center mt-3">Chưa có thực đơn nào cho nhóm BMI này!</div>
            </c:if>
        </div>
        <footer class="bg-light text-center py-4 mt-5">
            <div class="container">
                <p class="mb-0 text-muted">&copy; 2025 HealthyFood. All rights reserved.</p>
            </div>
        </footer>
    </body>
</html>