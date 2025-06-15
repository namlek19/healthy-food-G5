package controller;

import dal.MenuDAO;
import model.Menu;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class MenuDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            request.setAttribute("error", "Menu không tồn tại!");
            request.getRequestDispatcher("MenuDetail.jsp").forward(request, response);
            return;
        }

        int id = Integer.parseInt(idStr);
        MenuDAO dao = new MenuDAO();
        Menu menu = dao.getMenuById(id);
        request.setAttribute("menu", menu);
        request.getRequestDispatcher("MenuDetail.jsp").forward(request, response);
    }
}