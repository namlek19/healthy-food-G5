package controller;

import dal.MenuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Menu;

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

        Menu menu = dao.getMenuById(menuId);
        String menuName = menu.getMenuName();
        int nutritionistId = menu.getNutritionistID();
        String nutritionistEmail = dao.getEmailByUserId(nutritionistId); // bạn cần tạo

        switch (action) {
            case "approve":
                updated = dao.updateMenuStatus(menuId, 2);
                msg = updated ? "Duyệt menu thành công!" : "Duyệt menu thất bại!";
                break;

            case "reject":
                updated = dao.deleteMenuWithResult(menuId);
                msg = updated ? "Đã từ chối menu!" : "Từ chối menu thất bại!";
                if (updated) {
                    String subject = "Manager đã từ chối yêu cầu duyệt combo của bạn: \"" + menuName + "\" - ID " + menuId;
                    String content = "Xin chào,\n\nManager đã từ chối yêu cầu duyệt combo của bạn: \"" + menuName + "\" - ID " + menuId;
                    SendMail.send(nutritionistEmail, subject, content, false);
                }
                break;

            case "approveDeleteRequest":
                updated = dao.deleteMenuWithResult(menuId);
                msg = updated ? "Đã xóa menu theo yêu cầu của Nutritionist." : "Xóa menu thất bại!";
                break;

            case "rejectDeleteRequest":
                updated = dao.updateMenuStatus(menuId, 3);
                msg = updated ? "Đã từ chối yêu cầu xóa." : "Không thể cập nhật lại trạng thái!";
                if (updated) {
                    String subject = "Manager đã từ chối yêu cầu xóa combo của bạn: \"" + menuName + "\" - ID " + menuId;
                    String content = "Xin chào,\n\nManager đã từ chối yêu cầu xóa combo của bạn: \"" + menuName + "\" - ID " + menuId;
                    SendMail.send(nutritionistEmail, subject, content, false);
                }
                break;

            case "approveEditRequest":
                updated = dao.applySuaMenuWithResult(menuId);
                msg = updated ? "Đã áp dụng chỉnh sửa từ Nutritionist!" : "Áp dụng chỉnh sửa thất bại!";
                break;

            case "rejectEditRequest":
                updated = dao.rejectSuaMenuWithResult(menuId);
                msg = updated ? "Đã từ chối chỉnh sửa!" : "Từ chối chỉnh sửa thất bại!";
                if (updated) {
                    String subject = "Manager đã từ chối yêu cầu sửa combo của bạn: \"" + menuName + "\" - ID " + menuId;
                    String content = "Xin chào,\n\nManager đã từ chối yêu cầu sửa combo của bạn: \"" + menuName + "\" - ID " + menuId;
                    SendMail.send(nutritionistEmail, subject, content, false);
                }
                break;

            default:
                msg = "Hành động không hợp lệ!";
        }

        request.getSession().setAttribute(updated ? "successMsg" : "errorMsg", msg);
        response.sendRedirect("pending-menu.jsp");
    }
}
