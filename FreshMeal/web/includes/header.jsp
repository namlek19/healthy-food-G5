<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<header class="main-header">
    <div class="container header-container">
        <div class="logo">
            <a href="index">
                <img src="assets/images/logotext.png" alt="logo">
            </a>
        </div>
        <nav>
            <ul class="nav gap-3">
                <li class="nav-item"><a href="productlistcontrol?category=" class="nav-link">MÓN ĂN</a></li>
                <li class="nav-item"><a href="menucus?bmi=" class="nav-link">COMBO</a></li>
                <li class="nav-item"><a href="blogcus" class="nav-link">BLOG</a></li>
            </ul>
        </nav>
        <div class="header-right">
            <a href="cart.jsp" class="cart-btn">
                <span class="cart-icon-wrap">
                    <img src="assets/images/shopping-cart.png" alt="Cart" class="cart-icon">
                </span>
                <span class="cart-text">Giỏ hàng</span>
            </a>

            <% User user = (User) session.getAttribute("user"); %>
            <% if (user != null) { %>
            <div class="user-menu">
                <button class="user-menu-btn" type="button">
                    <img src="assets/images/user-icon.png" alt="User" class="avatar">
                    <span>
                        <%= user.getFirstName() != null && !user.getFirstName().isEmpty()
                            ? user.getFirstName()
                            : user.getFullName() %>
                    </span>
                    <span class="dropdown-arrow">&#9662;</span>
                </button>
                <div class="user-dropdown">
                    <a href="profile.jsp">Thông tin cá nhân</a>
                    <a href="order-history">Lịch sử đơn hàng</a>
                    <% if (user.getRoleID() == 1) { %>
                        <a href="<%= request.getContextPath() %>/admin-dashboard">Quản trị Admin</a>
                    <% } %>
                    <a href="login?action=logout">Đăng xuất</a>
                </div>
            </div>
            <% } else { %>
            <div class="auth-buttons">
                <a href="login.jsp" class="btn btn-outline-success btn-sm">Đăng Nhập</a>
                <a href="login.jsp?action=signup" class="btn btn-outline-success btn-sm">Đăng Ký</a>
            </div>
            <% } %>
        </div>
    </div>
</header>

<!-- Dropdown Toggle JS -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var userMenu = document.querySelector('.user-menu');
        if (userMenu) {
            var btn = userMenu.querySelector('.user-menu-btn');
            btn.addEventListener('click', function (e) {
                e.stopPropagation();
                userMenu.classList.toggle('open');
            });
            document.addEventListener('click', function () {
                userMenu.classList.remove('open');
            });
        }
    });
</script>