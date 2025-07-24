/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package vnpay;

import dal.CartDAO;
import dal.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Order;
import model.OrderItem;

/**
 *
 * @author HP
 */
public class VnpayReturn extends HttpServlet {

    OrderDAO orderDao = new OrderDAO();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            Map fields = new HashMap();
            for (Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = URLEncoder.encode((String) params.nextElement(), StandardCharsets.US_ASCII.toString());
                String fieldValue = URLEncoder.encode(request.getParameter(fieldName), StandardCharsets.US_ASCII.toString());
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    fields.put(fieldName, fieldValue);
                }
            }

            String vnp_SecureHash = request.getParameter("vnp_SecureHash");
            if (fields.containsKey("vnp_SecureHashType")) {
                fields.remove("vnp_SecureHashType");
            }
            if (fields.containsKey("vnp_SecureHash")) {
                fields.remove("vnp_SecureHash");
            }
            String signValue = Config.hashAllFields(fields);
            if (signValue.equalsIgnoreCase(vnp_SecureHash)) {

                String orderIdStr = request.getParameter("vnp_TxnRef");
                int orderId = Integer.parseInt(orderIdStr);

                boolean transSuccess = false;
                String status;
                if ("00".equals(request.getParameter("vnp_TransactionStatus"))) {
                    status = "QRPending";
                    transSuccess = true;
                    CartDAO cartDao = new CartDAO();
                    if (orderDao.isGuestOrder(orderId)) {

                        String guestId = request.getSession().getId();
                        cartDao.clearGuestCart(guestId);
                    } else {

                        int userId = orderDao.getUserIdByOrderId(orderId);
                        cartDao.clearCart(userId);
                    }

                    try {
                        Order order = orderDao.getOrderById(orderId);
                        // Lấy danh sách sp, ví dụ:
                        List<OrderItem> items = orderDao.getOrderItems(orderId);

                        StringBuilder productList = new StringBuilder();
                        for (OrderItem item : items) {
                            productList.append(item.getProductName())
                                    .append(" (SL: ")
                                    .append(item.getQuantity())
                                    .append("), ");
                        }
                        if (productList.length() > 0) {
                            productList.setLength(productList.length() - 2); // xóa dấu phẩy cuối
                        }

                        String subject = "Bạn đã đặt hàng thành công - Mã đơn hàng: " + orderId;

                        String content = ""
                                + "<p>- <b>Tên khách hàng:</b> " + order.getReceiverName() + "</p>"
                                + "<p>- <b>Địa chỉ:</b> " + order.getDeliveryAddress() + ", " + order.getDistrict() + "</p>"
                                + "<p>- <b>Tổng tiền:</b> " + String.format("%,.0f", order.getTotalAmount()) + " đ</p>"
                                + "<p>- <b>Đơn hàng của bạn gồm có:</b> " + productList.toString() + "</p>"
                                + "<p>- <b>Phương thức thanh toán:</b> Thanh toán trực tuyến (Đã thanh toán)</p>"
                                + "<p>- <b>Trạng thái:</b> Pending (Đang chờ duyệt)</p>"
                                + "<p style=\"margin-top:12px;\"><i>Cảm ơn quý khách!</i></p>";

                        controller.SendMail.send(order.getEmail(), subject, content, true);

                        try {
                            dal.UserDAO userDAO = new dal.UserDAO(); // Tạo mới UserDAO
                            List<String> sellerEmails = userDAO.getEmailsByRoleId(4); // Tạo hàm này như đã hướng dẫn

                            String sellerSubject = "Đã có Order cần bạn xác nhận - Mã order: " + orderId;
                            String sellerContent = ""
                                    + "<p>- <b>Tên người đặt order:</b> " + order.getReceiverName() + "</p>"
                                    + "<p>- <b>Tổng tiền và Loại đơn hàng:</b> " + String.format("%,.0f", order.getTotalAmount()) + " đ</p>"
                                    + "<p>- <b>Loại đơn hàng:</b> Thanh toán trực tuyến(Đã thanh toán)</p>";

                            for (String sellerEmail : sellerEmails) {
                                controller.SendMail.send(sellerEmail, sellerSubject, sellerContent, true);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }

                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                } else {
                    status = "Failed";
                }

                orderDao.updateOrderStatus(orderId, status);

                request.setAttribute("transResult", transSuccess);
                request.setAttribute("orderId", orderId);
                request.getRequestDispatcher("paymentResult.jsp").forward(request, response);
            } else {

                System.out.println("GD KO HOP LE (invalid signature)");
                request.setAttribute("transResult", false);
                request.setAttribute("orderId", "");
                request.getRequestDispatcher("paymentResult.jsp").forward(request, response);
            }

        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
