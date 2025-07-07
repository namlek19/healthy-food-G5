<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" href="assets/css/blog.css">
<div class="sidebar">
    <div class="sidebar-header">
        <i class="fas fa-leaf sidebar-logo-icon"></i>
        <h2>QUẢN LÝ</h2>
    </div>
    
    <ul class="sidebar-menu">
        <li class="menu-category-title">BLOG</li>
        <li>
            <a href="blogpost" class="${currentPage eq 'blogpost' ? 'active' : ''}">
                <i class="fas fa-plus-circle menu-icon"></i> Blog Mới
            </a>
        </li>
        <li>
            <a href="blogmanage" class="${currentPage eq 'blogmanage' ? 'active' : ''}"> <%-- Đã sửa cú pháp tại đây --%>
                <i class="fas fa-list-alt menu-icon"></i> Danh Sách Blog
            </a>
        </li>
    </ul>

    <ul class="sidebar-menu">
        <li class="menu-category-title">COMBO</li>
        <li>
            <a href="menupost" class="${currentPage eq 'menupost' ? 'active' : ''}">
                <i class="fas fa-plus-circle menu-icon"></i> Combo Mới
            </a>
        </li>
        <li>
            <a href="menumanage" class="${currentPage eq 'menumanage' ? 'active' : ''}">
                <i class="fas fa-boxes menu-icon"></i> Quản Lý Combo
            </a>
        </li>
    </ul>

    <ul class="sidebar-menu sidebar-bottom">
        <li>
            <a href="${pageContext.request.contextPath}/login?action=logout" class="logout-link">
                <i class="fas fa-sign-out-alt menu-icon"></i> Đăng Xuất
            </a>
        </li>
    </ul>
</div>