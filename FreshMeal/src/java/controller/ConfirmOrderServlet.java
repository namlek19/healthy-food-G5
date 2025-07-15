package controller;

import dal.OrderDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ConfirmOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int orderID = Integer.parseInt(request.getParameter("orderID"));
            int shipperID = Integer.parseInt(request.getParameter("shipperID"));
            String currentStatus = request.getParameter("currentStatus");  // lấy status hiện tại từ form

            OrderDAO dao = new OrderDAO();

            if ("QRPending".equalsIgnoreCase(currentStatus)) {
                dao.confirmOrderWithStatus(orderID, shipperID, "QRConfirmed");
            } else {
                dao.confirmOrderWithStatus(orderID, shipperID, "Confirmed");
            }

            response.sendRedirect("orderSeller?message=confirmed");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("orderSeller.jsp?error=1");
        }
    }
}