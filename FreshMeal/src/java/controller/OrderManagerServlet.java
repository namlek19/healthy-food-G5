/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Order;

public class OrderManagerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int PAGE_SIZE = 5;
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) {
        }
        if (page < 1) {
            page = 1;
        }

        OrderDAO orderDAO = new OrderDAO();
        int totalOrders = orderDAO.countAllOrders();
        int totalPage = (int) Math.ceil((double) totalOrders / PAGE_SIZE);

        if (page > totalPage && totalPage > 0) {
            page = totalPage;
        }

        List<Order> orders = orderDAO.getOrdersPaging((page - 1) * PAGE_SIZE, PAGE_SIZE);

        request.setAttribute("orders", orders);
        request.setAttribute("page", page);
        request.setAttribute("totalPage", totalPage);

        request.getRequestDispatcher("orderManager.jsp").forward(request, response);
    }
}
