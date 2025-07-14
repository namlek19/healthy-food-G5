
package controller;

import model.*;
import dal.ProductDAO;
import dal.CartDAO;
import dal.MenuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;


public class CartServlet extends HttpServlet {
    private ProductDAO productDAO;
    private CartDAO cartDAO;
    private MenuDAO menuDAO;

    @Override
    public void init() {
        productDAO = new ProductDAO();
        cartDAO = new CartDAO();
        menuDAO = new MenuDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productIdParam = request.getParameter("id");
        String menuIdParam = request.getParameter("menu_id");
        String quantityParam = request.getParameter("quantity");
        String redirect = request.getParameter("redirect");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        int quantity = 1;

        if (quantityParam != null) {
            try {
                quantity = Integer.parseInt(quantityParam);
            } catch (NumberFormatException ignored) {
                quantity = 1;
            }
        }

        if (menuIdParam != null) {
           
            int menuId = Integer.parseInt(menuIdParam);
            Menu menu = menuDAO.getMenuById(menuId);
            if (menu != null) {
                List<Product> products = menu.getProducts();
                if (user != null) {
                    for (Product p : products) {
                        cartDAO.addOrUpdateCartItem(user.getUserID(), p.getProductID(), 1);
                    }
                    session.setAttribute("cart", cartDAO.getCartItemsByUser(user.getUserID()));
                } else {
                    List<CartItem> guestCart = (List<CartItem>) session.getAttribute("guest_cart");
                    if (guestCart == null) guestCart = new ArrayList<>();
                    for (Product p : products) {
                        boolean found = false;
                        for (CartItem item : guestCart) {
                            if (item.getProduct().getProductID() == p.getProductID()) {
                                item.setQuantity(item.getQuantity() + 1);
                                found = true;
                                break;
                            }
                        }
                        if (!found) guestCart.add(new CartItem(p, 1));
                    }
                    session.setAttribute("guest_cart", guestCart);
                }
                session.setAttribute("msg", "✔ Đã thêm toàn bộ thực đơn vào giỏ hàng!");
            }
        } else if (productIdParam != null) {
            // Adding single product
            int productId = Integer.parseInt(productIdParam);
            Product product = productDAO.getProductById(productId);
            if (product != null) {
                if (user != null) {
                    cartDAO.addOrUpdateCartItem(user.getUserID(), productId, quantity);
                    session.setAttribute("cart", cartDAO.getCartItemsByUser(user.getUserID()));
                } else {
                    List<CartItem> guestCart = (List<CartItem>) session.getAttribute("guest_cart");
                    if (guestCart == null) guestCart = new ArrayList<>();
                    boolean found = false;
                    for (CartItem item : guestCart) {
                        if (item.getProduct().getProductID() == productId) {
                            item.setQuantity(item.getQuantity() + quantity);
                            found = true;
                            break;
                        }
                    }
                    if (!found) guestCart.add(new CartItem(product, quantity));
                    session.setAttribute("guest_cart", guestCart);
                }
                session.setAttribute("msg", "✔ Đã thêm vào giỏ hàng!");
            }
        }

        if (redirect != null && !redirect.isEmpty()) {
            response.sendRedirect(redirect);
        } else {
            response.sendRedirect("cart.jsp");
        }
    }
}
