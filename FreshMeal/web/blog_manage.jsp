<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<link rel="stylesheet" href="assets/css/blog.css">
<%
    request.setAttribute("currentPage", "blogmanage");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Blog Manage</title>
        <head>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>
    <link rel="stylesheet" href="assets/css/blog.css">
    <link rel="stylesheet" href="assets/css/blog_manage.css">
</head>

    </head>
    
    <body style="margin:0;">
        <div style="display: flex; min-height: 100vh;">
            <%@ include file="sidebar.jsp" %>

                <div class="main-container">
                    <!-- ...container quản lý blog như code của bạn... -->
                    <h2>Quản lý bài viết đã đăng</h2>
                    <form class="search-bar" action="blogmanage" method="get">
                        <input type="text" name="search" placeholder="Tìm kiếm blog..." value="${search != null ? search : ''}">
                    <button type="submit">Find</button>
                </form>
                <div class="blog-list">
                    <c:forEach var="blog" items="${blogs}">
                        <div class="blog-row">
                            <img class="blog-img" src="${blog.imageURL}" alt="Ảnh blog"/>
                            <div class="blog-info">
                                <div class="blog-date">Ngày đăng: <fmt:formatDate value="${blog.createdAt}" pattern="dd/MM/yyyy"/></div>
                                <div class="blog-title">
                                    <a href="blogdetail?id=${blog.blogID}" style="color: #10634f; text-decoration: underline;">
                                        ${blog.title}
                                    </a>
                                </div>
                                <div class="blog-desc">
                                    <c:choose>
                                        <c:when test="${fn:length(blog.description) > 150}">
                                            ${fn:substring(blog.description, 0, 150)}...
                                        </c:when>
                                        <c:otherwise>
                                            ${blog.description}
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="actions">
                                <a class="icon-btn view" title="Xem chi tiết" href="blogdetail?id=${blog.blogID}"><i class="fas fa-eye"></i></a>
                                <a class="icon-btn edit" title="Chỉnh sửa" href="blog?action=edit&id=${blog.blogID}"><i class="fas fa-edit"></i></a>
                                <form action="blogmanage" method="post" onsubmit="return confirm('Bạn chắc chắn muốn xóa bài này?');">
                                    <input type="hidden" name="action" value="delete"/>
                                    <input type="hidden" name="id" value="${blog.blogID}"/>
                                    <button type="submit" class="icon-btn delete" title="Xóa"><i class="fas fa-trash"></i></button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty blogs}">
                        <div style="text-align:center;padding:18px 0;">Không có bài viết nào.</div>
                    </c:if>
                </div>
            </div>
        </div>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>
    </body>

</html>
