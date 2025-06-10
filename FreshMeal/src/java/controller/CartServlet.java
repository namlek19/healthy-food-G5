package controller;

import model.*;
import dal.ProductDAO;
import jakarta.servlet.http.HttpSession;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/add-to-cart")
public class CartServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("id"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        Product product = productDAO.getProductById(productId);
        if (product == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        HttpSession session = request.getSession();
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) cart = new ArrayList<>();

        boolean found = false;
        for (CartItem item : cart) {
            if (item.getProduct().getProductID() == product.getProductID()) {
                item.setQuantity(item.getQuantity() + quantity);
                found = true;
                break;
            }
        }

        if (!found) cart.add(new CartItem(product, quantity));
        session.setAttribute("cart", cart);

        response.sendRedirect("cart.jsp");
    }
}
