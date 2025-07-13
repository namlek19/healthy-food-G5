// request_edit_menu_script.js
let selectedProducts = [];
let selectedProductInfo = {}; // {productID: {name, calo, price}}

// Hàm chọn món
function selectProduct(id, name, img, calo, price) {
    id = Number(id);
    if (!selectedProducts.includes(id)) {
        selectedProducts.push(id);
        selectedProductInfo[id] = {
            name: name,
            calo: Number(calo),
            price: Number(price)
        };
        renderSelectedTable();
        let btn = document.getElementById('btnSelect' + id);
        if (btn) btn.disabled = true;
    }
}

// Hàm xóa món
function removeProduct(id) {
    id = Number(id);
    selectedProducts = selectedProducts.filter(x => x !== id);
    delete selectedProductInfo[id];
    renderSelectedTable();
    let btn = document.getElementById('btnSelect' + id);
    if (btn) btn.disabled = false;
}

// Render bảng
function renderSelectedTable() {
    let tbody = document.getElementById('selectedProductsTableBody');
    tbody.innerHTML = '';
    selectedProducts.forEach((id, index) => {
        let p = selectedProductInfo[id];
        if (!p) return;
        let row = document.createElement('tr');
        row.id = 'row' + id;

        row.innerHTML = `
            <td>${index + 1}</td>
            <td>${p.name}</td>
            <td>${p.calo} kcal</td>
            <td>${p.price.toLocaleString('vi-VN')} VNĐ</td>
            <td>
                <button type="button" class="btn btn-sm btn-outline-danger" onclick="removeProduct(${id})">Xóa</button>
            </td>
        `;
        tbody.appendChild(row);
    });
    document.getElementById('selectedProductIDs').value = selectedProducts.join(',');
}

// Khởi tạo dữ liệu ban đầu (các món đã có sẵn trong menu)
document.addEventListener('DOMContentLoaded', () => {
    let idsStr = document.getElementById('selectedProductIDs').value;
    let ids = idsStr.split(',').filter(e => e !== '').map(x => parseInt(x));
    ids.forEach(id => {
        let row = document.getElementById('row' + id);
        if (row) {
            let name = row.children[1].innerText;
            let caloText = row.children[2].innerText.replace(' kcal','');
            let calo = parseInt(caloText);
            let priceText = row.children[3].innerText.replace(' VNĐ','').replace(/\./g,'').replace(/,/g,'');
            let price = parseInt(priceText);
            selectedProducts.push(id);
            selectedProductInfo[id] = { name, calo, price };
            let btn = document.getElementById('btnSelect' + id);
            if (btn) btn.disabled = true;
        }
    });
    renderSelectedTable();
});

// Cloudinary config (dùng chung)
const CLOUDINARY_URL = 'https://api.cloudinary.com/v1_1/haduyhungpro123/upload';
const CLOUDINARY_UPLOAD_PRESET = 'Menu_post';

// Lấy element
const editMenuImageInput = document.getElementById('editMenuImageInput');
const editMenuImageDropArea = document.getElementById('editMenuImageDropArea');
const editMenuPlusIcon = document.getElementById('editMenuPlusIcon');
const editMenuPreviewImage = document.getElementById('editMenuPreviewImage');
const editMenuImageURLInput = document.getElementById('editMenuImageURL');

// Nhấn click
editMenuImageDropArea.addEventListener('click', () => editMenuImageInput.click());

// Chọn từ folder
editMenuImageInput.addEventListener('change', function () {
    if (editMenuImageInput.files && editMenuImageInput.files[0]) {
        uploadImageToCloudinary(editMenuImageInput.files[0], setEditMenuPreviewImage);
    }
});

// Kéo thả
editMenuImageDropArea.addEventListener('dragover', e => {
    e.preventDefault();
    editMenuImageDropArea.classList.add('dragover');
});
editMenuImageDropArea.addEventListener('dragleave', e => {
    e.preventDefault();
    editMenuImageDropArea.classList.remove('dragover');
});
editMenuImageDropArea.addEventListener('drop', function (e) {
    e.preventDefault();
    editMenuImageDropArea.classList.remove('dragover');
    if (e.dataTransfer.files && e.dataTransfer.files[0]) {
        uploadImageToCloudinary(e.dataTransfer.files[0], setEditMenuPreviewImage);
    }
});

// Ctrl+V
document.addEventListener('paste', function (e) {
    const items = (e.clipboardData || window.clipboardData).items;
    for (let item of items) {
        if (item.type.indexOf('image') !== -1) {
            let file = item.getAsFile();
            uploadImageToCloudinary(file, setEditMenuPreviewImage);
        }
    }
});

// Upload
function uploadImageToCloudinary(file, callback) {
    let formData = new FormData();
    formData.append('file', file);
    formData.append('upload_preset', CLOUDINARY_UPLOAD_PRESET);

    fetch(CLOUDINARY_URL, { method: 'POST', body: formData })
        .then(r => r.json())
        .then(data => {
            if (data.secure_url) {
                callback(data.secure_url);
            } else {
                alert('Lỗi upload ảnh Cloudinary!');
            }
        })
        .catch(() => alert('Lỗi upload ảnh Cloudinary!'));
}

// Hiển thị preview
function setEditMenuPreviewImage(url) {
    editMenuPlusIcon.style.display = 'none';
    editMenuPreviewImage.src = url;
    editMenuPreviewImage.style.display = 'block';
    editMenuImageURLInput.value = url;
}

