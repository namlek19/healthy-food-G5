<%@ page import="model.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Checkout - HealthyFood</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>
<body class="checkout-page">
    <header>
        <!-- ... giữ nguyên header như cũ ... -->
    </header>
    <div class="checkout-wrapper">
        <h2>Thông tin & Thanh toán đơn hàng</h2>
        <div class="checkout-form">
            <form action="checkout" method="post" onsubmit="return validateCheckout();">
                <!-- THÔNG TIN NGƯỜI NHẬN -->
                <label>Họ và tên <span class="required">*</span></label>
                <input type="text" name="fullname" required>

                <label>Email <span class="required">*</span></label>
                <input type="email" name="email" id="email" required>

                <label>Số điện thoại <span class="required">*</span></label>
                <input type="text" name="phone" id="phone" pattern="[0-9]{10,11}" title="Số điện thoại từ 10–11 chữ số" required>

                <label>Quận nội thành Hà Nội <span class="required">*</span></label>
                <select name="district" id="district" onchange="enableAddress()" required>
                    <option value="">-- Chọn quận --</option>
                    <option>Hoàn Kiếm</option>
                    <option>Ba Đình</option>
                    <option>Đống Đa</option>
                    <option>Hai Bà Trưng</option>
                    <option>Tây Hồ</option>
                    <option>Cầu Giấy</option>
                    <option>Thanh Xuân</option>
                    <option>Hoàng Mai</option>
                    <option>Long Biên</option>
                </select>

                <label>Địa chỉ cụ thể <span class="required">*</span></label>
                <textarea name="address" id="address" placeholder="Số nhà, ngõ, đường..." disabled required></textarea>

                <!-- CHI TIẾT SẢN PHẨM TRONG ĐƠN -->
                <h3 style="margin: 32px 0 12px 0; color: #1b813e; font-size: 1.12rem; font-weight: bold;">Sản phẩm đã đặt</h3>
                <div style="background: #fff; border-radius:8px; padding:18px; border:1px solid #e1f5ea; margin-bottom:16px;">
                <%
                    List<CartItem> cart = (List<CartItem>) session.getAttribute(session.getAttribute("user") != null ? "cart" : "guest_cart");
                    double total = 0;
                    if (cart == null || cart.isEmpty()) {
                %>
                    <p style="color:gray; text-align:center;">Giỏ hàng trống.</p>
                <%
                    } else {
                %>
                <table style="width:100%; border-collapse:collapse;">
                    <tr style="background:#f3faf7;">
                        <th style="padding:8px;">Tên SP</th>
                        <th style="padding:8px;">SL</th>
                        <th style="padding:8px;">Đơn giá</th>
                        <th style="padding:8px;">Thành tiền</th>
                    </tr>
                    <%
                        for (CartItem item : cart) {
                            Product p = item.getProduct();
                            double subtotal = item.getTotalPrice();
                            total += subtotal;
                    %>
                    <tr>
                        <td style="padding:8px;"><%= p.getName() %></td>
                        <td style="padding:8px; text-align:center;"><%= item.getQuantity() %></td>
                        <td style="padding:8px;"><%= String.format("%,.0f", p.getPrice()) %> đ</td>
                        <td style="padding:8px;"><%= String.format("%,.0f", subtotal) %> đ</td>
                    </tr>
                    <% } %>
                    <tr>
                        <td colspan="3" style="text-align:right; padding:10px;"><b>Tổng cộng:</b></td>
                        <td style="padding:10px; color:#2b9348; font-weight:bold;"><%= String.format("%,.0f", total) %> đ</td>
                    </tr>
                </table>
                <%
                    }
                %>
                </div>

                <!-- CHỌN PHƯƠNG THỨC THANH TOÁN -->
                <div style="margin: 22px 0 10px 0;">
                    <label style="font-weight:bold;">Chọn phương thức thanh toán <span class="required">*</span></label><br>
                    <input type="radio" name="method" value="cod" checked> Thanh toán khi nhận hàng (COD)
                    <br>
                    <input type="radio" name="method" value="vnpay" disabled style="margin-top:8px;"> Thanh toán qua VNPay <span style="color:#aaa;">(Sắp ra mắt)</span>
                </div>

                <button type="submit" class="pay-btn pay-btn-cod" style="margin-top:16px;">Đặt hàng</button>
            </form>
        </div>
    </div>

    <script>
        function validateCheckout() {
            const email = document.getElementById("email").value.trim();
            const district = document.getElementById("district").value;
            const address = document.getElementById("address").value.trim();

            const emailRegex = /^[a-zA-Z0-9._%+-]+@(gmail\.com|fpt\.edu\.vn|yahoo\.com)$/;
            if (!emailRegex.test(email)) {
                alert("Vui lòng nhập địa chỉ email hợp lệ.");
                return false;
            }
            if (district === "") {
                alert("Vui lòng chọn quận nội thành.");
                return false;
            }
            if (address === "") {
                alert("Vui lòng nhập địa chỉ cụ thể.");
                return false;
            }
            return true;
        }
        function enableAddress() {
            const district = document.getElementById("district").value;
            document.getElementById("address").disabled = (district === "");
        }
    </script>
</body>
</html>
