<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <title>Chỉnh sửa Blog</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/blog.css">
        <link rel="stylesheet" href="assets/css/editBlog.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        
    </head>
    <body>

        <%@ include file="sidebar.jsp" %>

        <div class="main-container">
            <h2>Chỉnh sửa bài Blog</h2>

            <c:if test="${not empty blog}">
                <form action="blog" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" value="${blog.blogID}">

                    <label for="title">Tiêu đề:</label>
                    <textarea id="title" name="title" rows="3" required style="resize: vertical;">${blog.title}</textarea>

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

            <p style="margin-top: 20px;"><a href="blogmanage">Quay lại danh sách</a></p>
        </div>

        <script>
            const imageInput = document.getElementById('imageInput');
            const imageDropArea = document.getElementById('imageDropArea');
            const plusIcon = document.getElementById('plusIcon');
            const previewImage = document.getElementById('previewImage');
            const imageURLInput = document.getElementById('imageURL');


            imageDropArea.addEventListener('click', () => {
                imageInput.click();
            });


            imageInput.addEventListener('change', function () {
                if (imageInput.files && imageInput.files[0]) {
                    resizeAndConvert(imageInput.files[0], 900, function (dataURL) {
                        plusIcon.style.display = 'none';
                        previewImage.src = dataURL;
                        previewImage.style.display = 'block';
                        imageURLInput.value = dataURL;
                    });
                }
            });


            imageDropArea.addEventListener('dragover', e => {
                e.preventDefault();
                imageDropArea.classList.add('dragover');
            });
            imageDropArea.addEventListener('dragleave', e => {
                e.preventDefault();
                imageDropArea.classList.remove('dragover');
            });
            imageDropArea.addEventListener('drop', function (e) {
                e.preventDefault();
                imageDropArea.classList.remove('dragover');
                if (e.dataTransfer.files && e.dataTransfer.files[0]) {
                    resizeAndConvert(e.dataTransfer.files[0], 900, function (dataURL) {
                        plusIcon.style.display = 'none';
                        previewImage.src = dataURL;
                        previewImage.style.display = 'block';
                        imageURLInput.value = dataURL;
                    });
                }
            });


            document.addEventListener('paste', function (e) {
                const items = (e.clipboardData || window.clipboardData).items;
                for (let item of items) {
                    if (item.type.indexOf('image') !== -1) {
                        const file = item.getAsFile();
                        resizeAndConvert(file, 900, function (dataURL) {
                            plusIcon.style.display = 'none';
                            previewImage.src = dataURL;
                            previewImage.style.display = 'block';
                            imageURLInput.value = dataURL;
                        });
                    }
                }
            });


            function resizeAndConvert(file, maxWidth = 900, callback) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    const img = new Image();
                    img.onload = function () {
                        let canvas = document.createElement('canvas');
                        let scale = Math.min(maxWidth / img.width, 1); // chỉ scale nếu ảnh lớn
                        canvas.width = img.width * scale;
                        canvas.height = img.height * scale;
                        let ctx = canvas.getContext('2d');
                        ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
                        let dataURL = canvas.toDataURL('image/jpeg', 0.85);
                        callback(dataURL);
                    };
                    img.src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        </script>

    </body>
</html>