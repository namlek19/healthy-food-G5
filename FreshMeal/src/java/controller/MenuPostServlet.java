/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.MenuDAO;
import dal.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Menu;
import model.Product;

/**
 *
 * @author DuyHung
 */
public class MenuPostServlet extends HttpServlet {

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
            out.println("<title>Servlet MenuPostServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MenuPostServlet at " + request.getContextPath() + "</h1>");
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
        ProductDAO productDAO = new ProductDAO();
        List<Product> productList = productDAO.getAllProduct();
        request.setAttribute("productList", productList);

        request.setAttribute("currentPage", "menupost");

        // Nếu cần: lấy thêm info BMI, profile...
        request.getRequestDispatcher("menu_post.jsp").forward(request, response);
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
        String menuName = request.getParameter("menuName");
        String description = request.getParameter("description");
        String bmiCategory = request.getParameter("bmiCategory");
        String imageURL = request.getParameter("imageURL");
        String selectedProductIDsStr = request.getParameter("selectedProductIDs");
        int nutritionistID = (Integer) request.getSession().getAttribute("userID");

        ProductDAO productDAO = new ProductDAO();
        List<Product> productList = productDAO.getAllProduct();
        request.setAttribute("productList", productList);
        request.setAttribute("currentPage", "menupost");

        if (selectedProductIDsStr == null || selectedProductIDsStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Bạn phải chọn ít nhất một món ăn!");
            request.getRequestDispatcher("menu_post.jsp").forward(request, response);
            return;
        }

        if (imageURL == null || imageURL.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Bạn phải chọn ảnh cho thực đơn!");
            request.getRequestDispatcher("menu_post.jsp").forward(request, response);
            return;
        }

        if (menuName == null || menuName.trim().isEmpty()
                || description == null || description.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Tên thực đơn và mô tả không được để trống!");
            request.getRequestDispatcher("menu_post.jsp").forward(request, response);
            return;
        }

        String[] productIDs = selectedProductIDsStr.split(",");

        Menu menu = new Menu();
        menu.setMenuName(menuName);
        menu.setDescription(description);
        menu.setBmiCategory(bmiCategory);
        menu.setImageURL(imageURL);
        menu.setNutritionistID(nutritionistID);

        MenuDAO menuDAO = new MenuDAO();
        int menuID = menuDAO.addMenu(menu);

        for (String pid : productIDs) {
            if (!pid.isEmpty()) { // tránh lỗi nếu có phần tử rỗng
                menuDAO.addMenuProduct(menuID, Integer.parseInt(pid));
            }
        }

        String userName = menuDAO.getUserNameByID(nutritionistID);

// Tạo tiêu đề và nội dung theo yêu cầu
        String subject = "Yêu cầu duyệt combo mới từ Nutritionist " + userName + " (UserID: " + nutritionistID + ")";
        String content = "Nutritionist " + userName + " (UserID: " + nutritionistID + ") đã gửi yêu cầu duyệt combo mới tên \"" + menuName + "\"";

// Gửi mail cho tất cả manager
        for (String email : menuDAO.getAllManagerEmails()) {
            SendMail.send(email, subject, content, false);
        }

//        response.sendRedirect("menupost");
        response.sendRedirect("menupost?success=true");

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
