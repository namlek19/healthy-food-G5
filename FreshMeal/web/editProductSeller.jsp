<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Chỉnh sửa món</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/editProductSeller.css">
    </head>
    <body>

        <jsp:include page="includes/sidebarSeller.jsp" />

        <div class="form-container">
            <h2>Chỉnh sửa món</h2>
            <form action="editProductSeller" method="post">
                <input type="hidden" name="productID" value="${product.productID}" />

                <div class="mb-3">
                    <label class="form-label">Tên món:</label>
                    <input type="text" name="name" class="form-control" value="${product.name}" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Mô tả:</label>
                    <textarea name="description" class="form-control" required>${product.description}</textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Calories:</label>
                    <input type="number" name="calories" class="form-control" value="${product.calories}" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Thông tin dinh dưỡng:</label>
                    <textarea name="nutritionInfo" class="form-control" required>${product.nutritionInfo}</textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Nguồn gốc:</label>
                    <input type="text" name="origin" class="form-control" value="${product.origin}" required />
                </div>

                <div class="mb-3">
                    <label class="form-label">Ảnh món:</label>
                    <div class="image-upload-wrapper" id="imageDropArea" title="Nhấn, kéo thả hoặc Ctrl+V để thay ảnh">
                        <span class="plus-icon" id="plusIcon">+</span>
                        <input type="file" id="imageInput" accept="image/*" style="display:none;">
                        <img id="previewImage" 
                             src="${product.imageURL}" 
                             style="${empty product.imageURL ? 'display:none;' : 'display:block;'}" />
                    </div>
                    <input type="hidden" name="imageURL" id="imageURL" value="${product.imageURL}">
                </div>

                <div class="mb-3">
                    <label class="form-label">Hướng dẫn bảo quản:</label>
                    <input type="text" name="storageInstructions" class="form-control" value="${product.storageInstructions}" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Giá:</label>
                    <input type="number" step="0.01" name="price" class="form-control" value="${product.price}" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Danh mục:</label>
                    <select name="categoryID" class="form-select" required>
                        <option value="1" ${product.categoryID == 1 ? 'selected' : ''}>Món chính</option>
                        <option value="2" ${product.categoryID == 2 ? 'selected' : ''}>Món phụ</option>
                        <option value="3" ${product.categoryID == 3 ? 'selected' : ''}>Tráng miệng</option>
                        <option value="4" ${product.categoryID == 4 ? 'selected' : ''}>Đồ uống</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-submit">Cập nhật món</button>
            </form>
        </div>

        <script src="js/editProductSeller_script.js"></script>


    </body>
</html>
