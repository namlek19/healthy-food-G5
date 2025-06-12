<%@ page import="model.User" %>
<%@ page import="model.Product" %>
<%@ page import="dal.ProductDAO" %>
<%@ page import="java.util.List" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>product list</title>
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
                    <img src="assets/images/logo.png" alt="logo">
                </div>
                <nav>
                    <ul class="nav">
                        <li class="nav-item"><a href="ProductList.jsp" class="nav-link text-dark" href="#">Product</a></li>
                        <li class="nav-item"><a href="MenuCus.jsp" class="nav-link text-dark" href="#">Menu</a></li>
                        <li class="nav-item"><a href="blogcus.jsp" class="nav-link text-dark" href="#">Blog</a></li>
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
                <input type="text" placeholder="Searching for food..." required />        
            </form>
        </div>

        <form class="row g-3 mb-4" method="get" action="ProductList.jsp">
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
                <button type="submit" class="btn btn-primary">Lọc</button>
            </div>
        </form>

        <%
    String category = request.getParameter("category");
    ProductDAO dao = new ProductDAO();
    List<Product> productList = dao.getProductByCategory(category);
        %>
        <%
    String categoryName;
    switch (category != null ? category : "") {
        case "1":
            categoryName = "Món chính";
            break;
        case "2":
            categoryName = "Món phụ";
            break;
        case "3":
            categoryName = "Tráng miệng";
            break;
        case "4":
            categoryName = "Đồ uống";
            break;
        default:
            categoryName = "Tất cả món ăn";
    }
        %>

        <div class="container mb-3">
            <h5 class="fw-bold text-success"><%= categoryName %></h5>
        </div>
        <%
    int count = 0;
    for (Product p : productList) {
        if (count % 3 == 0) {
        %>
        <div class="row mb-4">
            <%
                    }
            %>
            <div class="col-md-4 mb-4">
                <div class="card h-100 shadow-sm">
                    <img src="<%= p.getImageURL() %>" class="card-img-top custom-size" alt="Ảnh món ăn">
                    <div class="card-body">
                        <h5 class="card-title"><%= p.getName() %></h5>
                        <p class="card-text text-truncate"><%= p.getDescription() %></p>
                        <p class="fw-bold text-success">Giá: <%= String.format("%,.0f", p.getPrice()) %> VNĐ</p>
                        <a href="ProductDetail.jsp?id=<%= p.getProductID() %>" class="btn btn-success">Xem chi tiết</a>
                    </div>
                </div>
            </div>
            <%
                    count++;
                    if (count % 3 == 0 || count == productList.size()) {
            %>
        </div>
        <%
                }
            }
        %>           
        <footer class="bg-light text-center py-4 mt-5">
            <div class="container">
                <p class="mb-0 text-muted">&copy; 2025 HealthyFood. All rights reserved.</p>
            </div>
        </footer>
    </body>
</html>
