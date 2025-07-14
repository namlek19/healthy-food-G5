/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.MenuDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author DuyHung
 */
public class RequestDeleteMenuServlet extends HttpServlet {

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
            out.println("<title>Servlet RequestDeleteMenuServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RequestDeleteMenuServlet at " + request.getContextPath() + "</h1>");
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

        int menuID = Integer.parseInt(request.getParameter("id"));
        // Không update status ở đây
        // Chỉ truyền menuID sang JSP để hiển thị
        request.setAttribute("menuID", menuID);
        request.getRequestDispatcher("request_delete_reason.jsp").forward(request, response);

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
        int menuID = Integer.parseInt(request.getParameter("menuID"));
        String reason = request.getParameter("reason");
        int userID = (Integer) request.getSession().getAttribute("userID");

        MenuDAO dao = new MenuDAO();

        // Cập nhật status = 4 (chờ duyệt xóa)
        boolean updated = dao.updateMenuStatus(menuID, 4);

        if (updated) {
            // Gửi mail cho tất cả manager
            String menuName = dao.getMenuById(menuID).getMenuName();
            String userName = dao.getUserNameByID(userID);
            String subject = "Yêu cầu xóa combo: " + menuName + " (ID " + menuID + ")";
            String content = "Nutritionist \"" + userName + "\" (UserID: " + userID + ") đã gửi yêu cầu xóa combo \""
                    + menuName + "\" (MenuID: " + menuID + ")\n"
                    + "Lý do: " + reason;

            List<String> managerEmails = dao.getAllManagerEmails(); // lấy danh sách email

            for (String email : managerEmails) {
                SendMail.send(email, subject, content);
            }
        }

        // Quay lại trang quản lý
        response.sendRedirect("menumanage");
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
