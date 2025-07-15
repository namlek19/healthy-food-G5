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

        switch (action) {
            case "approve":
                updated = dao.updateMenuStatus(menuId, 2); 
                msg = updated ? "Duyệt menu thành công!" : "Duyệt menu thất bại!";
                break;

            case "reject":
                updated = dao.deleteMenuWithResult(menuId);
                msg = updated ? "Đã từ chối menu!" : "Từ chối menu thất bại!";
                break;

            case "approveDeleteRequest":
                updated = dao.deleteMenuWithResult(menuId);
                msg = updated ? "Đã xóa menu theo yêu cầu của Nutritionist." : "Xóa menu thất bại!";
                break;

            case "rejectDeleteRequest":
                updated = dao.updateMenuStatus(menuId, 3); 
                msg = updated ? "Đã từ chối yêu cầu xóa." : "Không thể cập nhật lại trạng thái!";
                break;

            case "approveEditRequest":
                updated = dao.applySuaMenuWithResult(menuId);
                msg = updated ? "Đã áp dụng chỉnh sửa từ Nutritionist!" : "Áp dụng chỉnh sửa thất bại!";
                break;

            case "rejectEditRequest":
                updated = dao.rejectSuaMenuWithResult(menuId);
                msg = updated ? "Đã từ chối chỉnh sửa!" : "Từ chối chỉnh sửa thất bại!";
                break;

            default:
                msg = "Hành động không hợp lệ!";
        }

        request.getSession().setAttribute(updated ? "successMsg" : "errorMsg", msg);
        response.sendRedirect("pending-menu.jsp");
    }
}
