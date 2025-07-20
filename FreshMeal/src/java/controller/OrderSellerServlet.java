package controller;

import dal.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Order;

import java.io.IOException;
import java.util.List;

public class OrderSellerServlet extends HttpServlet {

    private static final int PAGE_SIZE = 3;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int pageCOD = 1, pageQR = 1; 
        try {
            pageCOD = Integer.parseInt(request.getParameter("pageCOD"));
        } catch (Exception e) {
        }
        try {
            pageQR = Integer.parseInt(request.getParameter("pageQR"));
        } catch (Exception e) {
        }

        OrderDAO odao = new OrderDAO();
        
        int totalCOD = odao.countOrdersByStatus("Pending");
        int totalPageCOD = (int) Math.ceil((double) totalCOD / PAGE_SIZE);
        if (pageCOD < 1) {
            pageCOD = 1;
        }
        if (pageCOD > totalPageCOD && totalPageCOD > 0) {
            pageCOD = totalPageCOD;
        }

        List<Order> pendingOrders = odao.getOrdersByStatusPaging("Pending", (pageCOD - 1) * PAGE_SIZE, PAGE_SIZE);

        
        int totalQR = odao.countOrdersByStatus("QRPending");
        int totalPageQR = (int) Math.ceil((double) totalQR / PAGE_SIZE);
        if (pageQR < 1) {
            pageQR = 1;
        }
        if (pageQR > totalPageQR && totalPageQR > 0) {
            pageQR = totalPageQR;
        }

        List<Order> pendingQROrders = odao.getOrdersByStatusPaging("QRPending", (pageQR - 1) * PAGE_SIZE, PAGE_SIZE);

        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("pendingQROrders", pendingQROrders);

        request.setAttribute("pageCOD", pageCOD);
        request.setAttribute("totalPageCOD", totalPageCOD);
        request.setAttribute("pageQR", pageQR);
        request.setAttribute("totalPageQR", totalPageQR);

        request.getRequestDispatcher("orderSeller.jsp").forward(request, response);
    }
}
