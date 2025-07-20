const imageDropArea = document.getElementById('imageDropArea');
const imageInput = document.getElementById('imageInput');
const previewImage = document.getElementById('previewImage');
const plusIcon = document.getElementById('plusIcon');
const imageURLInput = document.getElementById('imageURL');

// Click để mở file
imageDropArea.addEventListener('click', () => imageInput.click());

// Chọn file
imageInput.addEventListener('change', e => handleFile(e.target.files[0]));

// Kéo thả
imageDropArea.addEventListener('dragover', e => {
    e.preventDefault();
    imageDropArea.classList.add('dragover');
});
imageDropArea.addEventListener('dragleave', () => imageDropArea.classList.remove('dragover'));
imageDropArea.addEventListener('drop', e => {
    e.preventDefault();
    imageDropArea.classList.remove('dragover');
    if (e.dataTransfer.files.length)
        handleFile(e.dataTransfer.files[0]);
});

// Ctrl+V paste
document.addEventListener('paste', e => {
    if (e.clipboardData.files.length)
        handleFile(e.clipboardData.files[0]);
});

function handleFile(file) {
    if (!file.type.startsWith('image/'))
        return;
    const reader = new FileReader();
    reader.onload = e => {
        previewImage.src = e.target.result;
        previewImage.style.display = 'block';
        plusIcon.style.display = 'none';
        imageURLInput.value = e.target.result; // base64
    };
    reader.readAsDataURL(file);
}