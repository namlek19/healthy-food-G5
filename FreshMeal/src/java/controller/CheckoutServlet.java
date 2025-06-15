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
        // Nhận thông tin từ form
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String district = request.getParameter("district");
        String address = request.getParameter("address");
        String method = request.getParameter("method");

        HttpSession session = request.getSession();
        // Lấy đúng cart: user hay guest
        User user = (User) session.getAttribute("user");
        List<CartItem> cart = (List<CartItem>) session.getAttribute(user != null ? "cart" : "guest_cart");

        // Kiểm tra giỏ hàng
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        if ("cod".equals(method)) {
            // Tính tổng tiền
            double total = 0;
            for (CartItem item : cart) {
                total += item.getTotalPrice();
            }

            // Tạo đối tượng Order
            Order order = new Order();
            order.setUserID(user != null ? user.getUserID() : null); // Nếu là guest có thể để null hoặc 0 tùy DB
            order.setReceiverName(fullname);
            order.setDeliveryAddress(address);
            order.setDistrict(district);
            order.setTotalAmount(total);
            order.setStatus("Chờ xác nhận");
            order.setOrderDate(new Date()); // Lấy ngày hiện tại

            // Lưu order và các món vào DB
            OrderDAO orderDAO = new OrderDAO();
            int orderId = orderDAO.createOrder(order, cart);

            // Xóa giỏ hàng khỏi session
            session.removeAttribute("cart");
            session.removeAttribute("guest_cart");

            // Nếu user đã login, xóa cả cart trên DB (nếu bạn có lưu DB)
            if (user != null) {
                try {
                    CartDAO cartDAO = new CartDAO();
                    cartDAO.clearCart(user.getUserID());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            // Gửi orderId sang trang thành công nếu cần
            session.setAttribute("orderId", orderId);

            // Chuyển sang trang xác nhận thành công
            response.sendRedirect("success.jsp");

        } else if ("vnpay".equals(method)) {
            // Chưa xử lý thanh toán VNPAY
            response.sendRedirect("checkout.jsp?error=VNPAY chưa được hỗ trợ. Hãy chọn thanh toán khi nhận hàng.");
        } else {
            // Không chọn phương thức
            response.sendRedirect("checkout.jsp?error=Vui lòng chọn phương thức thanh toán.");
        }
    }
}
