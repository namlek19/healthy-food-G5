<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng bài viết mới</title>
</head>
<body>
    <h2>Đăng bài viết mới</h2>
    <form action="blogpost" method="post">
        <label>Tiêu đề:</label><br>
        <input type="text" name="title" required><br><br>
        <label>Nội dung:</label><br>
        <textarea name="description" rows="6" cols="50" required></textarea><br><br>
        <label>Ảnh (URL hoặc upload):</label><br>
        <input type="text" name="imageURL" placeholder="Dán link ảnh hoặc upload"><br>
        <!-- Nếu muốn upload file thực, cần thêm input type="file" và xử lý upload -->
        <br>
        <button type="submit">Đăng bài</button>
    </form>
    <br>
    <a href="blog">Quay lại danh sách bài viết</a>
</body>
</html>