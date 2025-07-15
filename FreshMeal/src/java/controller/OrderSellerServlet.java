package controller;

import dal.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Order;

import java.io.IOException;
import java.util.List;

public class OrderSellerServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        OrderDAO odao = new OrderDAO();
        List<Order> pendingOrders = odao.getOrdersByStatus("Pending");
        List<Order> pendingQROrders = odao.getOrdersByStatus("QRPending");

        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("pendingQROrders", pendingQROrders);
        request.getRequestDispatcher("orderSeller.jsp").forward(request, response);
    }
}