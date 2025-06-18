package controller;

import model.Order;
import dal.OrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/order-info")
public class OrderInfoServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String oid = request.getParameter("orderId");
        if (oid == null) {
            response.sendRedirect("order-history");
            return;
        }
        int orderId;
        try {
            orderId = Integer.parseInt(oid);
        } catch (NumberFormatException e) {
            response.sendRedirect("order-history");
            return;
        }

        
        OrderDAO orderDAO = new OrderDAO();
        Order order = orderDAO.getOrderById(orderId);

        if (order == null) {
            response.sendRedirect("order-history");
            return;
        }

        
        HttpSession session = request.getSession();
        model.User user = (model.User) session.getAttribute("user");
        if (user == null || (order.getUserID() > 0 && user.getUserID() != order.getUserID())) {
            
            response.sendRedirect("order-history");
            return;
        }

        request.setAttribute("order", order);
        request.getRequestDispatcher("order-info.jsp").forward(request, response);
    }
}
