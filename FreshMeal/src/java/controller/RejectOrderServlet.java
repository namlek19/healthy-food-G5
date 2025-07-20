package controller;

import dal.OrderDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.Order;

public class RejectOrderServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int orderID = Integer.parseInt(request.getParameter("orderID"));
            OrderDAO dao = new OrderDAO();

            // Trước khi xóa, lấy thông tin order để gửi mail
            Order order = dao.getOrderById(orderID);
            if (order != null) {
                String to = order.getEmail();
                String subject = "Đơn hàng của bạn đã bị từ chối - Mã đơn hàng #" + orderID;
                String content = "Cửa hàng đã liên hệ để thông báo lý do cho quý khách. "
                        + "Trong trường hợp chưa nhận được thông tin, chúng tôi sẽ sớm liên hệ lại.";
                SendMail.send(to, subject, content, false);
            }

            dao.deleteOrder(orderID);

            response.sendRedirect("orderSeller");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("orderSeller.jsp?error=1");
        }
    }
}
