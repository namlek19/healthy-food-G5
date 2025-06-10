<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Chỉnh sửa Blog</title>
    <style>
        form { max-width: 600px; margin: 20px auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; }
        label { display: block; margin-bottom: 8px; }
        input[type="text"], textarea { width: 100%; padding: 8px; margin-bottom: 10px; border: 1px solid #ccc; border-radius: 4px; }
        button { padding: 10px 15px; background-color: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; }
        a { text-decoration: none; color: #337ab7; }
        .image-upload-wrapper {
            width: 200px; height: 150px; border: 2px dashed #bbb;
            border-radius: 10px; display: flex; align-items: center; justify-content: center;
            cursor: pointer; position: relative; background: #fafbfc; margin-bottom: 8px;
            transition: border-color 0.3s;
        }
        .plus-icon { font-size: 48px; color: #bbb; user-select: none; transition: color 0.3s; }
        .image-upload-wrapper.dragover { border-color: #3399ff; background: #e6f0ff; }
        #previewImage { display: block; max-width:200px;max-height:150px;border-radius:10px; }
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

            <label>Ảnh bài viết:</label>
            <div class="image-upload-wrapper" id="imageDropArea" title="Click, kéo thả hoặc Ctrl+V ảnh">
                <span class="plus-icon" id="plusIcon" style="${empty blog.imageURL ? '' : 'display:none;'}">+</span>
                <input type="file" id="imageInput" accept="image/*" style="display:none;">
                <img id="previewImage" src="${blog.imageURL}" style="${empty blog.imageURL ? 'display:none;' : ''}" />
            </div>
            <input type="hidden" name="imageURL" id="imageURL" value="${blog.imageURL}">
            
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
<script>
const imageInput = document.getElementById('imageInput');
const imageDropArea = document.getElementById('imageDropArea');
const plusIcon = document.getElementById('plusIcon');
const previewImage = document.getElementById('previewImage');
const imageURLInput = document.getElementById('imageURL');

imageDropArea.addEventListener('click', () => imageInput.click());
imageInput.addEventListener('change', function() {
    if (imageInput.files && imageInput.files[0]) previewLocalImage(imageInput.files[0]);
});
imageDropArea.addEventListener('dragover', e => {
    e.preventDefault(); imageDropArea.classList.add('dragover');
});
imageDropArea.addEventListener('dragleave', e => {
    e.preventDefault(); imageDropArea.classList.remove('dragover');
});
imageDropArea.addEventListener('drop', function(e) {
    e.preventDefault(); imageDropArea.classList.remove('dragover');
    if (e.dataTransfer.files && e.dataTransfer.files[0]) previewLocalImage(e.dataTransfer.files[0]);
});
document.addEventListener('paste', function(e) {
    const items = (e.clipboardData || window.clipboardData).items;
    for (let item of items) {
        if (item.type.indexOf('image') !== -1) previewLocalImage(item.getAsFile());
    }
});
function previewLocalImage(file) {
    if(plusIcon) plusIcon.style.display = 'none';
    previewImage.style.display = 'none';
    previewImage.src = '';
    imageDropArea.innerHTML = "Đang xử lý ảnh...";
    const reader = new FileReader();
    reader.onload = function(e) {
        imageDropArea.innerHTML = "";
        previewImage.src = e.target.result;
        previewImage.style.display = 'block';
        imageDropArea.appendChild(previewImage);
        imageURLInput.value = e.target.result;
    };
    reader.readAsDataURL(file);
}
</script>
</html>
