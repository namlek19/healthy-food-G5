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
        <style>
            

            /* CSS giống style của bạn, có thể copy phần sidebar/menu từ blog.jsp cho đồng bộ */
            body {
                font-family: Arial, sans-serif;
                background-color: #BEF0CF;
                margin: 0;
            }
            .main-container {
                flex: 1;
                padding: 20px;
                /* KHÔNG cần max-width, KHÔNG cần căn giữa bằng margin auto! */
                /* Sửa lại background nếu muốn giống blog.jsp */
                background: none;
                margin-left: 220px;
                padding: 20px;
            }

            h2 {
                text-align: center;
            }
            .search-bar {
                display: flex;
                gap: 10px;
                margin-bottom: 24px;
                justify-content: center;
            }
            .search-bar input[type="text"] {
                width: 350px;
                padding: 8px 12px;
                border-radius: 8px;
                border: 1px solid #aaa;
            }
            .search-bar button {
                background: #18cb77;
                color: #fff;
                border: none;
                padding: 0 22px;
                border-radius: 12px;
                font-size: 20px;
                cursor: pointer;
            }
            .blog-list {
                border-top: 2px solid #222;
                margin-top: 8px;
            }
            .blog-row {
                display: flex;
                align-items: center;
                gap: 16px;
                border-bottom: 1px solid #aee5bb;
                padding: 14px 0;
            }
            .blog-img {
                width: 80px;
                height: 80px;
                object-fit: cover;
                border-radius: 8px;
            }
            .blog-info {
                flex: 1;
            }
            .blog-title {
                font-size: 1.1em;
                font-weight: bold;
                color: #10634f;
                margin-bottom: 4px;
            }
            .blog-date {
                color: #888;
                font-size: 0.95em;
                margin-bottom: 2px;
            }
            .blog-desc {
                color: #2d2d2d;
                font-size: 0.97em;
            }
            .actions {
                display: flex;
                gap: 14px;
            }
            .actions form {
                display: inline;
            }
            .icon-btn {
                background: none;
                border: none;
                cursor: pointer;
                font-size: 22px;
            }
            .icon-btn.view {
                color: #1e90ff;
            }
            .icon-btn.edit {
                color: #17b978;
            }
            .icon-btn.delete {
                color: #ff4848;
            }
        </style>
    </head>
    <body style="margin:0;">
        <div style="display: flex; min-height: 100vh;">
            <div class="sidebar">
                <!-- ...sidebar như của bạn... -->
                <h2>BLOG</h2>
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/blog"
                           class="<c:if test='${currentPage eq "bloglist"}'>active</c:if>">
                               Blog List
                           </a>
                        </li>
                        <li>
                            <a href="blogpost"
                               class="<c:if test='${currentPage eq "blogpost"}'>active</c:if>">
                                Blog Post
                            </a>
                        </li>
                        <li>
                            <a href="blogmanage"
                               class="<c:if test='${currentPage eq "blogmanage"}'>active</c:if>">
                                Blog Manage
                            </a>
                        </li>
                    </ul>

                    <h2>MENU</h2>
                    <ul>
                        <li><a href="#">Menu List</a></li>
                        <li><a href="#">Menu Post</a></li>
                        <li><a href="#">Menu Manage</a></li>
                    </ul>
                    
                    <!-- Thêm nút logout ở đây -->
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/login?action=logout" style="color:red;">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </li>
            </ul>
                </div>

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
