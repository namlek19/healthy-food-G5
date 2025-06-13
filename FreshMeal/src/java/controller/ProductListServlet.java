
package controller;

import dal.ProductDAO;
import model.Product;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
/**
 *
 * @author ducna
 */
public class ProductListServlet extends HttpServlet {
   
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
            out.println("<title>Servlet ProductListServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProductListServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
         String category = request.getParameter("category");

        ProductDAO dao = new ProductDAO();
        List<Product> productList = dao.getProductByCategory(category);

        String categoryName;
        switch (category != null ? category : "") {
            case "1":
                categoryName = "Món chính";
                break;
            case "2":
                categoryName = "Món phụ";
                break;
            case "3":
                categoryName = "Tráng miệng";
                break;
            case "4":
                categoryName = "Đồ uống";
                break;
            default:
                categoryName = "Tất cả món ăn";
        }

        request.setAttribute("productList", productList);
        request.setAttribute("categoryName", categoryName);
        request.getRequestDispatcher("ProductList.jsp").forward(request, response);
    }
    
}
