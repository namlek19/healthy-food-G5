package controller;

import dal.MenuDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

public class PostComboServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("menuID");
        System.out.println("menuID raw: " + idRaw);
        if (idRaw != null) {
            try {
                int menuID = Integer.parseInt(idRaw);
                MenuDAO dao = new MenuDAO();
                boolean success = dao.updateMenuStatus(menuID, 3);
                if (success) {
                    request.getSession().setAttribute("msg", "Đăng combo thành công!");
                } else {
                    request.getSession().setAttribute("msg", "Đăng combo thất bại!");
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("msg", "Có lỗi xảy ra khi đăng combo!");
            }
        }
        response.sendRedirect("postComboSeller");
    }
}