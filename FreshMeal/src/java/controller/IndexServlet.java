

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

public class IndexServlet extends HttpServlet {
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet IndexServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet IndexServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
         ProductDAO pdao = new ProductDAO();
        MenuDAO mdao = new MenuDAO();
        
        List<Product> newestProducts = pdao.getNewestProducts(4);
        List<Menu> newestMenus = mdao.getNewestApprovedMenus(4); 

        request.setAttribute("newestProducts", newestProducts);
        request.setAttribute("newestMenus", newestMenus);
        
        request.getRequestDispatcher("index.jsp").forward(request, response);
    } 
public static void main(String[] args) {
    ProductDAO pdao = new ProductDAO();
    MenuDAO mdao = new MenuDAO();

    List<Product> newestProducts = pdao.getNewestProducts(4);
    List<Menu> newestMenus = mdao.getNewestApprovedMenus(4);

    System.out.println("==== MÓN ĂN MỚI NHẤT ====");
    for (Product p : newestProducts) {
        System.out.println(p.getProductID() + " - " + p.getName() + " - " + p.getPrice());
    }

    System.out.println("\n==== COMBO MỚI NHẤT ====");
    for (Menu m : newestMenus) {
        System.out.println(m.getMenuID() + " - " + m.getMenuName() + " - " + m.getTotalPrice());
    }
}
    
}
