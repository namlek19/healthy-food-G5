<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Thêm món mới</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/addProductSeller.css">
    </head>
    <body>

        <jsp:include page="includes/sidebarSeller.jsp" />

        <div class="form-container">
            <h2>Thêm món mới</h2>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>

            <form action="addProductSeller" method="post">
                <div class="mb-3">
                    <label class="form-label">Tên món:</label>
                    <input type="text" name="name" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Mô tả:</label>
                    <textarea name="description" class="form-control" required></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Calories:</label>
                    <input type="number" name="calories" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Thông tin dinh dưỡng:</label>
                    <textarea name="nutritionInfo" class="form-control" required></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Nguồn gốc:</label>
                    <input type="text" name="origin" class="form-control" required />
                </div>

                <div class="mb-3">
                    <label class="form-label">Ảnh món:</label>
                    <div class="image-upload-wrapper" id="imageDropArea" title="Nhấn, kéo thả hoặc Ctrl+V để chọn ảnh">
                        <span class="plus-icon" id="plusIcon">+</span>
                        <input type="file" id="imageInput" accept="image/*" style="display:none;">
                        <img id="previewImage" />
                    </div>
                    <input type="hidden" name="imageURL" id="imageURL">
                </div>

                <div class="mb-3">
                    <label class="form-label">Hướng dẫn bảo quản:</label>
                    <input type="text" name="storageInstructions" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Giá:</label>
                    <input type="number" step="0.01" name="price" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Danh mục:</label>
                    <select name="categoryID" class="form-select" required>
                        <option value="1">Món chính</option>
                        <option value="2">Món phụ</option>
                        <option value="3">Tráng miệng</option>
                        <option value="4">Đồ uống</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-submit">Thêm món</button>
            </form>
        </div>

        <script src="js/addProductSeller_script.js"></script>


    </body>
</html>
