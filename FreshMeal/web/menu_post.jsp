<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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

    <!-- Bảng món đã chọn (hiện ở trên cùng) -->
    <form action="menupost" method="post" id="menuForm">
        <div class="mb-4">
            <div class="card p-3 shadow-sm">
                <h5 class="fw-bold mb-3">Các món đã chọn</h5>
                <table class="table selected-products-table align-middle">
                    <thead>
                        <tr class="table-success">
                            <th>Ảnh</th>
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
                <!-- Mảng lưu các ID món đã chọn (sẽ submit) -->
                <input type="hidden" name="selectedProductIDs" id="selectedProductIDs">
            </div>
        </div>

        <!-- Thông tin thực đơn -->
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
                <label class="form-label fw-bold">Ảnh thực đơn (URL hoặc upload sau)</label>
                <input class="form-control" name="imageURL" placeholder="https://...">
            </div>
            <button type="submit" class="btn btn-success btn-lg w-100 mt-2 fw-bold" style="font-size:1.15em;">
                Đăng Thực Đơn
            </button>
        </div>
    </form>

    <!-- Danh sách món ăn/đồ uống -->
    <div class="mt-4">
        <h4 class="mb-3 fw-bold text-success">Chọn món từ danh sách HealthyFood</h4>
        <div class="row">
            <c:forEach var="p" items="${productList}">
                <div class="col-md-3 mb-3 d-flex">
                    <div class="product-card w-100 d-flex flex-column justify-content-between">
                        <img src="${p.imageURL}" alt="${p.name}">
                        <div class="fw-bold">${p.name}</div>
                        <div class="small text-secondary mb-1">${p.calories} kcal | <span class="text-success"><fmt:formatNumber value="${p.price}" type="number"/> VNĐ</span></div>
                        <button type="button" onclick="selectProduct(${p.productID}, '${p.name.replace("'", "\\'")}', '${p.imageURL}', ${p.calories}, ${p.price})" id="btnSelect${p.productID}">
                            Chọn
                        </button>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<!-- Script quản lý chọn/xóa món -->
<script>
    let selectedProducts = [];
    let selectedProductInfo = {}; // {productID: {name, image, calories, price}}
    function selectProduct(id, name, img, calo, price) {
        if (!selectedProducts.includes(id)) {
            selectedProducts.push(id);
            selectedProductInfo[id] = { name, img, calo, price };
            renderSelectedTable();
            document.getElementById('btnSelect' + id).disabled = true;
        }
    }
    function removeProduct(id) {
        selectedProducts = selectedProducts.filter(x => x != id);
        delete selectedProductInfo[id];
        renderSelectedTable();
        let btn = document.getElementById('btnSelect' + id);
        if (btn) btn.disabled = false;
    }
    function renderSelectedTable() {
        let body = document.getElementById('selectedProductsTableBody');
        body.innerHTML = '';
        if (selectedProducts.length === 0) {
            body.innerHTML = `<tr id="noSelectedRow"><td colspan="5" class="text-secondary">Chưa chọn món nào!</td></tr>`;
        } else {
            selectedProducts.forEach(id => {
                let p = selectedProductInfo[id];
                body.innerHTML += `
                    <tr>
                        <td><img src="${p.img}" alt=""></td>
                        <td>${p.name}</td>
                        <td>${p.calo} kcal</td>
                        <td>${p.price.toLocaleString()} VNĐ</td>
                        <td><button type="button" class="btn btn-danger btn-sm" onclick="removeProduct(${id})">X</button></td>
                    </tr>`;
            });
        }
        // update hidden field
        document.getElementById('selectedProductIDs').value = selectedProducts.join(',');
    }
    // Nếu submit mà chưa chọn món thì báo lỗi
    document.getElementById('menuForm').onsubmit = function() {
        if (selectedProducts.length === 0) {
            alert('Vui lòng chọn ít nhất 1 món cho thực đơn!');
            return false;
        }
        return true;
    }
</script>
</body>
</html>
