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
        <header></header>
        <div class="checkout-wrapper">
            <h2>Thông tin & Thanh toán đơn hàng</h2>
            <div class="checkout-form">
                <form id="checkoutForm" action="checkout" method="post" onsubmit="return validateCheckout();">

                    <%
                        User user = (User) session.getAttribute("user");
                        boolean isCustomer = (user != null && user.getRoleID() == 2); 
                        String userDistrict = user != null ? user.getDistrict() : "";
                        String userAddress = user != null ? user.getAddress() : "";
                    %>

                    <label>Họ và tên <span class="required">*</span></label>
                    <input type="text" name="fullname" id="fullname" required
                           value="<%= user != null ? user.getFullName() : "" %>">

                    <label>Email <span class="required">*</span></label>
                    <input type="email" name="email" id="email" required
                           value="<%= user != null ? user.getEmail() : "" %>">

                    <label>Số điện thoại <span class="required">*</span></label>
                    <input type="text" name="phone" id="phone" pattern="[0-9]{10,11}" title="Số điện thoại từ 10–11 chữ số" required>

                    <% if (isCustomer) { %>
                    <!-- BẮT ĐẦU: Chọn địa chỉ -->
                    <label style="font-weight:bold;">Chọn địa chỉ nhận hàng <span class="required">*</span></label><br>
                    <input type="checkbox" id="useProfileAddress" checked onchange="toggleAddressInput()"> Sử dụng địa chỉ trong hồ sơ<br><br>
                    <input type="hidden" name="addressOption" id="addressOption" value="profile">


                    <% } else { %>
                    <input type="hidden" name="addressOption" value="new">
                    <% } %>

                    <label>Quận nội thành Hà Nội <span class="required">*</span></label>
                    <div class="district-wrapper">
                        <select name="district" id="district" onchange="enableAddress()" required
                                data-default="<%= userDistrict %>" style="width:100%;">
                            <option value="">-- Chọn quận --</option>
                            <option <%= userDistrict.equals("Hoàn Kiếm") ? "selected" : "" %>>Hoàn Kiếm</option>
                            <option <%= userDistrict.equals("Ba Đình") ? "selected" : "" %>>Ba Đình</option>
                            <option <%= userDistrict.equals("Đống Đa") ? "selected" : "" %>>Đống Đa</option>
                            <option <%= userDistrict.equals("Hai Bà Trưng") ? "selected" : "" %>>Hai Bà Trưng</option>
                            <option <%= userDistrict.equals("Tây Hồ") ? "selected" : "" %>>Tây Hồ</option>
                            <option <%= userDistrict.equals("Cầu Giấy") ? "selected" : "" %>>Cầu Giấy</option>
                            <option <%= userDistrict.equals("Thanh Xuân") ? "selected" : "" %>>Thanh Xuân</option>
                            <option <%= userDistrict.equals("Hoàng Mai") ? "selected" : "" %>>Hoàng Mai</option>
                            <option <%= userDistrict.equals("Long Biên") ? "selected" : "" %>>Long Biên</option>
                        </select>
                        <div id="districtOverlay" class="overlay"></div>
                    </div>

                    <label>Địa chỉ cụ thể <span class="required">*</span></label>
                    <textarea name="address" id="address" placeholder="Số nhà, ngõ, đường..." required
                              data-default="<%= userAddress %>" 
                              style="width:100%;"><%= userAddress %></textarea>

                    <h3 style="margin: 32px 0 12px 0; color: #1b813e; font-size: 1.12rem; font-weight: bold;">Sản phẩm đã đặt</h3>
                    <div style="background: #fff; border-radius:8px; padding:18px; border:1px solid #e1f5ea; margin-bottom:16px;">
                        <%
                            List<CartItem> cart = (List<CartItem>) session.getAttribute(user != null ? "cart" : "guest_cart");
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

                    <div style="margin: 22px 0 10px 0;">
                        <label style="font-weight:bold;">Chọn phương thức thanh toán <span class="required">*</span></label><br>
                        <input type="radio" name="method" value="cod" checked onclick="setFormAction('checkout')"> Thanh toán khi nhận hàng (COD)
                        <br>
                        <input type="radio" name="method" value="vnpay" onclick="setFormAction('vnpay_ajax')" style="margin-top:8px;"> Thanh toán qua VNPay <span style="color:#20b978;">(Khuyên dùng online)</span>
                    </div>

                    <button type="submit" class="pay-btn pay-btn-cod" style="margin-top:16px;">Đặt hàng</button>
                </form>
            </div>
        </div>

        <script>
            function validateCheckout() {
                const email = document.getElementById("email").value.trim();
                const addressOptionInput = document.querySelector('input[name="addressOption"]:checked');
                const addressOption = addressOptionInput ? addressOptionInput.value : "new";
                const district = document.getElementById("district").value;
                const address = document.getElementById("address").value.trim();

                const allowedDistricts = [
                    "Hoàn Kiếm", "Ba Đình", "Đống Đa", "Hai Bà Trưng", "Tây Hồ",
                    "Cầu Giấy", "Thanh Xuân", "Hoàng Mai", "Long Biên"
                ];

                const emailRegex = /^[a-zA-Z0-9._%+-]+@(gmail\.com|fpt\.edu\.vn|yahoo\.com)$/;
                if (!emailRegex.test(email)) {
                    alert("Vui lòng nhập địa chỉ email hợp lệ.");
                    return false;
                }

                if (district === "" || !allowedDistricts.includes(district)) {
                    alert("Chỉ hỗ trợ giao hàng cho khách tại các quận trung tâm nội thành Hà Nội.");
                    return false;
                }

                if (addressOption === 'new') {
                    if (address === "") {
                        alert("Vui lòng nhập địa chỉ cụ thể.");
                        return false;
                    }
                }
                return true;
            }


            function enableAddress() {
                const district = document.getElementById("district").value;
                document.getElementById("address").disabled = (district === "");
            }

            function toggleAddressInput() {
                const useProfile = document.getElementById("useProfileAddress").checked;
                const districtSelect = document.getElementById("district");
                const addressTextarea = document.getElementById("address");
                const overlay = document.getElementById("districtOverlay");

                document.getElementById("addressOption").value = useProfile ? "profile" : "new";

                if (useProfile) {
                    districtSelect.value = districtSelect.getAttribute('data-default');
                    addressTextarea.value = addressTextarea.getAttribute('data-default');
                    overlay.style.display = "block"; // overlay khóa select
                    districtSelect.classList.add('not-editable');
                    addressTextarea.readOnly = true;
                    addressTextarea.classList.add('not-editable');
                } else {
                    districtSelect.value = "";
                    addressTextarea.value = "";
                    overlay.style.display = "none";
                    districtSelect.classList.remove('not-editable');
                    addressTextarea.readOnly = false;
                    addressTextarea.classList.remove('not-editable');
                }
            }

            function setFormAction(action) {
                document.getElementById('checkoutForm').action = action;
            }

            document.addEventListener("DOMContentLoaded", function () {
                toggleAddressInput();
            });

        </script>
    </body>
</html>
