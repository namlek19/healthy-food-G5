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
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                font-family: 'Poppins', sans-serif;
            }
            .hero-text h1 {
                color: #2b9348;
            }
            .cta-button {
                background-color: #2b9348;
                color: white;
                padding: 10px 20px;
                border-radius: 6px;
                text-decoration: none;
                font-weight: 600;
            }
            .cta-button:hover {
                background-color: #238043;
                color: #fff;
            }
            .search-bar input {
                box-shadow: 0 0 12px rgba(0, 128, 0, 0.2);
                border-radius: 25px;
                padding: 10px 20px;
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

        <div class="search-bar">
            <form action="search">
                <input type="text" placeholder="Searching for food..." required />        
            </form>
        </div>

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
        </div>       
        <footer class="bg-light text-center py-4 mt-5">
            <div class="container">
                <p class="mb-0 text-muted">&copy; 2025 HealthyFood. All rights reserved.</p>
            </div>
        </footer>
    </body>
</html>
