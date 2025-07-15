 // Cloudinary config
            const CLOUDINARY_URL = 'https://api.cloudinary.com/v1_1/haduyhungpro123/upload';
            const CLOUDINARY_UPLOAD_PRESET = 'Menu_post';

            const imageInput = document.getElementById('imageInput');
            const imageDropArea = document.getElementById('imageDropArea');
            const plusIcon = document.getElementById('plusIcon');
            const previewImage = document.getElementById('previewImage');
            const imageURLInput = document.getElementById('imageURL');

            // Chọn ảnh từ máy
            imageDropArea.addEventListener('click', () => imageInput.click());

            imageInput.addEventListener('change', function () {
                if (imageInput.files && imageInput.files[0]) {
                    uploadImageToCloudinary(imageInput.files[0], setPreviewImage);
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
                    uploadImageToCloudinary(e.dataTransfer.files[0], setPreviewImage);
                }
            });

            // Ctrl+V để dán ảnh
            document.addEventListener('paste', function (e) {
                const items = (e.clipboardData || window.clipboardData).items;
                for (let item of items) {
                    if (item.type.indexOf('image') !== -1) {
                        let file = item.getAsFile();
                        uploadImageToCloudinary(file, setPreviewImage);
                    }
                }
            });

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

            function setPreviewImage(url) {
                plusIcon.style.display = 'none';
                previewImage.src = url;
                previewImage.style.display = 'block';
                imageURLInput.value = url;
            }