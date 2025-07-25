/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.ProductDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

/**
 *
 * @author DuyHung
 */
public class AddProductSellerServlet extends HttpServlet {

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
            out.println("<title>Servlet AddProductSellerServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddProductSellerServlet at " + request.getContextPath() + "</h1>");
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String nutritionInfo = request.getParameter("nutritionInfo");
        String origin = request.getParameter("origin");
        String imageURL = request.getParameter("imageURL");
        String storageInstructions = request.getParameter("storageInstructions");
        String caloriesStr = request.getParameter("calories");
        String priceStr = request.getParameter("price");
        int categoryID = Integer.parseInt(request.getParameter("categoryID"));

        String errorMessage = null;

        if (name == null || name.trim().isEmpty()
                || description == null || description.trim().isEmpty()
                || nutritionInfo == null || nutritionInfo.trim().isEmpty()
                || origin == null || origin.trim().isEmpty()
                || imageURL == null || imageURL.trim().isEmpty()
                || storageInstructions == null || storageInstructions.trim().isEmpty()) {
            errorMessage = "Tên món, Mô tả, Thông tin dinh dưỡng, Nguồn gốc, Ảnh và Hướng dẫn bảo quản không được để trống!";
        } else {
            try {
                int calories = Integer.parseInt(caloriesStr);
                double price = Double.parseDouble(priceStr);

                if (calories <= 0 || price <= 0) {
                    errorMessage = "Calories và Giá phải lớn hơn 0!";
                } else {
                    // Hợp lệ → thêm sản phẩm
                    Product p = new Product();
                    p.setName(name);
                    p.setDescription(description);
                    p.setCalories(calories);
                    p.setNutritionInfo(nutritionInfo);
                    p.setOrigin(origin);
                    p.setImageURL(imageURL);
                    p.setStorageInstructions(storageInstructions);
                    p.setPrice(price);
                    p.setCategoryID(categoryID);

                    ProductDAO dao = new ProductDAO();
                    dao.insertProduct(p);

                    response.sendRedirect("manageProductSeller");
                    return;
                }
            } catch (NumberFormatException e) {
                errorMessage = "Calories và Giá phải là số hợp lệ!";
            }
        }

        // Nếu có lỗi → gửi lại trang với thông báo
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("addProductSeller.jsp").forward(request, response);
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
