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
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<h1>Servlet AddProductSellerServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
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
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Lấy dữ liệu từ form
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        int calories = Integer.parseInt(request.getParameter("calories"));
        String nutritionInfo = request.getParameter("nutritionInfo");
        String origin = request.getParameter("origin");
        String imageURL = request.getParameter("imageURL"); // nhập tay
        String storageInstructions = request.getParameter("storageInstructions");
        double price = Double.parseDouble(request.getParameter("price"));
        int categoryID = Integer.parseInt(request.getParameter("categoryID"));

        // Tạo đối tượng Product
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

        // Gọi DAO để insert
        ProductDAO dao = new ProductDAO();
        dao.insertProduct(p);

        // Sau khi thêm, chuyển hướng về trang danh sách sản phẩm (tạm placeholder)
        response.sendRedirect("manageProductSeller"); 
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
