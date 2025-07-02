package controller;

import dal.MenuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;


public class ApproveMenuServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String menuIdRaw = request.getParameter("menuId");
        String action = request.getParameter("action");
        int menuId = Integer.parseInt(menuIdRaw);
        MenuDAO dao = new MenuDAO();
        boolean updated = false;
        String msg = "";

        if ("approve".equals(action)) {
            updated = dao.updateMenuStatus(menuId, 2); // Đổi sang đã duyệt
            msg = updated ? "Duyệt menu thành công!" : "Duyệt menu thất bại!";
            request.getSession().setAttribute(updated ? "successMsg" : "errorMsg", msg);
        } else if ("reject".equals(action)) {
            updated = dao.updateMenuStatus(menuId, 0); // Đã từ chối
            msg = updated ? "Đã từ chối menu!" : "Từ chối menu thất bại!";
            request.getSession().setAttribute(updated ? "successMsg" : "errorMsg", msg);
        }
        response.sendRedirect("pending-menu.jsp");
    }
}
