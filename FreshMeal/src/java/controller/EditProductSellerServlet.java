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
public class EditProductSellerServlet extends HttpServlet {

    private ProductDAO dao = new ProductDAO();

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
            out.println("<title>Servlet EditProductSellerServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet EditProductSellerServlet at " + request.getContextPath() + "</h1>");
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
        String pid = request.getParameter("id");
        if (pid != null && !pid.isEmpty()) {
            Product p = dao.getProductById(Integer.parseInt(pid));
            request.setAttribute("product", p);
            request.getRequestDispatcher("editProductSeller.jsp").forward(request, response);
        } else {
            response.sendRedirect("manageProductSeller"); // trang quản lý sản phẩm
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
        int productID = Integer.parseInt(request.getParameter("productID"));
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
            errorMessage = "Các trường Tên món, Mô tả, Thông tin dinh dưỡng, Nguồn gốc, Ảnh và Hướng dẫn bảo quản không được để trống!";
        } else {
            try {
                int calories = Integer.parseInt(caloriesStr);
                double price = Double.parseDouble(priceStr);

                if (calories <= 0 || price <= 0) {
                    errorMessage = "Calories và Giá phải lớn hơn 0!";
                } else {
                    // Hợp lệ → cập nhật sản phẩm
                    Product p = new Product(productID, name, description, nutritionInfo, origin, imageURL, storageInstructions, price, categoryID, calories);
                    dao.updateProduct(p);
                    response.sendRedirect("manageProductSeller?success=updated");
                    return;
                }
            } catch (NumberFormatException e) {
                errorMessage = "Calories và Giá phải là số hợp lệ!";
            }
        }

        // Nếu có lỗi → gán lại product cũ và forward lại trang
        Product oldProduct = dao.getProductById(productID);
        request.setAttribute("product", oldProduct);
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("editProductSeller.jsp").forward(request, response);
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
