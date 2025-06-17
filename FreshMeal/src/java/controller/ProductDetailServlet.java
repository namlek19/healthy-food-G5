package controller;

import dal.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

public class ProductDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        
        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("error", "Không có ID sản phẩm hợp lệ!");
            request.getRequestDispatcher("ProductDetail.jsp").forward(request, response);
            return;
        }
        int id;
        try {
            id = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID sản phẩm không hợp lệ!");
            request.getRequestDispatcher("ProductDetail.jsp").forward(request, response);
            return;
        }

        ProductDAO dao = new ProductDAO();
        Product product = dao.getProductById(id);

        
        String catName = "Khác";
        if (product != null) {
            switch(product.getCategoryID()) {
                case 1: catName = "Món chính"; break;
                case 2: catName = "Món phụ"; break;
                case 3: catName = "Tráng miệng"; break;
                case 4: catName = "Đồ uống"; break;
            }
        }
        request.setAttribute("product", product);
        request.setAttribute("catName", catName);

        request.getRequestDispatcher("ProductDetail.jsp").forward(request, response);
    }
}
