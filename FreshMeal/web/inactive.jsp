<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài khoản bị tạm khóa</title>
    <link rel="stylesheet" href="assets/css/style.css">
    <link rel="stylesheet" href="assets/css/header-user.css"> 
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <header class="bg-white shadow-sm">
        <div class="container d-flex align-items-center justify-content-between py-3">
            <div class="logo">
                <img src="assets/images/logo.png" alt="logo">
            </div>
            <nav>
                <ul class="nav">
                    <li class="nav-item"><a href="productlistcontrol?category=" class="nav-link text-dark" >Product</a></li>
                    <li class="nav-item"><a href="menucus?bmi=" class="nav-link text-dark" >Menu</a></li>
                    <li class="nav-item"><a href="blogcus" class="nav-link text-dark" >Blog</a></li>
                </ul>
            </nav>
            <div class="header-right">
                <a href="login.jsp" class="btn btn-outline-success btn-sm">Sign In</a>
            </div>
        </div>
    </header>
    <section class="hero py-5">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-12 text-center">
                    <h1 style="color: #d9534f;">Tài khoản của bạn đã bị tạm khóa</h1>
                    <p style="font-size: 1.2rem;">Vui lòng liên hệ quản trị viên để biết thêm chi tiết.<br>Your account has been suspended. Please contact admin.</p>
                    <a href="login.jsp" class="btn btn-danger mt-3">Quay lại đăng nhập</a>
                </div>
            </div>
        </div>
    </section>
    <footer class="bg-light text-center py-4 mt-5">
        <div class="container">
            <p class="mb-0 text-muted">&copy; 2025 HealthyFood. All rights reserved.</p>
        </div>
    </footer>
</body>
</html> 