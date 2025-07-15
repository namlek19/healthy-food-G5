package controller;

import dal.OrderDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Order;
import model.User;

import java.io.IOException;
import java.util.List;

public class OrderDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int orderID = Integer.parseInt(request.getParameter("orderID"));
        OrderDAO odao = new OrderDAO();
        UserDAO udao = new UserDAO();

        Order order = odao.getOrderById(orderID);
        User buyer = udao.getUserByID(order.getUserID());
        List<User> shippers = udao.getAllShippers();

        request.setAttribute("order", order);
        request.setAttribute("buyer", buyer);
        request.setAttribute("shippers", shippers);
        request.getRequestDispatcher("orderDetail.jsp").forward(request, response);
    }
}
