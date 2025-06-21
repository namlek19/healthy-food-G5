<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%
    Integer roleID = (Integer) session.getAttribute("roleID");
    String backUrl = (roleID != null && roleID == 5) ? "blogmanage" : "blogcus";
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết Blog</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">

    </head>
    <link rel="stylesheet" href="assets/css/blog_detail.css">
    <body>
        <div class="blog-container">
            <a href="<%= backUrl %>" class="back-link">← Quay lại</a>
            <div class="blog-title preserve-whitespace">${blog.title}</div>
            <div class="blog-meta">
                Người đăng: <b>${blog.nutritionistName}</b> | 
                <fmt:formatDate value="${blog.createdAt}" pattern="dd/MM/yyyy"/>
            </div>
            <c:if test="${not empty blog.imageURL}">
                <img class="blog-img" src="${blog.imageURL}" />
            </c:if>
            <div class="blog-desc">
                <c:out value="${blogDescHtml}" escapeXml="false"/>
            </div>


        </div>

        <div class="latest-blogs-section">
            <div class="latest-blogs-title">Bài viết mới nhất</div>
            <c:forEach var="b" items="${latestBlogs}">
                <div class="latest-blog-row">
                    <a class="latest-blog-img" href="blogdetail?id=${b.blogID}">
                        <img src="${not empty b.imageURL ? b.imageURL : 'assets/images/default-blog.jpg'}" alt="Ảnh blog" />
                    </a>
                    <div class="latest-blog-info">
                        <a class="latest-blog-title" href="blogdetail?id=${b.blogID}">${b.title}</a>
                        <div class="latest-blog-meta">
                            Người đăng: ${b.nutritionistName} |
                            <fmt:formatDate value="${b.createdAt}" pattern="dd/MM/yyyy"/>
                        </div>
                        <div class="latest-blog-desc">
                            <c:choose>
                                <c:when test="${fn:length(b.description) > 100}">
                                    ${fn:substring(b.description, 0, 100)}...
                                </c:when>
                                <c:otherwise>
                                    ${b.description}
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty latestBlogs}">
                <div>Không có bài viết nào khác.</div>
            </c:if>
        </div>

    </body>
</html>
