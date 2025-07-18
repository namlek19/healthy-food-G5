package controller;

import dal.OrderDAO;
import model.Order;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import model.User;

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

        OrderDAO dao = new OrderDAO();
        List<Order> orders = dao.getAllCODOrdersByShipperID(shipperID);
        List<Order> QRorders = dao.getAllQROrdersByShipperID(shipperID);

        request.setAttribute("orders", orders);
        request.setAttribute("QRorders", QRorders);
        request.getRequestDispatcher("shipper-orders.jsp").forward(request, response);
    }
}
    