<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setAttribute("currentPage", "blogpost");
%>
<link rel="stylesheet" href="assets/css/blog.css">
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đăng bài viết mới</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <style>
            /* --- Bắt đầu CSS từ blog.jsp --- */
            body {
                font-family: Arial, sans-serif;
                background-color: #f0f2f5;
                margin: 0;
                display: flex;
            }

            .main-container {
                flex: 1;
                padding: 20px;
                display: flex;
                flex-direction: column;
                align-items: center;
                margin-left: 220px;
                padding: 20px;
                background-color: #BEF0CF;
            }

            /* CSS gốc của blog_post.jsp cho phần upload ảnh */
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

            /* === KHU VỰC ĐÃ SỬA === */
            .main-container form {
                background-color: #ffffff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                max-width: 700px;
                width: 100%;
                text-align: left; /* Căn trái lại nội dung trong form */
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
                <li>
                    <a href="${pageContext.request.contextPath}/blog"
                       class="<c:if test='${currentPage eq "bloglist"}'>active</c:if>">
                        Blog List
                    </a>
                </li>
                <li>
                    <a href="blogpost"
                       class="${currentPage eq 'blogpost' ? 'active' : ''}">
                        Blog Post
                    </a>

                </li>
                <li>
                    <a href="blogmanage"
                       class="<c:if test='${currentPage eq "blogmanage"}'>active</c:if>">
                        Blog Manage
                    </a>
                </li>
            </ul>

            <h2>MENU</h2>
            <ul>
                <li><a href="#">Menu List</a></li>
                <li><a href="#">Menu Post</a></li>
                <li><a href="#">Menu Manage</a></li>
            </ul>
            
            <!-- Thêm nút logout ở đây -->
                <ul>
                    <li>
                        <a href="${pageContext.request.contextPath}/login?action=logout" style="color:red;">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </a>
                </li>
            </ul>
        </div>

        <div class="main-container">
            <h2>Đăng bài viết mới</h2>
            <form action="blogpost" method="post">
                <label>Tiêu đề:</label><br>
                <textarea name="title" rows="3" required style="width: 98%; padding: 8px; margin-bottom: 10px; resize: vertical;"></textarea><br><br>

                <label>Nội dung:</label><br>
                <textarea name="description" rows="10" required style="width: 98%; padding: 8px; margin-bottom: 10px;"></textarea><br><br>

                <label>Ảnh bài viết:</label><br>
                <div class="image-upload-wrapper" id="imageDropArea">
                    <span class="plus-icon" id="plusIcon">+</span>
                    <input type="file" id="imageInput" accept="image/*" style="display:none;">
                    <img id="previewImage" style="display:none;max-width:200px;max-height:150px;border-radius:10px;" />
                </div>
                <input type="hidden" name="imageURL" id="imageURL">
                <br>
                <button type="submit">Đăng bài</button>
            </form>
            <br>
            <a href="blog">Quay lại danh sách bài viết</a>
        </div>

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
imageInput.addEventListener('change', function () {
    if (imageInput.files && imageInput.files[0]) {
        resizeAndConvert(imageInput.files[0], 900, function(dataURL) {
            plusIcon.style.display = 'none';
            previewImage.src = dataURL;
            previewImage.style.display = 'block';
            imageURLInput.value = dataURL; // base64 đã resize
        });
    }
});

// Kéo thả file
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
        resizeAndConvert(e.dataTransfer.files[0], 900, function(dataURL) {
            plusIcon.style.display = 'none';
            previewImage.src = dataURL;
            previewImage.style.display = 'block';
            imageURLInput.value = dataURL;
        });
    }
});

// Dán ảnh (Ctrl+V)
document.addEventListener('paste', function (e) {
    const items = (e.clipboardData || window.clipboardData).items;
    for (let item of items) {
        if (item.type.indexOf('image') !== -1) {
            const file = item.getAsFile();
            resizeAndConvert(file, 900, function(dataURL) {
                plusIcon.style.display = 'none';
                previewImage.src = dataURL;
                previewImage.style.display = 'block';
                imageURLInput.value = dataURL;
            });
        }
    }
});

// Hàm resize
function resizeAndConvert(file, maxWidth = 900, callback) {
    const reader = new FileReader();
    reader.onload = function(e) {
        const img = new Image();
        img.onload = function() {
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