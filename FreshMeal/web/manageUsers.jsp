<%@ page import="java.util.*, model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || admin.getRoleID() != 1) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<User> users = (List<User>) request.getAttribute("users");
    if (users == null) users = Collections.emptyList();
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý người dùng - Admin</title>
        <link rel="stylesheet" href="assets/css/shipper.css">
        <link rel="stylesheet" href="assets/css/form-create-user.css">
    </head>
    <body>

        <div class="navbar">
            <div class="navbar-left">
                <img src="assets/images/logotext.png" alt="Logo" style="height: 60px;">
            </div>
            <div class="navbar-right">
                <span>Xin chào, <strong><%= admin.getFullName() %> (Admin)</strong></span>
                <a href="login?action=logout" class="btn-logout">Đăng xuất</a>
            </div>
        </div>

        <div class="container">
            <h2>Danh sách người dùng</h2>

            <% if (request.getAttribute("message") != null) { %>
            <div class="success-message"><%= request.getAttribute("message") %></div>
            <% } else if (request.getAttribute("error") != null) { %>
            <div class="error-message"><%= request.getAttribute("error") %></div>
            <% } %>

            <table class="styled-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Họ tên</th>
                        <th>Email</th>
                        <th>Vai trò</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (users.isEmpty()) { %>
                    <tr><td colspan="5" style="text-align:center;color:gray;">Không có người dùng nào.</td></tr>
                    <% } else {
                        for (User u : users) {
                            if (u.getRoleID() == 1) continue; 
                    %>
                    <tr>
                        <td><%= u.getUserID() %></td>
                        <td><%= u.getFullName() %></td>
                        <td><%= u.getEmail() %></td>
                        <td><%= u.getRoleName() %></td>
                        <td>
                            <form action="UpdateUserRoleServlet" method="post">
                                <input type="hidden" name="userId" value="<%= u.getUserID() %>"/>
                                <select name="role">
                                    <!-- Không hiển thị Admin trong dropdown chỉnh sửa -->
                                    <option value="2" <%= u.getRoleID() == 2 ? "selected" : "" %>>Customer</option>
                                    <option value="3" <%= u.getRoleID() == 3 ? "selected" : "" %>>Manager</option>
                                    <option value="4" <%= u.getRoleID() == 4 ? "selected" : "" %>>Seller</option>
                                    <option value="5" <%= u.getRoleID() == 5 ? "selected" : "" %>>Nutritionist</option>
                                    <option value="6" <%= u.getRoleID() == 6 ? "selected" : "" %>>Shipper</option>
                                </select>
                                <button type="submit">Cập nhật</button>
                            </form>
                        </td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>

            <div class="create-account-container">
                <h3>Tạo tài khoản mới</h3>
                <form class="create-account-form" action="CreateUserServlet" method="post" autocomplete="off">

                    <div class="form-row">
                        <label for="fullName">Họ tên:</label>
                        <input type="text" id="fullName" name="fullName" required>
                    </div>

                    <div class="form-row">
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" required autocomplete="off">
                    </div>

                    <div class="form-row">
                        <label for="city">Thành phố:</label>
                        <select id="city" name="city" required>
                            <option value="">-- Chọn tỉnh/thành phố --</option>
                            <option value="Hà Nội">Hà Nội</option>
                            <option value="Hồ Chí Minh">Hồ Chí Minh</option>
                            <option value="Hải Phòng">Hải Phòng</option>
                            <option value="Đà Nẵng">Đà Nẵng</option>
                            <option value="Cần Thơ">Cần Thơ</option>
                            <option value="An Giang">An Giang</option>
                            <option value="Bà Rịa - Vũng Tàu">Bà Rịa - Vũng Tàu</option>
                            <option value="Bạc Liêu">Bạc Liêu</option>
                            <option value="Bắc Giang">Bắc Giang</option>
                            <option value="Bắc Kạn">Bắc Kạn</option>
                            <option value="Bắc Ninh">Bắc Ninh</option>
                            <option value="Bến Tre">Bến Tre</option>
                            <option value="Bình Dương">Bình Dương</option>
                            <option value="Bình Định">Bình Định</option>
                            <option value="Bình Phước">Bình Phước</option>
                            <option value="Bình Thuận">Bình Thuận</option>
                            <option value="Cà Mau">Cà Mau</option>
                            <option value="Cao Bằng">Cao Bằng</option>
                            <option value="Đắk Lắk">Đắk Lắk</option>
                            <option value="Đắk Nông">Đắk Nông</option>
                            <option value="Điện Biên">Điện Biên</option>
                            <option value="Đồng Nai">Đồng Nai</option>
                            <option value="Đồng Tháp">Đồng Tháp</option>
                            <option value="Gia Lai">Gia Lai</option>
                            <option value="Hà Giang">Hà Giang</option>
                            <option value="Hà Nam">Hà Nam</option>
                            <option value="Hà Tĩnh">Hà Tĩnh</option>
                            <option value="Hải Dương">Hải Dương</option>
                            <option value="Hậu Giang">Hậu Giang</option>
                            <option value="Hòa Bình">Hòa Bình</option>
                            <option value="Hưng Yên">Hưng Yên</option>
                            <option value="Khánh Hòa">Khánh Hòa</option>
                            <option value="Kiên Giang">Kiên Giang</option>
                            <option value="Kon Tum">Kon Tum</option>
                            <option value="Lai Châu">Lai Châu</option>
                            <option value="Lâm Đồng">Lâm Đồng</option>
                            <option value="Lạng Sơn">Lạng Sơn</option>
                            <option value="Lào Cai">Lào Cai</option>
                            <option value="Long An">Long An</option>
                            <option value="Nam Định">Nam Định</option>
                            <option value="Nghệ An">Nghệ An</option>
                            <option value="Ninh Bình">Ninh Bình</option>
                            <option value="Ninh Thuận">Ninh Thuận</option>
                            <option value="Phú Thọ">Phú Thọ</option>
                            <option value="Phú Yên">Phú Yên</option>
                            <option value="Quảng Bình">Quảng Bình</option>
                            <option value="Quảng Nam">Quảng Nam</option>
                            <option value="Quảng Ngãi">Quảng Ngãi</option>
                            <option value="Quảng Ninh">Quảng Ninh</option>
                            <option value="Quảng Trị">Quảng Trị</option>
                            <option value="Sóc Trăng">Sóc Trăng</option>
                            <option value="Sơn La">Sơn La</option>
                            <option value="Tây Ninh">Tây Ninh</option>
                            <option value="Thái Bình">Thái Bình</option>
                            <option value="Thái Nguyên">Thái Nguyên</option>
                            <option value="Thanh Hóa">Thanh Hóa</option>
                            <option value="Thừa Thiên Huế">Thừa Thiên Huế</option>
                            <option value="Tiền Giang">Tiền Giang</option>
                            <option value="Trà Vinh">Trà Vinh</option>
                            <option value="Tuyên Quang">Tuyên Quang</option>
                            <option value="Vĩnh Long">Vĩnh Long</option>
                            <option value="Vĩnh Phúc">Vĩnh Phúc</option>
                            <option value="Yên Bái">Yên Bái</option>
                        </select>
                    </div>

                    <div class="form-row">
                        <label for="district">Quận:</label>
                        <input type="text" id="district" name="district">
                    </div>

                    <div class="form-row">
                        <label for="address">Địa chỉ cụ thể:</label>
                        <input type="text" id="address" name="address">
                    </div>

                    <div class="form-row">
                        <label for="password">Mật khẩu:</label>
                        <input type="password" id="password" name="password" required autocomplete="new-password">
                    </div>

                    <div class="form-row">
                        <label for="role">Vai trò:</label>
                        <select id="role" name="role" required>

                            <option value="2">Customer</option>
                            <option value="3">Manager</option>
                            <option value="4">Nutritionist</option>
                            <option value="5">Seller</option>
                            <option value="6">Shipper</option>
                        </select>
                    </div>

                    <div class="form-row">
                        <button class="btn-submit" type="submit">Tạo tài khoản</button>
                    </div>
                </form>
            </div>
        </div>

    </body>
</html>