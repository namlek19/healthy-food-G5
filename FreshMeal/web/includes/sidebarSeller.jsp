<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" href="assets/css/blog.css">
<div class="sidebar">
    <div class="sidebar-header">
        <i class="fas fa-leaf sidebar-logo-icon"></i>
        <h2>Seller</h2>
    </div>
    
    <ul class="sidebar-menu">
        <li class="menu-category-title">CHUNG</li>
        <li>
            <a href="profile.jsp" class="${currentPage eq 'profile' ? 'active' : ''}">
                <i class="fas fa-user-circle menu-icon"></i> Hồ sơ
            </a>
        </li>

        <li class="menu-category-title">Món ăn</li>
        <li>
            <a href="addProductSeller.jsp" class="${currentPage eq 'addproduct' ? 'active' : ''}">
                <i class="fas fa-plus-circle menu-icon"></i> Món mới
            </a>
        </li>
        <li>
            <a href="manageProductSeller" class="${currentPage eq 'manageProductSeller' ? 'active' : ''}"> 
                <i class="fas fa-list-alt menu-icon"></i> Danh Sách Món
            </a>
        </li>
    </ul>

    <ul class="sidebar-menu">
        <li class="menu-category-title">COMBO</li>
        <li>
            <a href="postComboSeller" class="${currentPage eq 'postComboSeller' ? 'active' : ''}">
                <i class="fas fa-plus-circle menu-icon"></i> Post Combo
            </a>
        </li>
        <li>
            <a href="manageComboSeller" class="${currentPage eq 'manageComboSeller' ? 'active' : ''}">
                <i class="fas fa-boxes menu-icon"></i> Danh Sách Combo
            </a>
        </li>
    </ul>
                
    <ul class="sidebar-menu">
        <li class="menu-category-title">Order</li>
        <li>
            <a href="orderSeller" class="${currentPage eq 'orderSeller' ? 'active' : ''}">
                <i class="fas fa-plus-circle menu-icon"></i> Order Cần duyệt
            </a>
        </li>
        <li>
            <a href="orderManager" class="${currentPage eq 'orderManager' ? 'active' : ''}">
                <i class="fas fa-list-alt menu-icon"></i> Tất cả Order
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