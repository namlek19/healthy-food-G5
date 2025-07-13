package controller;

import dal.OrderDAO;
import model.Order;
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

        OrderDAO dao = new OrderDAO();
        List<Order> orders = dao.getAllOrders();  // hoặc getOrdersForShipper() nếu có phân quyền

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("shipper-orders.jsp").forward(request, response);
    }
}
