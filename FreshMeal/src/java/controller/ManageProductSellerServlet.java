package controller;

import dal.ProductDAO;
import model.Product;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ManageProductSellerServlet extends HttpServlet {
    private static final int PAGE_SIZE = 10;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String strPage = request.getParameter("page");
        int page = 1;
        try {
            page = Integer.parseInt(strPage);
        } catch(Exception e){ }

        if(page < 1) page = 1;
        
        
        ProductDAO dao = new ProductDAO();
        int totalProduct = dao.countAllProduct();
        int totalPages = (int) Math.ceil((double) totalProduct / PAGE_SIZE);
        if(page > totalPages && totalPages > 0) page = totalPages;
        int offset = (page - 1) * PAGE_SIZE;
        
        List<Product> productList = dao.getAllProductPaging(offset, PAGE_SIZE);

        request.setAttribute("productList", productList);
        request.setAttribute("currentPage", "manageProductSeller");
        request.setAttribute("pageIndex", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("offset", offset);
        request.getRequestDispatcher("manageProductSeller.jsp").forward(request, response);
    }
}