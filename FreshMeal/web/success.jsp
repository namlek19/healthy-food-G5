<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đặt hàng thành công - HealthyFood</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
</head>
<body class="checkout-page">
    <div class="success-wrapper">
     
        <div class="success-title">Đặt hàng thành công!</div>
        <%
            Integer orderId = (Integer) session.getAttribute("orderId");
            if (orderId != null) {
        %>
            <div class="success-message">
                Mã đơn hàng của bạn: <b>#<%= orderId %></b>
            </div>
        <%
                session.removeAttribute("orderId");
            }
        %>
        <div class="success-desc">
            Cảm ơn bạn đã mua hàng tại <b>HealthyFood</b>!<br>
            Đơn hàng sẽ được xác nhận và giao đến địa chỉ bạn cung cấp.
        </div>
        <div class="success-actions">
            <a href="index.jsp" class="success-btn">Tiếp tục mua sắm</a>
           
        </div>
    </div>
</body>
</html>
