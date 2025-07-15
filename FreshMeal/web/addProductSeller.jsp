<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Thêm món mới</title>
        <link rel="stylesheet" href="assets/css/style.css">
    </head>
    <jsp:include page="includes/sidebarSeller.jsp" />
    <body>
        <div class="container" style="margin-left: 270px; padding-top: 30px;">
            <h2>Thêm món mới</h2>
            <form action="addProductSeller" method="post" enctype="multipart/form-data">
                <div>
                    <label>Tên món:</label>
                    <input type="text" name="name" required />
                </div>
                <div>
                    <label>Mô tả:</label>
                    <textarea name="description" required></textarea>
                </div>
                <div>
                    <label>Calories:</label>
                    <input type="number" name="calories" required />
                </div>
                <div>
                    <label>Thông tin dinh dưỡng:</label>
                    <textarea name="nutritionInfo" required></textarea>
                </div>
                <div>
                    <label>Nguồn gốc:</label>
                    <input type="text" name="origin" required />
                </div>
                <div>
                    <label>Ảnh:</label>
                    <input type="file" name="image" accept="image/*" required />
                </div>
                <div>
                    <label>Hướng dẫn bảo quản:</label>
                    <input type="text" name="storageInstructions" required />
                </div>
                <div>
                    <label>Giá:</label>
                    <input type="number" step="0.01" name="price" required />
                </div>
                <div>
                    <label>Danh mục:</label>
                    <select name="categoryID" required>
                        <option value="1">Món chính</option>
                        <option value="2">Món phụ</option>
                        <option value="3">Tráng miệng</option>
                        <option value="4">Đồ uống</option>
                    </select>
                </div>
                <button type="submit">Thêm món</button>
            </form>
        </div>
    </body>
</html>