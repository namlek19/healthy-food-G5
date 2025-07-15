package controller;

import dal.OrderDAO;
import dal.CartDAO;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Date;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String district = request.getParameter("district");
        String address = request.getParameter("address");
        String method = request.getParameter("method");
        String addressOption = request.getParameter("addressOption");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        List<CartItem> cart = (List<CartItem>) session.getAttribute(user != null ? "cart" : "guest_cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        if ("profile".equals(addressOption)) {
            if (user != null) {
                address = user.getAddress();
                district = user.getDistrict();
            }
        }

        double total = 0;
        for (CartItem item : cart) {
            total += item.getTotalPrice();
        }

        Order order = new Order();
        order.setUserID(user != null ? user.getUserID() : 0);
        order.setReceiverName(fullname);
        order.setPhone(phone);
        order.setDeliveryAddress(address);
        order.setDistrict(district);
        order.setTotalAmount(total);
        order.setOrderDate(new Date());
        order.setEmail(email);
        order.setStatus("Pending");

        OrderDAO orderDAO = new OrderDAO();

        if ("cod".equals(method)) {
            int orderId = orderDAO.createOrder(order, cart);

            session.removeAttribute("cart");
            session.removeAttribute("guest_cart");

            if (user != null) {
                try {
                    CartDAO cartDAO = new CartDAO();
                    cartDAO.clearCart(user.getUserID());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            session.setAttribute("orderId", orderId);
            response.sendRedirect("success.jsp");
        } else if ("vnpay".equals(method)) {
            order.setStatus("Chờ thanh toán VNPay");
            int orderId = orderDAO.createOrder(order, cart);

            session.setAttribute("vnp_orderId", orderId);
            response.sendRedirect("ajaxServlet?orderId=" + orderId);
        } else {
            response.sendRedirect("checkout.jsp?error=Vui lòng chọn phương thức thanh toán.");
        }
    }
}
