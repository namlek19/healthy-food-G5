<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">

    <style>
        html {
            scroll-behavior: auto !important;
        }
    </style>

    <head>
        <meta charset="UTF-8">
        <title>Blog List</title>
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/blogcus.css">
        <link rel="stylesheet" href="assets/css/footer.css">
        <link rel="stylesheet" href="assets/css/header-user.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">

    </head>
    <body style="background:#f0f2f5; margin:0;">


        <jsp:include page="includes/header.jsp" />

        <div class="search-bar">
            <form action="search">
                <input type="text" placeholder="Searching for food..." required />        
            </form>
        </div>



        <div class="container py-4">
            <h2 class="blog-list-header">Danh sách bài viết</h2>

            <div class="blog-filter-form">
                <label for="sort-select">Lọc:</label>
                <form method="get" action="blogcus" style="margin-bottom:0;">
                    <select id="sort-select" name="sort" class="blog-filter-select"
                            onchange="this.form.submit()">
                        <option value="newest" ${param.sort == 'newest' || empty param.sort ? 'selected' : ''}>Bài mới nhất</option>
                        <option value="oldest" ${param.sort == 'oldest' ? 'selected' : ''}>Bài cũ nhất</option>
                    </select>
                </form>
            </div>


            <c:if test="${empty blogs}">
                <p style="text-align:center;">Chưa có bài viết nào.</p>
            </c:if>
            <div class="blog-list-grid">
                <c:forEach var="blog" items="${blogs}">
                    <div class="blog-list-item">
                        <a href="blogdetail?id=${blog.blogID}" class="blog-list-img-link">
                            <c:if test="${not empty blog.imageURL}">
                                <img src="${blog.imageURL}" class="blog-list-img" alt="Ảnh blog"/>
                            </c:if>
                            <c:if test="${empty blog.imageURL}">
                                <img src="assets/images/default-blog.jpg" class="blog-list-img" alt="Ảnh blog"/>
                            </c:if>
                        </a>
                        <div class="blog-list-info">
                            <a href="blogdetail?id=${blog.blogID}" class="blog-list-title">
                                ${blog.title}
                            </a>
                            <div class="blog-list-desc">
                                <c:choose>
                                    <c:when test="${fn:length(blog.description) > 120}">
                                        ${fn:substring(blog.description, 0, 120)}...
                                    </c:when>
                                    <c:otherwise>
                                        ${blog.description}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="blog-list-meta">
                                <span>Người đăng: ${blog.nutritionistName}</span> | 
                                <fmt:formatDate value="${blog.createdAt}" pattern="dd/MM/yyyy"/>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>




        <jsp:include page="includes/footer.jsp" />


        <script>

            document.querySelectorAll('a[href*="blogdetail"]').forEach(link => {
                link.addEventListener('click', function () {
                    sessionStorage.setItem('bloglist-scroll', window.scrollY);
                });
            });
            window.addEventListener('load', function () {
                const lastScroll = sessionStorage.getItem('bloglist-scroll');
                if (lastScroll) {

                    window.scrollTo({top: parseInt(lastScroll), behavior: "auto"});
                    sessionStorage.removeItem('bloglist-scroll');
                }
            });

        </script>
    </body>
</html>
