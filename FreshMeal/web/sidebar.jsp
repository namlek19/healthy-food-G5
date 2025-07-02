<!-- sidebar.jsp -->
<link rel="stylesheet" href="assets/css/blog.css">
<div class="sidebar">
    <h2>BLOG</h2>
    <ul>
        <li>
            <a href="blogpost"
               class="${currentPage eq 'blogpost' ? 'active' : ''}">
                Blog Post
            </a>
        </li>
        <li>
            <a href="blogmanage"
               class="<c:if test='${currentPage eq "blogmanage"}'>active</c:if>">
                Blog List
            </a>
        </li>
    </ul>
    <h2>MENU</h2>
    <ul>
        <li>
            <a href="menupost"
               class="${currentPage eq 'menupost' ? 'active' : ''}">
                Menu Post
            </a>
        </li>
        <li>
            <a href="menumanage"
               class="${currentPage eq 'menumanage' ? 'active' : ''}">
                Menu Manage
            </a>
        </li>
    </ul>
    <ul>
        <li>
            <a href="${pageContext.request.contextPath}/login?action=logout" style="color:red;">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </li>
    </ul>
</div>
