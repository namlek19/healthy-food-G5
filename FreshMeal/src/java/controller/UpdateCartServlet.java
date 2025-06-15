package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.util.List;
import model.*;
import dal.CartDAO;

@WebServlet(name="UpdateCartServlet", urlPatterns={"/UpdateCartServlet"})
public class UpdateCartServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int productId = Integer.parseInt(request.getParameter("id"));

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
    
            try {
                List<CartItem> dbCart = cartDAO.getCartItemsByUser(user.getUserID());
                for (CartItem item : dbCart) {
                    if (item.getProduct().getProductID() == productId) {
                        switch (action) {
                            case "inc":
                                cartDAO.addOrUpdateCartItem(user.getUserID(), productId, 1);
                                break;
                            case "dec":
                                if (item.getQuantity() > 1) {
                                    cartDAO.addOrUpdateCartItem(user.getUserID(), productId, -1);
                                }
                                break;
                            case "remove":
                                cartDAO.removeItem(user.getUserID(), productId);
                                break;
                        }
                        break;
                    }
                }
                // Cập nhật lại session cart
                session.setAttribute("cart", cartDAO.getCartItemsByUser(user.getUserID()));
            } catch (Exception e) {
                e.printStackTrace();
            }

        } else {
           
            List<CartItem> guestCart = (List<CartItem>) session.getAttribute("guest_cart");
            if (guestCart != null) {
                for (int i = 0; i < guestCart.size(); i++) {
                    CartItem item = guestCart.get(i);
                    if (item.getProduct().getProductID() == productId) {
                        switch (action) {
                            case "inc":
                                item.setQuantity(item.getQuantity() + 1);
                                break;
                            case "dec":
                                if (item.getQuantity() > 1) {
                                    item.setQuantity(item.getQuantity() - 1);
                                }
                                break;
                            case "remove":
                                guestCart.remove(i);
                                break;
                        }
                        break;
                    }
                }
                session.setAttribute("guest_cart", guestCart);
            }
        }

        response.sendRedirect("cart.jsp");
    }
}
