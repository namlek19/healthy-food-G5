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

public class ProductListServlet extends HttpServlet {

    private static final int PAGE_SIZE = 9;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String category = request.getParameter("category");
        String strPage = request.getParameter("page");
        int page = 1;
        try {
            page = Integer.parseInt(strPage);
        } catch (Exception e) {
        }

        if (page < 1) {
            page = 1;
        }

        ProductDAO dao = new ProductDAO();
        int totalProducts = dao.countProductByCategory(category);
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);

        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        int offset = (page - 1) * PAGE_SIZE;

        List<Product> productList = dao.getProductByCategoryPaging(category, offset, PAGE_SIZE);

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
        request.setAttribute("category", category);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("ProductList.jsp").forward(request, response);
    }

}
