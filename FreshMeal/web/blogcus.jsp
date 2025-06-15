<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">

    <style>
        html {
            scroll-behavior: auto !important;
        }
    </style>

    <style>
        .post-container {
            position: relative;
            background-color: #BEF0CF;
            border: 1px solid #ddd;
            border-radius: 8px;
            margin: 0 auto 20px auto;
            padding: 20px;
            max-width: 700px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .blog-post-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }
        .star-icon {
            color: #f0ad4e;
            margin-right: 8px;
            font-size: 1.2em;
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
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 16px;
        }

    </style>
    <head>
        <meta charset="UTF-8">
        <title>Blog List</title>
        <link rel="stylesheet" href="assets/css/blogcus.css">
        <link rel="stylesheet" href="assets/css/style.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

    </head>
    <body style="background:#f0f2f5; margin:0;">

        <!-- ===== HEADER (copy từ index.jsp) ===== -->
        <header class="bg-white shadow-sm">
            <div class="container d-flex align-items-center justify-content-between py-3">
                <div class="logo">
                    <a href="index.jsp">
                        <img src="assets/images/logo.png" alt="logo">
                    </a>
                </div>
                <nav>
                    <ul class="nav">
                        <li class="nav-item"><a href="productlistcontrol?category=" class="nav-link text-dark" >Product</a></li>
                        <li class="nav-item"><a href="MenuCus.jsp" class="nav-link text-dark" >Menu</a></li>
                        <li class="nav-item"><a href="blogcus" class="nav-link text-dark" >Blog</a></li>
                    </ul>
                </nav>
                <div class="d-flex align-items-center gap-3">
                    <a href="cart.jsp" title="Cart">
                        <img src="assets/images/shopping-cart.png" alt="Cart" style="width: 24px;">
                    </a>
                    <div class="auth-button">
                        <%@ page import="model.User" %>
                        <% User user = (User) session.getAttribute("user"); %>
                        <% if (user == null) { %>
                        <a href="login.jsp" class="btn btn-outline-success btn-sm">Sign In</a>
                        <a href="login.jsp?action=signup" class="btn btn-outline-success btn-sm">Sign Up</a>
                        <% } else { %>
                        <a href="profile.jsp" class="auth-button">Hello, <%= user.getFirstName() != null && !user.getFirstName().isEmpty() ? user.getFirstName() : user.getFullName() %></a>
                        <a href="login?action=logout" class="auth-button">Logout</a>
                        <% } %>
                    </div>
                </div>
            </div>
        </header>

        <div class="search-bar">
            <form action="search">
                <input type="text" placeholder="Searching for food..." required />        
            </form>
        </div>
        <!-- ===== END HEADER ===== -->

        <!-- ======= BLOG LIST ======= -->
        <div class="container py-4">
            <h2 style="text-align:center;">Danh sách bài viết</h2>
            <c:if test="${empty blogs}">
                <p style="text-align:center;">Chưa có bài viết nào.</p>
            </c:if>
            <c:forEach var="blog" items="${blogs}">
                <div class="post-container">
                    <div class="blog-post-header">
                        <i class="fas fa-star star-icon"></i>
                        <span style="font-weight: bold; color:#5cb85c;">Blog Post</span>
                    </div>
                    <h3 class="preserve-whitespace">${blog.title}</h3>
                    <p><b>Người đăng:</b> ${blog.nutritionistName}</p>
                    <p><b>Ngày đăng:</b> <fmt:formatDate value="${blog.createdAt}" pattern="dd/MM/yyyy HH:mm"/></p>
                    <p class="preserve-whitespace">${blog.description}</p>
                    <c:if test="${not empty blog.imageURL}">
                        <img src="${blog.imageURL}" class="blog-img-full"/>
                    </c:if>
                    <p style="margin-top:10px;">
                        <a href="blogdetail?id=${blog.blogID}" style="color:#007bff; text-decoration:none;">
                            → Xem chi tiết & bình luận
                        </a>
                    </p>
                </div>
            </c:forEach>
        </div>
        <!-- ======= END BLOG LIST ======= -->

        <!-- ===== FOOTER (copy từ index.jsp) ===== -->
        <footer class="bg-light text-center py-4 mt-5">
            <div class="container">
                <p class="mb-0 text-muted">&copy; 2025 HealthyFood. All rights reserved.</p>
            </div>
        </footer>
        <!-- ===== END FOOTER ===== -->

        <script>
            // Lưu vị trí scroll khi bấm xem chi tiết
            document.querySelectorAll('a[href*="blogdetail"]').forEach(link => {
                link.addEventListener('click', function () {
                    sessionStorage.setItem('bloglist-scroll', window.scrollY);
                });
            });
            window.addEventListener('load', function () {
                const lastScroll = sessionStorage.getItem('bloglist-scroll');
                if (lastScroll) {
                    // Sử dụng behavior: "auto" để đảm bảo không smooth
                    window.scrollTo({top: parseInt(lastScroll), behavior: "auto"});
                    sessionStorage.removeItem('bloglist-scroll');
                }
            });

        </script>
    </body>
</html>
