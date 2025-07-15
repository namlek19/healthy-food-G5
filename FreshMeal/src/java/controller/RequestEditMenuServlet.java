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
        request.setCharacterEncoding("UTF-8");
        int menuID = Integer.parseInt(request.getParameter("menuID"));
        String menuName = request.getParameter("menuName");
        String desc = request.getParameter("description");
        String img = request.getParameter("imageURL");
        String bmi = request.getParameter("bmiCategory");
        String reason = request.getParameter("reason");
        String selectedProductIDsStr = request.getParameter("selectedProductIDs");
        int nutritionistID = (Integer) request.getSession().getAttribute("userID");

        MenuDAO dao = new MenuDAO();

        
        request.setAttribute("menuID", menuID);
        request.setAttribute("menu", dao.getMenuById(menuID));
        request.setAttribute("selectedProductIDs", selectedProductIDsStr);

        
        if (img == null || img.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Bạn phải chọn ảnh cho thực đơn!");
            request.getRequestDispatcher("request_edit_menu.jsp").forward(request, response);
            return;
        }

        
        if (reason == null || reason.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Bạn phải nhập lý do gửi yêu cầu sửa!");
            request.getRequestDispatcher("request_edit_menu.jsp").forward(request, response);
            return;
        }

        
        if (selectedProductIDsStr == null || selectedProductIDsStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Bạn phải chọn ít nhất một món ăn trong thực đơn!");
            request.getRequestDispatcher("request_edit_menu.jsp").forward(request, response);
            return;
        }

        
        if (menuName == null || menuName.trim().isEmpty()
                || desc == null || desc.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Tên thực đơn và mô tả không được để trống!");
            request.getRequestDispatcher("request_edit_menu.jsp").forward(request, response);
            return;
        }

        // Thực hiện update lại thông tin menu
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
