package controller;

import dal.OrderDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

public class RejectOrderServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int orderID = Integer.parseInt(request.getParameter("orderID"));

            OrderDAO dao = new OrderDAO();
            dao.deleteOrder(orderID);

            response.sendRedirect("orderSeller.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("orderSeller.jsp?error=1");
        }
    }
}
