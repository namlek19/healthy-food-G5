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

            String subject = "Đã xác nhận đơn hàng của bạn - Mã đơn hàng: " + orderID;

            // Nội dung HTML
            String content = ""
                    + "<p>- <b>Tên khách hàng:</b> " + order.getReceiverName() + "</p>"
                    + "<p>- <b>Địa chỉ:</b> " + order.getDeliveryAddress() + ", " + order.getDistrict() + "</p>"
                    + "<p>- <b>Tổng tiền:</b> " + String.format("%,.0f", order.getTotalAmount()) + " đ</p>"
                    + "<p>- <b>Đơn hàng của bạn gồm có:</b> " + productList.toString() + "</p>"
                    + "<p>- <b>Phương thức thanh toán:</b> COD (Thanh toán khi nhận hàng)</p>"
                    + "<p>- <b>Trạng thái:</b> Confirmed (Đã xác nhận)</p>"
                    + "<p style=\"margin-top:12px;\"><i>Cảm ơn quý khách!</i></p>";

            // Gửi mail
            SendMail.send(order.getEmail(), subject, content, true);

            response.sendRedirect("orderSeller?message=confirmed");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("orderSeller.jsp?error=1");
        }
    }
}
