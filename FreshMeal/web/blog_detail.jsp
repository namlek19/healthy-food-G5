<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
    </body>
</html>
