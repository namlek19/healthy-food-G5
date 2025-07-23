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
import model.Menu;

/**
 *
 * @author DuyHung
 */
public class RejectReasonServlet extends HttpServlet {

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
            out.println("<title>Servlet RejectReasonServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RejectReasonServlet at " + request.getContextPath() + "</h1>");
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
        int menuId = Integer.parseInt(request.getParameter("menuId"));
        String action = request.getParameter("action");

        // Gửi sang JSP để nhập lý do
        request.setAttribute("menuId", menuId);
        request.setAttribute("action", action);
        request.getRequestDispatcher("reject_reason.jsp").forward(request, response);
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
        int menuId = Integer.parseInt(request.getParameter("menuId"));
        String action = request.getParameter("action");
        String reason = request.getParameter("reason");

        MenuDAO dao = new MenuDAO();
        Menu menu = dao.getMenuById(menuId);
        String menuName = menu.getMenuName();
        int nutritionistId = menu.getNutritionistID();
        String nutritionistEmail = dao.getEmailByUserId(nutritionistId);

        boolean updated = false;
        String msg = "";

        switch (action) {
            case "reject":
                updated = dao.deleteMenuWithResult(menuId);
                msg = updated ? "Đã từ chối menu!" : "Từ chối menu thất bại!";
                if (updated) {
                    String subject = "Manager đã từ chối yêu cầu duyệt combo của bạn: \"" + menuName + "\" - ID " + menuId;
                    String content = "Xin chào,\n\nManager đã từ chối yêu cầu duyệt combo của bạn: \"" + menuName + "\" - ID " + menuId
                            + "\nLý do từ chối: " + reason;
                    SendMail.send(nutritionistEmail, subject, content, false);
                }
                break;

            case "rejectDeleteRequest":
                updated = dao.updateMenuStatus(menuId, 3);
                msg = updated ? "Đã từ chối yêu cầu xóa." : "Không thể cập nhật lại trạng thái!";
                if (updated) {
                    String subject = "Manager đã từ chối yêu cầu xóa combo của bạn: \"" + menuName + "\" - ID " + menuId;
                    String content = "Xin chào,\n\nManager đã từ chối yêu cầu xóa combo của bạn: \"" + menuName + "\" - ID " + menuId
                            + "\nLý do từ chối: " + reason;
                    SendMail.send(nutritionistEmail, subject, content, false);
                }
                break;

            case "rejectEditRequest":
                updated = dao.rejectSuaMenuWithResult(menuId);
                msg = updated ? "Đã từ chối chỉnh sửa!" : "Từ chối chỉnh sửa thất bại!";
                if (updated) {
                    String subject = "Manager đã từ chối yêu cầu sửa combo của bạn: \"" + menuName + "\" - ID " + menuId;
                    String content = "Xin chào,\n\nManager đã từ chối yêu cầu sửa combo của bạn: \"" + menuName + "\" - ID " + menuId
                            + "\nLý do từ chối: " + reason;
                    SendMail.send(nutritionistEmail, subject, content, false);
                }
                break;
        }

        request.getSession().setAttribute(updated ? "successMsg" : "errorMsg", msg);
        response.sendRedirect("pending-menu.jsp");
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
