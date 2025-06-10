<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <style>
        .image-upload-wrapper {
            width: 200px;
            height: 150px;
            border: 2px dashed #bbb;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            position: relative;
            background: #fafbfc;
            margin-bottom: 8px;
            transition: border-color 0.3s;
        }
        .image-upload-wrapper:hover {
            border-color: #3399ff;
        }
        .plus-icon {
            font-size: 48px;
            color: #bbb;
            user-select: none;
            transition: color 0.3s;
        }
        .image-upload-wrapper.dragover {
            border-color: #3399ff;
            background: #e6f0ff;
        }
    </style>

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
            <div class="image-upload-wrapper" id="imageDropArea">
                <span class="plus-icon" id="plusIcon">+</span>
                <input type="file" id="imageInput" accept="image/*" style="display:none;">
                <img id="previewImage" style="display:none;max-width:200px;max-height:150px;border-radius:10px;" />
            </div>
            <input type="hidden" name="imageURL" id="imageURL">
            <br>
            <!-- Nếu muốn upload file thực, cần thêm input type="file" và xử lý upload -->
            <br>
            <button type="submit">Đăng bài</button>
        </form>
        <br>
        <a href="blog">Quay lại danh sách bài viết</a>
    </body>
</html>

<script>
const imageInput = document.getElementById('imageInput');
const imageDropArea = document.getElementById('imageDropArea');
const plusIcon = document.getElementById('plusIcon');
const previewImage = document.getElementById('previewImage');
const imageURLInput = document.getElementById('imageURL');

// Bấm vào ô dấu cộng để chọn ảnh
imageDropArea.addEventListener('click', () => {
    imageInput.click();
});

// Chọn file
imageInput.addEventListener('change', function() {
    if (imageInput.files && imageInput.files[0]) {
        previewLocalImage(imageInput.files[0]);
    }
});

// Xử lý kéo thả
imageDropArea.addEventListener('dragover', e => {
    e.preventDefault();
    imageDropArea.classList.add('dragover');
});
imageDropArea.addEventListener('dragleave', e => {
    e.preventDefault();
    imageDropArea.classList.remove('dragover');
});
imageDropArea.addEventListener('drop', function(e) {
    e.preventDefault();
    imageDropArea.classList.remove('dragover');
    if (e.dataTransfer.files && e.dataTransfer.files[0]) {
        previewLocalImage(e.dataTransfer.files[0]);
    }
});

// Xử lý dán ảnh (Ctrl+V)
document.addEventListener('paste', function(e) {
    const items = (e.clipboardData || window.clipboardData).items;
    for (let item of items) {
        if (item.type.indexOf('image') !== -1) {
            const file = item.getAsFile();
            previewLocalImage(file);
        }
    }
});

function previewLocalImage(file) {
    plusIcon.style.display = 'none';
    previewImage.style.display = 'none';
    previewImage.src = '';
    imageDropArea.innerHTML = "Đang xử lý ảnh...";

    const reader = new FileReader();
    reader.onload = function(e) {
        imageDropArea.innerHTML = "";
        previewImage.src = e.target.result;
        previewImage.style.display = 'block';
        imageDropArea.appendChild(previewImage);
        imageURLInput.value = e.target.result; // base64 của ảnh, nếu cần gửi lên server thì dùng cái này!
    };
    reader.readAsDataURL(file);
}
</script>
