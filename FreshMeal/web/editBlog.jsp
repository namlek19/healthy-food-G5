<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Chỉnh sửa Blog</title>
    <style>
        /* CSS đơn giản cho form */
        form { max-width: 600px; margin: 20px auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; }
        label { display: block; margin-bottom: 8px; }
        input[type="text"], textarea { width: 100%; padding: 8px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 4px; }
        button { padding: 10px 15px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; }
        a { text-decoration: none; color: #337ab7; }
    </style>
</head>
<body>
    <h1>Chỉnh sửa bài Blog</h1>
    
    <c:if test="${not empty blog}">
        <form action="blog" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${blog.blogID}">

            <label for="title">Tiêu đề:</label>
            <input type="text" id="title" name="title" value="${blog.title}" required>

            <label for="imageURL">URL Hình ảnh:</label>
            <input type="text" id="imageURL" name="imageURL" value="${blog.imageURL}">

            <label for="description">Nội dung:</label>
            <textarea id="description" name="description" rows="10" required>${blog.description}</textarea>

            <button type="submit">Cập nhật</button>
        </form>
    </c:if>
    <c:if test="${empty blog}">
        <p>Không tìm thấy bài blog để chỉnh sửa.</p>
    </c:if>
    
    <p><a href="blog">Quay lại danh sách</a></p>
</body>
</html>