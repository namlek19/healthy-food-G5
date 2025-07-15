<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Đăng Thực Đơn Mới</title>
        <link rel="stylesheet" href="assets/css/blog.css">
        <link rel="stylesheet" href="assets/css/menu_post.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    </head>
    <body style="background: #f0f7f4;">
        <%@ include file="sidebar.jsp" %>
        <div class="main-container">

            <h2 class="text-success mb-4" style="font-weight:700;">Tạo Thực Đơn Mới</h2>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                    ${errorMessage}
                </div>
            </c:if>

            <form action="menupost" method="post" id="menuForm">
                <div class="mb-4">
                    <div class="card p-3 shadow-sm">
                        <h5 class="fw-bold mb-3">Các món đã chọn</h5>
                        <table class="table selected-products-table align-middle">
                            <thead>
                                <tr class="table-success">
                                    <th style="width: 5%;">STT</th>
                                    <th>Tên món</th>
                                    <th>Calories</th>
                                    <th>Giá</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id="selectedProductsTableBody">
                                <tr id="noSelectedRow"><td colspan="5" class="text-secondary">Chưa chọn món nào!</td></tr>
                            </tbody>
                        </table>
                        <input type="hidden" name="selectedProductIDs" id="selectedProductIDs">
                    </div>
                </div>

                <div class="card p-4 mb-4 shadow-sm">
                    <div class="row mb-3">
                        <div class="col-md-6 mb-2">
                            <label class="form-label fw-bold">Tên thực đơn</label>
                            <input class="form-control" name="menuName" required maxlength="60">
                        </div>
                        <div class="col-md-6 mb-2">
                            <label class="form-label fw-bold">Nhóm BMI phù hợp</label>
                            <select class="form-select" name="bmiCategory" required>
                                <option value="">Chọn nhóm BMI</option>
                                <option value="Underweight">Gầy (Underweight)</option>
                                <option value="Normal">Bình thường (Normal)</option>
                                <option value="Overweight">Thừa cân (Overweight)</option>
                                <option value="Obese">Béo phì (Obese)</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Mô tả thực đơn</label>
                        <textarea class="form-control" name="description" rows="3" maxlength="300" required></textarea>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Ảnh thực đơn</label>
                        <div class="image-upload-wrapper" id="menuImageDropArea" title="Nhấn, kéo thả hoặc Ctrl+V để chọn ảnh">
                            <span class="plus-icon" id="menuPlusIcon">+</span>
                            <input type="file" id="menuImageInput" accept="image/*" style="display:none;">
                            <img id="menuPreviewImage" style="display:none; max-width:160px; max-height:160px; border-radius:8px; margin-top:5px;" />
                        </div>
                        <input type="hidden" name="imageURL" id="menuImageURL">
                    </div>

                    <button type="submit" class="btn btn-success btn-lg w-100 mt-2 fw-bold" style="font-size:1.15em;">
                        Đăng Thực Đơn
                    </button>
                </div>
            </form>

            <div class="mt-4">
                <h4 class="mb-3 fw-bold text-success">Chọn món từ danh sách HealthyFood</h4>
                <div class="row">
                    <c:forEach var="p" items="${productList}">
                        <div class="col-md-3 mb-3 d-flex">
                            <div class="product-card w-100 d-flex flex-column justify-content-between">
                                <img src="${p.imageURL}" alt="${p.name}">
                                <div class="fw-bold">${p.name}</div>
                                <div class="small text-secondary mb-1">
                                    ${p.calories} kcal | 
                                    <span class="text-success">
                                        <fmt:formatNumber value="${p.price}" type="number"/> VNĐ
                                    </span>
                                </div>
                                <button type="button"
                                        onclick="selectProduct(
                                        ${p.productID},
                                                        '${fn:replace(p.name, "'", "\\'")}',
                                                        '${fn:replace(p.imageURL, "'", "\\'")}',
                                        ${p.calories},
                                        ${p.price})"
                                        id="btnSelect${p.productID}">
                                    Chọn
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>


        <script src="js/menu_post_script.js"></script>
        
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function getParam(name) {
        return new URLSearchParams(window.location.search).get(name);
    }

    if (getParam('success') === 'true') {
        const toastEl = document.createElement('div');
        toastEl.className = 'toast align-items-center text-bg-success border-0 position-fixed top-0 end-0 m-3';
        toastEl.setAttribute('role', 'alert');
        toastEl.setAttribute('aria-live', 'assertive');
        toastEl.setAttribute('aria-atomic', 'true');
        toastEl.innerHTML = `
            <div class="d-flex">
                <div class="toast-body">
                     Đăng thực đơn thành công!
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>`;
        document.body.appendChild(toastEl);
        const toast = new bootstrap.Toast(toastEl);
        toast.show();
    }
</script>


    </body>
</html>