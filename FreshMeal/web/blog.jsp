<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách Blog</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
        }
        .post-container {
            position: relative; /* Quan trọng để định vị menu 3 chấm */
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            margin: 20px auto;
            padding: 20px;
            max-width: 600px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .post-actions {
            position: absolute;
            top: 15px;
            right: 15px;
        }
        .menu-button {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            padding: 5px;
            line-height: 1;
        }
        .dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            background-color: white;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
            border-radius: 5px;
            overflow: hidden;
        }
        /* Style cho các mục trong dropdown */
        .dropdown-content a, .dropdown-content button {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            text-align: left;
            width: 100%;
            border: none;
            background: none;
            cursor: pointer;
        }
        .dropdown-content a:hover, .dropdown-content button:hover {
            background-color: #f1f1f1;
        }
        /* Lớp .show được thêm bởi JavaScript để hiển thị dropdown */
        .show {
            display: block;
        }
    </style>
</head>
<body>
    <h2 style="text-align: center;">Danh sách bài viết</h2>

    <c:if test="${empty blogs}">
        <p style="text-align: center;">Chưa có bài viết nào.</p>
    </c:if>

    <c:forEach var="blog" items="${blogs}">
        <div class="post-container">
            <div class="post-actions">
                <button class="menu-button" onclick="toggleMenu(event)">&#8942;</button>
                <div class="dropdown-content">
                    
                    <a href="${pageContext.request.contextPath}/blog?action=edit&id=${blog.blogID}">Chỉnh sửa</a>
                    
                    <form action="${pageContext.request.contextPath}/blog" method="post" onsubmit="return confirm('Bạn có chắc chắn muốn xóa bài viết này không?');">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id" value="${blog.blogID}">
                        <button type="submit">Xóa</button>
                    </form>
                </div>
            </div>

            <h3>${blog.title}</h3>
            <p><b>Người đăng:</b> ${blog.nutritionistName}</p>
            <p><b>Ngày đăng:</b> <fmt:formatDate value="${blog.createdAt}" pattern="dd/MM/yyyy HH:mm"/></p>
            <p>${blog.description}</p>
            <c:if test="${not empty blog.imageURL}">
                <img src="${blog.imageURL}" width="100%" style="border-radius: 8px;"/>
            </c:if>
        </div>
    </c:forEach>

<script>
    /* Hàm để bật/tắt dropdown menu */
    function toggleMenu(event) {
        // Ngăn sự kiện click lan ra ngoài (để không bị hàm window.onclick đóng ngay lập tức)
        event.stopPropagation();
        // Lấy dropdown tương ứng với nút được click
        var dropdown = event.target.nextElementSibling;
        // Đóng tất cả các dropdown khác trước khi mở cái mới
        closeAllMenus(dropdown);
        // Bật/tắt dropdown hiện tại
        dropdown.classList.toggle("show");
    }

    /* Đóng tất cả các menu khi click ra ngoài */
    window.onclick = function(event) {
        if (!event.target.matches('.menu-button')) {
            closeAllMenus(null);
        }
    }
    
    function closeAllMenus(exceptThisOne) {
        var dropdowns = document.getElementsByClassName("dropdown-content");
        for (var i = 0; i < dropdowns.length; i++) {
            var openDropdown = dropdowns[i];
            if (openDropdown !== exceptThisOne && openDropdown.classList.contains('show')) {
                openDropdown.classList.remove('show');
            }
        }
    }
</script>

</body>
</html>