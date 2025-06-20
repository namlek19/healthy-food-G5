package controller;

import model.*;
import dal.ProductDAO;
import dal.CartDAO;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class CartServlet extends HttpServlet {
    private ProductDAO productDAO;
    private CartDAO cartDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        cartDAO = new CartDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String quantityParam = request.getParameter("quantity");
        String redirect = request.getParameter("redirect");

        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        int productId = Integer.parseInt(idParam);
        int quantity = 1; // default

        if (quantityParam != null) {
            try {
                quantity = Integer.parseInt(quantityParam);
            } catch (NumberFormatException e) {
                quantity = 1;
            }
        }

        Product product = productDAO.getProductById(productId);
        if (product == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            // USER LOGIN: add/update cart in DB, sync session "cart"
            try {
                cartDAO.addOrUpdateCartItem(user.getUserID(), productId, quantity);
                List<CartItem> dbCart = cartDAO.getCartItemsByUser(user.getUserID());
                session.setAttribute("cart", dbCart);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            // GUEST: add/update cart in session "guest_cart"
            List<CartItem> guestCart = (List<CartItem>) session.getAttribute("guest_cart");
            if (guestCart == null) guestCart = new ArrayList<>();

            boolean found = false;
            for (CartItem item : guestCart) {
                if (item.getProduct().getProductID() == product.getProductID()) {
                    item.setQuantity(item.getQuantity() + quantity);
                    found = true;
                    break;
                }
            }
            if (!found) guestCart.add(new CartItem(product, quantity));
            session.setAttribute("guest_cart", guestCart);
        }

        session.setAttribute("msg", "✔ Đã thêm vào giỏ hàng!");

        if (redirect != null && !redirect.isEmpty()) {
            response.sendRedirect(redirect);
        } else {
            response.sendRedirect("cart.jsp");
        }
    }
}
