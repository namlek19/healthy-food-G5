package controller;

import dal.OrderDAO;
import dal.OrderItemDAO;
import model.Order;
import model.OrderItem;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/ShipperOrderServlet")
public class ShipperOrderServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User shipper = (User) session.getAttribute("user");

        if (shipper == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int shipperID = shipper.getUserID();

        OrderDAO orderDAO = new OrderDAO();
        OrderItemDAO orderItemDAO = new OrderItemDAO();

      
        List<Order> codOrders = orderDAO.getAllCODOrdersByShipperID(shipperID);
        for (Order order : codOrders) {
            List<OrderItem> items = orderItemDAO.getItemsByOrderId(order.getOrderID());
            order.setItems(items);
        }

       
        List<Order> qrOrders = orderDAO.getAllQROrdersByShipperID(shipperID);
        for (Order order : qrOrders) {
            List<OrderItem> items = orderItemDAO.getItemsByOrderId(order.getOrderID());
            order.setItems(items);
        }

        request.setAttribute("orders", codOrders);
        request.setAttribute("QRorders", qrOrders);
        request.getRequestDispatcher("shipper-orders.jsp").forward(request, response);
    }
}
