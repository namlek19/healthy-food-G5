package controller;

import dal.MenuDAO;
import model.Menu;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ManageComboSellerServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        MenuDAO dao = new MenuDAO();
        List<Menu> menuList = dao.getMenusByStatuses34();

        request.setAttribute("menuList", menuList);
        request.setAttribute("currentPage", "manageComboSeller");
        request.getRequestDispatcher("manageComboSeller.jsp").forward(request, response);
    }
}