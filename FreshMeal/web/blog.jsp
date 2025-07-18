<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<link rel="stylesheet" href="assets/css/blog.css">
<%
    request.setAttribute("currentPage", "bloglist");
%>

<!DOCTYPE html>
<%
    Integer myUserID = (Integer) request.getAttribute("myUserID");
%>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách Blog</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

    </head>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            display: flex; /* Sử dụng Flexbox cho layout 2 cột */
        }

        .main-container {
            flex: 1; /* Phần nội dung chính sẽ chiếm hết không gian còn lại */
            padding: 20px;
            margin-left: 220px;
            padding: 20px;
        }
        .post-container {
            position: relative;
            background-color: #BEF0CF;
            border: 1px solid #ddd;
            border-radius: 8px;
            margin: 0 auto 20px auto; /* Căn giữa và thêm khoảng cách */
            padding: 20px;
            max-width: 700px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .blog-post-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        .blog-post-header a {
            text-decoration: none;
            color: #5cb85c; /* Đã sửa lỗi chú thích */
            font-weight: bold;
        }
        .star-icon {
            color: #f0ad4e; /* Đã sửa lỗi chú thích */
            margin-right: 8px;
            font-size: 1.2em;
        }
        .post-actions {
            position: absolute;
            top: 15px;
            right: 15px;
        }
        .menu-button {
            background: none;
            border: none;
            font-size: 20px;
            cursor: pointer;
            padding: 5px;
            line-height: 1;
        }
        .dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            background-color: white;
            min-width: 120px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
            border-radius: 5px;
            overflow: hidden;
        }
        .dropdown-content a, .dropdown-content button {
            color: black;
            padding: 10px 15px;
            text-decoration: none;
            display: block;
            text-align: left;
            width: 100%;
            border: none;
            background: none;
            cursor: pointer;
            font-size: 14px;
        }
        .dropdown-content a:hover, .dropdown-content button:hover {
            background-color: #f1f1f1;
        }
        .show {
            display: block;
        }

        .preserve-whitespace {
            white-space: pre-wrap;
            word-wrap: break-word;
        }

        .blog-img-full {
            display: block;
            width: 100%;      
            height: auto;
            max-height: 500px;    
            object-fit: cover;    
            border-radius: 8px;
            background: #f4f4f4;
            margin: 0 auto;
        }

    </style>

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
                           class="<c:if test='${currentPage eq "blogpost"}'>active</c:if>">
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
            <h2 style="text-align: center;">Danh sách bài viết</h2>

            <c:if test="${empty blogs}">
                <p style="text-align: center;">Chưa có bài viết nào.</p>
            </c:if>

            <c:forEach var="blog" items="${blogs}">
                <div class="post-container">
                    <div class="blog-post-header">
                        <i class="fas fa-star star-icon"></i>
                        <a href="blogpost">Blog Post</a>
                    </div>
                    <c:if test="${myUserID != null && myUserID == blog.nutritionistID}">
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
                    </c:if>



                    <h3 class="preserve-whitespace">${blog.title}</h3>
                    <p><b>Người đăng:</b> ${blog.nutritionistName}</p>
                    <p><b>Ngày đăng:</b> <fmt:formatDate value="${blog.createdAt}" pattern="dd/MM/yyyy HH:mm"/></p>
                    <p class="preserve-whitespace">${blog.description}</p>

                    <c:if test="${not empty blog.imageURL}">
                        <img src="${blog.imageURL}" class="blog-img-full"/>
                    </c:if>


                    
                    <p style="margin-top: 10px;">
                        <a href="blogdetail?id=${blog.blogID}" style="color: #007bff; text-decoration: none;">
                            → Xem chi tiết & bình luận
                        </a>
                    </p>

                </div>
            </c:forEach>
        </div>

        <script>
            function toggleMenu(event) {
                event.stopPropagation();
                var dropdown = event.target.nextElementSibling;
                
                closeAllMenus(dropdown);
                dropdown.classList.toggle("show");
            }

            
            window.onclick = function (event) {
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


            
            document.querySelectorAll('a[href*="blogdetail"]').forEach(link => {
                link.addEventListener('click', function () {
                    // Lưu lại vị trí scroll hiện tại vào sessionStorage
                    sessionStorage.setItem('bloglist-scroll', window.scrollY);
                });
            });


            window.addEventListener('load', function () {
                const lastScroll = sessionStorage.getItem('bloglist-scroll');
                if (lastScroll) {
                    window.scrollTo(0, parseInt(lastScroll));
                    
                    sessionStorage.removeItem('bloglist-scroll');
                }
            });
            
            
        </script>


    </body>
</html>