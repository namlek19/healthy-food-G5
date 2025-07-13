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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ProductDAO dao = new ProductDAO();
        List<Product> productList = dao.getAllProduct();

        request.setAttribute("productList", productList);
        request.setAttribute("currentPage", "manageProductSeller");
        request.getRequestDispatcher("manageProductSeller.jsp").forward(request, response);
    }
}