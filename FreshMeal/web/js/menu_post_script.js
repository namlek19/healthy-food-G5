let selectedProducts = [];
let selectedProductInfo = {}; // {productID: {name, img, calo, price}}
function selectProduct(id, name, img, calo, price) {
    id = Number(id);
    if (!selectedProducts.includes(id)) {

        // Xử lý an toàn cho giá trị calories
        let finalCalo = Number(calo);
        if (isNaN(finalCalo)) {
            finalCalo = 0;
        }

        selectedProducts.push(id);
        selectedProductInfo[id] = {
            name: name,
            img: img,
            calo: finalCalo,
            price: Number(price)
        };
        renderSelectedTable();
        document.getElementById('btnSelect' + id).disabled = true;
    }
}
function removeProduct(id) {
    id = Number(id);
    selectedProducts = selectedProducts.filter(x => x != id);
    delete selectedProductInfo[id];
    renderSelectedTable();
    let btn = document.getElementById('btnSelect' + id);
    if (btn)
        btn.disabled = false;
}
function renderSelectedTable() {
    let body = document.getElementById('selectedProductsTableBody');
    body.innerHTML = '';
    if (selectedProducts.length === 0) {
        body.innerHTML = `<tr id="noSelectedRow"><td colspan="5" class="text-secondary">Chưa chọn món nào!</td></tr>`;
    } else {
        selectedProducts.forEach((id, index) => {
            let p = selectedProductInfo[id];
            if (!p)
                return;
            let newRow = body.insertRow();
            let cellIndex = newRow.insertCell(0);
            cellIndex.textContent = index + 1;
            cellIndex.style.fontWeight = 'bold';
            let cellName = newRow.insertCell(1);
            cellName.textContent = p.name;
            let cellCalo = newRow.insertCell(2);
            cellCalo.textContent = p.calo + " kcal";
            let cellPrice = newRow.insertCell(3);
            let price = Number(p.price);
            let priceStr = (isNaN(price) ? '0' : price.toLocaleString('vi-VN')) + " VNĐ";
            cellPrice.textContent = priceStr;
            let cellRemove = newRow.insertCell(4);
            let removeButton = document.createElement('button');
            removeButton.type = 'button';
            removeButton.className = 'btn btn-danger btn-sm';
            removeButton.textContent = 'X';
            removeButton.onclick = function () {
                removeProduct(id);
            };
            cellRemove.appendChild(removeButton);
        });
    }

    document.getElementById('selectedProductIDs').value = selectedProducts.join(',');
}

// Cloudinary config
const CLOUDINARY_URL = 'https://api.cloudinary.com/v1_1/haduyhungpro123/upload';
const CLOUDINARY_UPLOAD_PRESET = 'Menu_post';

// Xử lý upload ảnh menu giống Cloudinary
const menuImageInput = document.getElementById('menuImageInput');
const menuImageDropArea = document.getElementById('menuImageDropArea');
const menuPlusIcon = document.getElementById('menuPlusIcon');
const menuPreviewImage = document.getElementById('menuPreviewImage');
const menuImageURLInput = document.getElementById('menuImageURL');

// Chọn ảnh từ máy
menuImageDropArea.addEventListener('click', () => menuImageInput.click());

menuImageInput.addEventListener('change', function () {
    if (menuImageInput.files && menuImageInput.files[0]) {
        uploadImageToCloudinary(menuImageInput.files[0], setMenuPreviewImage);
    }
});

// Kéo thả file
menuImageDropArea.addEventListener('dragover', e => {
    e.preventDefault();
    menuImageDropArea.classList.add('dragover');
});
menuImageDropArea.addEventListener('dragleave', e => {
    e.preventDefault();
    menuImageDropArea.classList.remove('dragover');
});
menuImageDropArea.addEventListener('drop', function (e) {
    e.preventDefault();
    menuImageDropArea.classList.remove('dragover');
    if (e.dataTransfer.files && e.dataTransfer.files[0]) {
        uploadImageToCloudinary(e.dataTransfer.files[0], setMenuPreviewImage);
    }
});

// Ctrl+V để dán ảnh
document.addEventListener('paste', function (e) {
    const items = (e.clipboardData || window.clipboardData).items;
    for (let item of items) {
        if (item.type.indexOf('image') !== -1) {
            let file = item.getAsFile();
            uploadImageToCloudinary(file, setMenuPreviewImage);
        }
    }
});

// Hàm upload lên Cloudinary
function uploadImageToCloudinary(file, callback) {
    let formData = new FormData();
    formData.append('file', file);
    formData.append('upload_preset', CLOUDINARY_UPLOAD_PRESET);

    fetch(CLOUDINARY_URL, {
        method: 'POST',
        body: formData
    })
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

// Hiển thị ảnh preview & lưu URL vào input hidden
function setMenuPreviewImage(url) {
    menuPlusIcon.style.display = 'none';
    menuPreviewImage.src = url;
    menuPreviewImage.style.display = 'block';
    menuImageURLInput.value = url;
}
