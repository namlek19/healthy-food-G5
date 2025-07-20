package controller;

import dal.MenuDAO;
import model.Menu;
import java.util.*;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class MenuCusServlet extends HttpServlet {

    private static final int PAGE_SIZE = 6;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bmi = request.getParameter("bmi");
        String strPage = request.getParameter("page");
        int page = 1;
        try {
            page = Integer.parseInt(strPage);
        } catch (Exception e) {
        }
        if (page < 1) {
            page = 1;
        }

        String categoryName;
        if (bmi == null || bmi.isEmpty()) {
            categoryName = "Tất cả thực đơn";
        } else {
            switch (bmi) {
                case "Underweight":
                    categoryName = "Gầy (Underweight)";
                    break;
                case "Normal":
                    categoryName = "Bình thường (Normal)";
                    break;
                case "Overweight":
                    categoryName = "Thừa cân (Overweight)";
                    break;
                case "Obese":
                    categoryName = "Béo phì (Obese)";
                    break;
                default:
                    categoryName = "Tất cả thực đơn";
            }
        }

        MenuDAO dao = new MenuDAO();
        int totalMenus = dao.countMenusByBMICategory(bmi);
        int totalPages = (int) Math.ceil((double) totalMenus / PAGE_SIZE);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }
        int offset = (page - 1) * PAGE_SIZE;

        List<Menu> menuList = dao.getMenusByBMICategoryPaging(bmi, offset, PAGE_SIZE);

        request.setAttribute("menuList", menuList);
        request.setAttribute("categoryName", categoryName);
        request.setAttribute("bmi", bmi); // giữ cho link phân trang
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("MenuCus.jsp").forward(request, response);
    }
}
