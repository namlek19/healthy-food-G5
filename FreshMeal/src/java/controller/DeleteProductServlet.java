package controller;

import dal.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

public class DeleteProductServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("productID");
        if (idRaw == null || idRaw.trim().isEmpty()) {
            response.sendRedirect("manageProductSeller?error=missingID");
            return;
        }
        try {
            int id = Integer.parseInt(idRaw);
            ProductDAO dao = new ProductDAO();
            if (dao.isProductInAnyMenu(id)) {
                response.sendRedirect("manageProductSeller?error=containedInMenu");
                return;
            }
            
            dao.deleteProduct(id);
            response.sendRedirect("manageProductSeller?message=deleted");
        } catch (NumberFormatException e) {
            response.sendRedirect("manageProductSeller?error=invalidID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("manageProductSeller?error=server");
        }
    }
}
