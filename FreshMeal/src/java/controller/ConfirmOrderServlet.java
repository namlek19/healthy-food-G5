package controller;

import dal.OrderDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Order;
import model.OrderItem;

public class ConfirmOrderServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int orderID = Integer.parseInt(request.getParameter("orderID"));
            int shipperID = Integer.parseInt(request.getParameter("shipperID"));
            String currentStatus = request.getParameter("currentStatus");

            OrderDAO dao = new OrderDAO();

            String newStatus = "Confirmed";
            if ("QRPending".equalsIgnoreCase(currentStatus)) {
                newStatus = "QRConfirmed";
            }
            dao.confirmOrderWithStatus(orderID, shipperID, newStatus);

            // Lấy lại thông tin order để gửi mail
            Order order = dao.getOrderById(orderID);

            // Ghép danh sách món ăn
            StringBuilder productList = new StringBuilder();
            for (OrderItem item : order.getItems()) {
                productList.append(item.getProductName())
                        .append(" (SL: ")
                        .append(item.getQuantity())
                        .append("), ");
            }
            if (productList.length() > 0) {
                productList.setLength(productList.length() - 2); // Xóa dấu phẩy cuối
            }

            // Gửi email
            String subject;
            String content;

            if ("QRPending".equalsIgnoreCase(currentStatus)) {
                // Trường hợp phần QR
                subject = "Đơn hàng của bạn đã được xác nhận - Mã đơn hàng: " + orderID;

                content = ""
                        + "<p>- <b>Tên khách hàng:</b> " + order.getReceiverName() + "</p>"
                        + "<p>- <b>Địa chỉ:</b> " + order.getDeliveryAddress() + ", " + order.getDistrict() + "</p>"
                        + "<p>- <b>Tổng tiền:</b> " + String.format("%,.0f", order.getTotalAmount()) + " đ</p>"
                        + "<p>- <b>Đơn hàng của bạn gồm có:</b> " + productList.toString() + "</p>"
                        + "<p>- <b>Phương thức thanh toán:</b> Thanh toán Online</p>"
                        + "<p>- <b>Trạng thái:</b> Đã xác nhận </p>"
                        + "<p style=\"margin-top:12px;\"><i>Cảm ơn quý khách!</i></p>";

            } else {
                // Trường hợp thường
                subject = "Đơn hàng của bạn đã được xác nhận - Mã đơn hàng: " + orderID;

                content = ""
                        + "<p>- <b>Tên khách hàng:</b> " + order.getReceiverName() + "</p>"
                        + "<p>- <b>Địa chỉ:</b> " + order.getDeliveryAddress() + ", " + order.getDistrict() + "</p>"
                        + "<p>- <b>Tổng tiền:</b> " + String.format("%,.0f", order.getTotalAmount()) + " đ</p>"
                        + "<p>- <b>Đơn hàng của bạn gồm có:</b> " + productList.toString() + "</p>"
                        + "<p>- <b>Phương thức thanh toán:</b> COD (Thanh toán khi nhận hàng)</p>"
                        + "<p>- <b>Trạng thái:</b> Confirmed (Đã xác nhận)</p>"
                        + "<p style=\"margin-top:12px;\"><i>Cảm ơn quý khách!</i></p>";
            }

            SendMail.send(order.getEmail(), subject, content, true);

            try {
                dal.UserDAO userDAO = new dal.UserDAO(); // cần có UserDAO
                String shipperEmail = userDAO.getEmailByUserId(shipperID); // bạn cần viết hàm này

                String shipperSubject = "Bạn có đơn hàng cần giao - Mã đơn hàng: " + orderID;

                // Ghép chi tiết đơn hàng
                productList.setLength(0);
                for (OrderItem item : order.getItems()) {
                    productList.append(item.getProductName())
                            .append(" (SL: ")
                            .append(item.getQuantity())
                            .append("), ");
                }
                if (productList.length() > 0) {
                    productList.setLength(productList.length() - 2); // Xóa dấu phẩy cuối
                }

                String shipperContent = ""
                        + "<p>- <b>Tên khách hàng:</b> " + order.getReceiverName() + "</p>"
                        + "<p>- <b>Địa chỉ:</b> " + order.getDeliveryAddress() + ", " + order.getDistrict() + "</p>"
                        + "<p>- <b>Số điện thoại:</b> " + order.getPhone() + "</p>"
                        + "<p>- <b>Chi tiết đơn hàng gồm có:</b> " + productList.toString() + "</p>";

                if ("QRPending".equalsIgnoreCase(currentStatus)) {
                    shipperContent += "<p>- <b>Loại đơn hàng:</b> Thanh toán trực tuyến (Đã thanh toán)</p>";
                } else {
                    shipperContent += "<p>- <b>Loại đơn hàng:</b> COD (Thanh toán khi nhận hàng)</p>";
                }

                SendMail.send(shipperEmail, shipperSubject, shipperContent, true);
            } catch (Exception e) {
                e.printStackTrace();
            }

            response.sendRedirect("orderSeller?message=confirmed");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("orderSeller.jsp?error=1");
        }
    }
}
