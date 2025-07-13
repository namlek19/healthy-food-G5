<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Thêm người dùng mới</title>
    <link rel="stylesheet" href="assets/css/admin-dashboard.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="admin-sidebar">
        <div class="admin-avatar">
            <img src="assets/images/user-icon.png" alt="Admin" style="width:60px;height:60px;border-radius:50%;">
        </div>
        <h2>Admin</h2>
        <div class="admin-welcome">Chào mừng bạn trở lại</div>
        <ul class="admin-nav">
            <li><a href="admindasboard.jsp">Danh sách người dùng</a></li>
            <li><a href="#" class="active">Thêm người dùng mới</a></li>
            <li><a href="index.jsp">Xem cửa hàng</a></li>
            <li><form action="login" method="get" style="display:inline;"><button type="submit" name="action" value="logout" style="background:none;border:none;color:#fff;cursor:pointer;padding:0;">Đăng xuất</button></form></li>
        </ul>
    </div>
    <div class="admin-main">
        <div class="admin-card" style="max-width: 500px; margin: 0 auto;">
            <h1 style="font-size:1.3rem; font-weight:600; margin-bottom:24px;">Thêm người dùng mới</h1>
            <form method="post" action="login">
                <input type="hidden" name="action" value="addUser" />
                <div class="mb-3">
                    <label class="form-label">Họ và tên</label>
                    <input type="text" name="fullName" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" name="email" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Mật khẩu</label>
                    <input type="password" name="password" class="form-control" required />
                </div>
                <div class="mb-3">
                    <label class="form-label">Thành phố</label>
                    <input type="text" name="city" class="form-control" />
                </div>
                <div class="mb-3">
                    <label class="form-label">Quận/Huyện</label>
                    <input type="text" name="district" class="form-control" />
                </div>
                <div class="mb-3">
                    <label class="form-label">Địa chỉ</label>
                    <input type="text" name="address" class="form-control" />
                </div>
                <div class="mb-3">
                    <label class="form-label">Vai trò</label>
                    <select name="roleID" class="form-select">
                        <option value="1">Admin</option>
                        <option value="2" selected>Customer</option>
                        <option value="3">Manager</option>
                        <option value="4">Seller</option>
                        <option value="5">Nutritionist</option>
                        <option value="6">Shipper</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary w-100">Tạo tài khoản</button>
            </form>
        </div>
    </div>
</body>
</html> 