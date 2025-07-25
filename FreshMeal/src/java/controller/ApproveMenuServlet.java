package controller;

import dal.MenuDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
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

        Menu menu = dao.getMenuById(menuId);  // Lấy thông tin menu để lấy tên
        String menuName = (menu != null) ? menu.getMenuName() : "";

        switch (action) {
            case "approve":
                updated = dao.updateMenuStatus(menuId, 2);
                msg = updated ? "Duyệt menu thành công!" : "Duyệt menu thất bại!";
                if (updated) {
                    // Lấy danh sách email của seller (roleId=4)
                    List<String> sellerEmails = dao.getEmailsByRoleId(4); // bạn cần tạo hàm này trong MenuDAO

                    String subject = "Bạn có combo chờ đăng: \"" + menuName + "\" - ID " + menuId;
                    String content = "Xin chào,\n\nCombo \"" + menuName + "\" - ID " + menuId + " đã được duyệt bởi Manager.";

                    for (String email : sellerEmails) {
                        SendMail.send(email, subject, content, false);
                    }
                }
                break;

            case "approveDeleteRequest":
                updated = dao.deleteMenuWithResult(menuId);
                msg = updated ? "Đã xóa menu theo yêu cầu của Nutritionist." : "Xóa menu thất bại!";
                break;

            case "approveEditRequest":
                updated = dao.applySuaMenuWithResult(menuId);
                msg = updated ? "Đã áp dụng chỉnh sửa từ Nutritionist!" : "Áp dụng chỉnh sửa thất bại!";
                break;

            default:
                msg = "Hành động không hợp lệ!";
        }

        request.getSession().setAttribute(updated ? "successMsg" : "errorMsg", msg);
        response.sendRedirect("pending-menu.jsp");
    }
}
