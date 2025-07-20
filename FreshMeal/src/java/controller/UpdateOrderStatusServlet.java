/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;

/**
 *
 * @author admin
 */
@WebServlet(name = "UpdateOrderStatusServlet", urlPatterns = {"/UpdateOrderStatusServlet"})
public class UpdateOrderStatusServlet extends HttpServlet {

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
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpdateOrderStatusServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpdateOrderStatusServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String newStatus = request.getParameter("status");

        OrderDAO dao = new OrderDAO();
        dao.updateOrderStatus(orderId, newStatus);

        try {
            // Lấy lại thông tin đơn hàng
            Order order = dao.getOrderById(orderId);

            // Ghép danh sách món ăn
            StringBuilder productList = new StringBuilder();
            for (model.OrderItem item : order.getItems()) {
                productList.append(item.getProductName())
                        .append(" (SL: ")
                        .append(item.getQuantity())
                        .append("), ");
            }
            if (productList.length() > 0) {
                productList.setLength(productList.length() - 2); // Xóa dấu phẩy cuối
            }

            // Tạo tiêu đề và nội dung dựa trên trạng thái
            String subject = "";
            String statusText = "";
            if ("Delivering".equalsIgnoreCase(newStatus) || "QRDelivering".equalsIgnoreCase(newStatus)) {
                subject = "Đơn hàng của bạn đang được giao - Mã đơn hàng: " + orderId;
                statusText = "Delivering (Đang giao)";
            } else if ("Delivered".equalsIgnoreCase(newStatus) || "QRDelivered".equalsIgnoreCase(newStatus)) {
                subject = "Đơn hàng đã được giao - Mã đơn hàng: " + orderId;
                statusText = "Delivered (Đã giao)";
            }

            String content = ""
                    + "<p>- <b>Tên khách hàng:</b> " + order.getReceiverName() + "</p>"
                    + "<p>- <b>Địa chỉ:</b> " + order.getDeliveryAddress() + ", " + order.getDistrict() + "</p>"
                    + "<p>- <b>Tổng tiền:</b> " + String.format("%,.0f", order.getTotalAmount()) + " đ</p>"
                    + "<p>- <b>Đơn hàng của bạn gồm có:</b> " + productList.toString() + "</p>"
                    + "<p>- <b>Trạng thái:</b> " + statusText + "</p>"
                    + "<p style=\"margin-top:12px;\"><i>Cảm ơn quý khách!</i></p>";

            // Gửi mail
            SendMail.send(order.getEmail(), subject, content, true);

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("ShipperOrderServlet"); // reload
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
