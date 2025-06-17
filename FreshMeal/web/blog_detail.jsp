<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    Integer roleID = (Integer) session.getAttribute("roleID");
    String backUrl = (roleID != null && roleID == 5) ? "blog" : "blogcus";
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết Blog</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>
        <style>
            .container {
                max-width: 700px;
                margin: 30px auto;
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 2px 12px #ddeee0;
                padding: 32px 28px;
            }
            .blog-img {
                width: 100%;
                border-radius: 8px;
                margin-bottom: 14px;
            }
            .blog-title {
                font-size: 2em;
                font-weight: bold;
                color: #187766;
                margin-bottom: 8px;
            }
            .blog-meta {
                color: #777;
                margin-bottom: 16px;
            }
            .blog-desc {
                font-size: 1.1em;
                margin-bottom: 16px;
            }
            .preserve-whitespace {
                white-space: pre-wrap;
                word-wrap: break-word;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <a href="<%= backUrl %>" style="color:#999;text-decoration:underline;">← Quay lại</a>
            <div class="blog-title preserve-whitespace">${blog.title}</div>
            <div class="blog-meta">
                Đăng bởi <b>${blog.nutritionistName}</b> | 
                Ngày đăng: <fmt:formatDate value="${blog.createdAt}" pattern="dd/MM/yyyy"/>
            </div>
            <c:if test="${not empty blog.imageURL}">
                <img class="blog-img" src="${blog.imageURL}" />
            </c:if>
            <div class="blog-desc preserve-whitespace">
                ${blog.description}
            </div>
        </div>
    </body>
</html>
