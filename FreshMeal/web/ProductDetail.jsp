<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="model.Product" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    Product product = (Product) request.getAttribute("product");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product Detail</title>
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/productlist.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">

        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

        <!-- Custom styles (optional) -->
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
            header img {
                height: 40px;
            }
            .auth-buttons .btn {
                font-size: 0.9rem;
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
                        <li class="nav-item"><a href="MenuCus.jsp" class="nav-link text-dark" >Menu</a></li>
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


        <div class="container mt-4">
            <!-- Tên món trên cùng -->
            <% if (product == null) { %>
            <div class="alert alert-danger">
                Sản phẩm không tồn tại hoặc đã bị xóa!
            </div>
            <% } else { %>

            <h2 class="fw-bold mb-4 text-success"><%= product.getName() %></h2>
            <div class="row">
                <!-- Phần chính: col-md-9 -->
                <div class="col-md-9">
                    <div class="card mb-3">
                        <!-- Ảnh lớn trên cùng -->
                        <img src="<%= product.getImageURL() %>" 
                             class="card-img-top"
                             alt="Ảnh món ăn"
                             style="width:100%; height:550px; object-fit:cover; border-top-left-radius: .5rem; border-top-right-radius: .5rem;">
                        <div class="card-body">
                            <h5 class="card-title">Mô tả</h5>
                            <p class="card-text"><%= product.getDescription() %></p>
                            <!-- 3 cột: Giá, Thêm vào giỏ, Mua ngay -->
                         <div class="row mt-4 align-items-center">
    <div class="col-md-4 mb-2">
        <h5 class="text-success">
            <fmt:formatNumber value="<%= product.getPrice() %>" type="number" maxFractionDigits="0"/> VNĐ
        </h5>
    </div>

    <!-- Thêm vào giỏ -->
    <div class="col-md-4 mb-2">
        <form action="CartServlet" method="post">
            <input type="hidden" name="id" value="<%= product.getProductID() %>">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="redirect" value="productdetail?id=<%= product.getProductID() %>">
            <button type="submit" class="btn btn-outline-success w-100">Thêm vào giỏ</button>
        </form>
    </div>

    <!-- Mua ngay -->
    <div class="col-md-4 mb-2">
        <form action="CartServlet" method="post">
            <input type="hidden" name="id" value="<%= product.getProductID() %>">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="redirect" value="cart.jsp">
            <button type="submit" class="btn btn-success w-100">Mua ngay</button>
        </form>
    </div>
</div>
                        </div>
                    </div>
                </div>

                <!-- Phần phụ: col-md-3 -->
                <div class="col-md-3">
                    <div class="card mb-3">
                        <div class="card-body">
                            <h6 class="fw-bold mb-3 text-success">Danh mục</h6>
                            <%
                                String catName = "Khác";
                                switch(product.getCategoryID()) {
                                    case 1: catName = "Món chính"; break;
                                    case 2: catName = "Món phụ"; break;
                                    case 3: catName = "Tráng miệng"; break;
                                    case 4: catName = "Đồ uống"; break;
                                }
                            %>
                            <p><%= catName %></p>

                            <h6 class="fw-bold mt-4">Nutrition Info</h6>
                            <p><%= product.getNutritionInfo() %></p>

                            <h6 class="fw-bold mt-4">Nguồn gốc</h6>
                            <p><%= product.getOrigin() %></p>

                            <h6 class="fw-bold mt-4">Calories</h6>
                            <p><%= product.getCalories() %> kcal</p>
                        </div>
                    </div>
                </div>
            </div>
            <% } %>
        </div>



        <footer class="bg-light text-center py-4 mt-5">
            <div class="container">
                <p class="mb-0 text-muted">&copy; 2025 HealthyFood. All rights reserved.</p>
            </div>
        </footer>
    </body>
    <%
    String msg = (String) session.getAttribute("msg");
    if (msg != null) {
%>
<div class="alert alert-success alert-dismissible fade show" role="alert" style="margin-top: 15px;">
    <%= msg %>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>
<%
        session.removeAttribute("msg");
    }
%>

</html>
