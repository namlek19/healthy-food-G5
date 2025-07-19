package controller;

import dal.MenuDAO;
import dal.ProductDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Menu;
import model.Product;


public class SearchServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        if (keyword == null) keyword = "";
        keyword = keyword.trim().replaceAll("\\s+", " ");
        
        ProductDAO pdao = new ProductDAO();
        MenuDAO mdao = new MenuDAO();

        List<Product> searchedProducts = pdao.searchProductsByName(keyword.trim());
        List<Menu> searchedMenus = mdao.searchMenusByName(keyword.trim());

        request.setAttribute("searchedProducts", searchedProducts);
        request.setAttribute("searchedMenus", searchedMenus);
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher("search.jsp").forward(request, response);
    } 
}
