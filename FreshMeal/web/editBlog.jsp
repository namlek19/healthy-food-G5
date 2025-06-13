<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Chỉnh sửa Blog</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <style>
            /* Bắt đầu khối CSS layout chung */
            body {
                font-family: Arial, sans-serif;
                background-color: #f0f2f5;
                margin: 0;
                display: flex;
            }
            .sidebar {
                background-color: #ffffff;
                padding: 20px;
                width: 220px;
                min-height: 100vh;
                border-right: 1px solid #ddd;
                box-sizing: border-box;
            }
            .sidebar h2 {
                margin-top: 0;
                color: #333;
                margin-bottom: 20px;
                font-size: 1.2em;
            }
            .sidebar ul {
                list-style: none;
                padding: 0;
                margin: 0;
                margin-bottom: 30px;
            }
            .sidebar ul li {
                margin-bottom: 10px;
            }
            .sidebar ul li a {
                display: block;
                padding: 10px 15px;
                text-decoration: none;
                color: #555;
                border-radius: 5px;
                transition: background-color 0.2s ease-in-out;
            }
            .sidebar ul li a.active,
            .sidebar ul li a:hover {
                background-color: #e9ecef;
                color: #000;
            }

            .main-container {
                flex: 1;
                padding: 20px;
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            /* CSS cho phần upload ảnh */
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
            #previewImage {
                display: block;
                max-width:200px;
                max-height:150px;
                border-radius:10px;
            }

            /* CSS cho Form */
            .main-container form {
                background-color: #ffffff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                max-width: 700px;
                width: 100%;
                text-align: left; /* Căn trái nội dung trong form */
            }

            /* CSS cho các input và button bên trong form */
            .main-container label {
                display: block;
                margin-bottom: 8px;
            }
            .main-container input[type="text"], .main-container textarea {
                width: 98%;
                padding: 8px;
                margin-bottom: 10px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            .main-container button {
                padding: 10px 15px;
                background-color: #4CAF50;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }
        </style>
    </head>
    <body>

        <div class="sidebar">
            <h2>BLOG</h2>
            <ul>
                <li><a href="${pageContext.request.contextPath}/blog" class="active">Blog List</a></li>
                <li><a href="blogpost">Blog Post</a></li>
            </ul>
            <h2>MENU</h2>
            <ul>
                <li><a href="#">Menu List</a></li>
                <li><a href="#">Menu Post</a></li>
            </ul>
        </div>

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

            <p style="margin-top: 20px;"><a href="blog">Quay lại danh sách</a></p>
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
                    previewLocalImage(imageInput.files[0]);
            });
            imageDropArea.addEventListener('dragover', e => {
                e.preventDefault();
                imageDropArea.classList.add('dragover');
            });
            imageDropArea.addEventListener('dragleave', e => {
                e.preventDefault();
                imageDropArea.classList.remove('dragleave');
            });
            imageDropArea.addEventListener('drop', function (e) {
                e.preventDefault();
                imageDropArea.classList.remove('dragleave');
                if (e.dataTransfer.files && e.dataTransfer.files[0])
                    previewLocalImage(e.dataTransfer.files[0]);
            });
            document.addEventListener('paste', function (e) {
                const items = (e.clipboardData || window.clipboardData).items;
                for (let item of items) {
                    if (item.type.indexOf('image') !== -1)
                        previewLocalImage(item.getAsFile());
                }
            });
            function previewLocalImage(file) {
                if (plusIcon)
                    plusIcon.style.display = 'none';

                // Cần xóa và tạo lại ảnh preview để tránh lỗi
                let currentPreview = document.getElementById('previewImage');
                if (currentPreview)
                    currentPreview.remove();

                const newPreview = document.createElement('img');
                newPreview.id = 'previewImage';
                imageDropArea.appendChild(newPreview);

                imageDropArea.innerHTML = "Đang xử lý ảnh...";
                const reader = new FileReader();
                reader.onload = function (e) {
                    imageDropArea.innerHTML = "";
                    newPreview.src = e.target.result;
                    imageDropArea.appendChild(newPreview);
                    imageURLInput.value = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        </script>
    </body>
</html>