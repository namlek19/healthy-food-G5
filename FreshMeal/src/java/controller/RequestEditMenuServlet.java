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

/**
 *
 * @author DuyHung
 */
public class RequestEditMenuServlet extends HttpServlet {

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
            out.println("<title>Servlet RequestEditMenuServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RequestEditMenuServlet at " + request.getContextPath() + "</h1>");
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
        int menuID = Integer.parseInt(request.getParameter("menuID"));
        MenuDAO dao = new MenuDAO();

        boolean copied = dao.copyMenuToSuaMenu(menuID);
        if (copied) {
            // Chuyển sang trang sửa
            response.sendRedirect("request_edit_menu.jsp?menuID=" + menuID);
        } else {
            response.sendRedirect("error.jsp");
        }
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
        String menuName = request.getParameter("menuName");
        String desc = request.getParameter("description");
        String img = request.getParameter("imageURL");
        String bmi = request.getParameter("bmiCategory");
        String reason = request.getParameter("reason");
        int nutritionistID = (Integer) request.getSession().getAttribute("userID");

        MenuDAO dao = new MenuDAO();
        dao.updateSuaMenu(menuID, menuName, desc, img, bmi);

        String tenmenu = dao.getMenuById(menuID).getMenuName();
        String userName = dao.getUserNameByID(nutritionistID);
        String subject = "Yêu cầu sửa combo: " + tenmenu + " (ID " + menuID + ")";
        String content = "Nutritionist \"" + userName + "\" (UserID: " + nutritionistID + ") đã gửi yêu cầu sửa combo \""
                + tenmenu + "\" (MenuID: " + menuID + ")\n"
                + "Lý do: " + reason;

        for (String email : dao.getAllManagerEmails()) {
            SendMail.send(email, subject, content);
        }

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
