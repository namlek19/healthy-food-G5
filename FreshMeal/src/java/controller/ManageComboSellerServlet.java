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

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String strPage = request.getParameter("page");
        int page = 1;
        try {
            page = Integer.parseInt(strPage);
        } catch (Exception e) {
        }
        if (page < 1) {
            page = 1;
        }

        MenuDAO dao = new MenuDAO();
        int totalMenus = dao.countAllMenusByStatuses34();
        int totalPages = (int) Math.ceil((double) totalMenus / PAGE_SIZE);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }
        int offset = (page - 1) * PAGE_SIZE;

        List<Menu> menuList = dao.getMenusByStatuses34Paging(offset, PAGE_SIZE);

        request.setAttribute("menuList", menuList);
        request.setAttribute("pageIndex", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", "manageComboSeller");
        request.getRequestDispatcher("manageComboSeller.jsp").forward(request, response);
    }
}

