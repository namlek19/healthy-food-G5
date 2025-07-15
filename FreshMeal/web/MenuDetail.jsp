<%@ page import="model.Menu" %>
<%@ page import="model.Product" %>
<%@ page import="model.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    User user = (User) session.getAttribute("user");
    int roleID = (user != null) ? user.getRoleID() : -1;
    boolean isSeller = (roleID == 4);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Menu Detail</title>
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/productlist.css">
        <link rel="stylesheet" href="assets/css/header-user.css"> 
        <link rel="stylesheet" href="assets/css/footer.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .menu-detail-img {
                width:100%;
                height:400px;
                object-fit:cover;
                border-radius:12px 12px 0 0;
            }
            .product-link {
                text-decoration:none;
                color:#218838;
            }
            .product-link:hover {
                text-decoration:underline;
                color:#18642a;
            }
        </style>
    </head>
    <body>
        <% if (!isSeller) { %>
        <jsp:include page="includes/header.jsp" />
        <% } %>

        <div class="container mt-4">
            <c:choose>
                <c:when test="${menu == null}">
                    <div class="alert alert-danger">Thực đơn không tồn tại hoặc đã bị xóa!</div>
                </c:when>
                <c:otherwise>
                    <h2 class="fw-bold mb-4 text-success">${menu.menuName}</h2>
                    <div class="row">

                        <div class="col-md-8">
                            <div class="card mb-3">
                                <img src="${menu.imageURL}" class="menu-detail-img" alt="Ảnh thực đơn">
                                <div class="card-body">
                                    <h5 class="card-title mb-2">Mô tả</h5>
                                    <p class="card-text">${menu.description}</p>
                                    <h5 class="fw-bold text-success mt-4">
                                        Giá tổng thực đơn:
                                        <fmt:formatNumber value="${menu.totalPrice}" type="number" maxFractionDigits="0"/> VNĐ
                                    </h5>
                                </div>
                                <% if (!isSeller) { %>    
                                <div class="row mt-3 align-items-center">
                                    <div class="col-md-6 mb-2">
                                        <form action="CartServlet" method="post">
                                            <input type="hidden" name="menu_id" value="${menu.menuID}">
                                            <input type="hidden" name="action" value="add_menu">
                                            <input type="hidden" name="redirect" value="menudetail?id=${menu.menuID}">
                                            <button type="submit" class="btn btn-outline-success w-100" 
                                                    onclick="alert('Thêm thực đơn vào giỏ hàng thành công!');">Thêm vào giỏ</button>
                                        </form>
                                    </div>

                                    <div class="col-md-6 mb-2">
                                        <form action="CartServlet" method="post">
                                            <input type="hidden" name="menu_id" value="${menu.menuID}">
                                            <input type="hidden" name="action" value="add_menu">
                                            <input type="hidden" name="redirect" value="cart.jsp">
                                            <button type="submit" class="btn btn-success w-100">Mua ngay</button>
                                        </form>
                                    </div>

                                </div>
                                <% } %>            
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="card mb-3">
                                <div class="card-body">
                                    <h6 class="fw-bold mb-3 text-success">Các món trong thực đơn</h6>
                                    <ul class="list-group">
                                        <c:forEach var="p" items="${menu.products}">
                                            <li class="list-group-item d-flex justify-content-between align-items-center">
                                                <a class="product-link" href="productdetail?id=${p.productID}">${p.name}</a>
                                                <span class="badge bg-success rounded-pill">${p.calories} kcal</span>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                            </div>
                            <c:if test="${roleID == 4}">
                                <div class="mb-3">
                                    <a href="manageComboSeller" class="btn btn-success">&larr; Quay lại trang quản lý combo</a>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <% if (!isSeller) { %>
            <jsp:include page="includes/footer.jsp" />
        <% } %>
        
    </body>
</html>