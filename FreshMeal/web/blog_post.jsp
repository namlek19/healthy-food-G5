<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setAttribute("currentPage", "blogpost");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng bài viết mới</title>
        
       <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="assets/css/blog.css">
        <link rel="stylesheet" href="assets/css/blog_post.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"/>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    </head>
    
    <body>
        <%@ include file="sidebar.jsp" %>

        <div class="blog-form-container">
            <div class="blog-form-title">Đăng bài viết mới</div>
            <form action="blogpost" method="post" autocomplete="off">
                <label class="blog-form-label" for="title">Tiêu đề:</label>
                <textarea class="blog-form-input" name="title" id="title" rows="2" required style="resize: vertical;"></textarea>

                <label class="blog-form-label" for="description">Nội dung:</label>
                <textarea class="blog-form-textarea" name="description" id="description" rows="7" required></textarea>

                <label class="blog-form-label">Ảnh bài viết:</label>
                <div class="image-upload-wrapper" id="imageDropArea" title="Nhấn, kéo thả hoặc Ctrl+V để chọn ảnh">
                    <span class="plus-icon" id="plusIcon">+</span>
                    <input type="file" id="imageInput" accept="image/*" style="display:none;">
                    <img id="previewImage" style="display:none;" />
                </div>
                <input type="hidden" name="imageURL" id="imageURL">

                <button type="submit" class="blog-form-btn">Đăng bài</button>
            </form>
            <a href="blog" class="blog-form-back">Quay lại danh sách bài viết</a>
        </div>

        <script>
            const imageInput = document.getElementById('imageInput');
            const imageDropArea = document.getElementById('imageDropArea');
            const plusIcon = document.getElementById('plusIcon');
            const previewImage = document.getElementById('previewImage');
            const imageURLInput = document.getElementById('imageURL');

            imageDropArea.addEventListener('click', () => imageInput.click());

            imageInput.addEventListener('change', function () {
                if (imageInput.files && imageInput.files[0])
                    resizeAndConvert(imageInput.files[0], 900, setPreviewImage);
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
                if (e.dataTransfer.files && e.dataTransfer.files[0])
                    resizeAndConvert(e.dataTransfer.files[0], 900, setPreviewImage);
            });

            document.addEventListener('paste', function (e) {
                const items = (e.clipboardData || window.clipboardData).items;
                for (let item of items) {
                    if (item.type.indexOf('image') !== -1)
                        resizeAndConvert(item.getAsFile(), 900, setPreviewImage);
                }
            });

            function setPreviewImage(dataURL) {
                plusIcon.style.display = 'none';
                previewImage.src = dataURL;
                previewImage.style.display = 'block';
                imageURLInput.value = dataURL;
            }

            function resizeAndConvert(file, maxWidth = 900, callback) {
                const reader = new FileReader();
                reader.onload = function (e) {
                    const img = new Image();
                    img.onload = function () {
                        let canvas = document.createElement('canvas');
                        let scale = Math.min(maxWidth / img.width, 1);
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
