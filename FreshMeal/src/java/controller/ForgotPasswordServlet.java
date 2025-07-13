package controller;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.util.*;


public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("resend".equals(action)) {
            HttpSession session = request.getSession();
            String email = (String) session.getAttribute("resetEmail");
            if (email != null) {
                String newCode = generateVerificationCode();
                session.setAttribute("verificationCode", newCode);
                request.setAttribute("message", "Mã xác thực mới đã được gửi đến email của bạn.");
            }
        }
        
        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String email = request.getParameter("email");
        HttpSession session = request.getSession();
        
        if (email != null && !email.trim().isEmpty()) {
            try {
                UserDAO userDAO = new UserDAO();
                User user = userDAO.getUserByEmail(email);
                
                if (user != null) {
                    
                    String verificationCode = generateVerificationCode();
                    
                    
                    session.setAttribute("verificationCode", verificationCode);
                    session.setAttribute("resetEmail", email);
                    session.setMaxInactiveInterval(10 * 60); 
                    
                    request.setAttribute("message", "Mã xác thực của bạn là: " + verificationCode);
                    request.setAttribute("showVerificationForm", true);
                } else {
                    request.setAttribute("error", "Không tìm thấy địa chỉ email.");
                }
            } catch (Exception e) {
                request.setAttribute("error", "Đã xảy ra lỗi. Vui lòng thử lại.");
            }
        } else if ("verify".equals(action)) {
            String code = request.getParameter("code");
            String storedCode = (String) session.getAttribute("verificationCode");
            String storedEmail = (String) session.getAttribute("resetEmail");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            if (storedCode == null || storedEmail == null) {
                request.setAttribute("error", "Phiên đã hết hạn. Vui lòng thử lại.");
            } else if (!storedCode.equals(code)) {
                request.setAttribute("error", "Mã xác thực không đúng.");
                request.setAttribute("showVerificationForm", true);
            } else if (newPassword == null || !newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu không khớp.");
                request.setAttribute("showVerificationForm", true);
            } else {
                try {
                    UserDAO userDAO = new UserDAO();
                    boolean updated = userDAO.updatePassword(storedEmail, newPassword);
                    
                    if (updated) {
                        session.removeAttribute("verificationCode");
                        session.removeAttribute("resetEmail");
                        response.sendRedirect("login.jsp");
                        return;
                    } else {
                        request.setAttribute("error", "Cập nhật mật khẩu thất bại. Vui lòng thử lại.");
                        request.setAttribute("showVerificationForm", true);
                    }
                } catch (Exception e) {
                    request.setAttribute("error", "Đặt lại mật khẩu thất bại. Vui lòng thử lại.");
                    request.setAttribute("showVerificationForm", true);
                }
            }
        }
        
        request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
    }
    
    private String generateVerificationCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000); 
        return String.valueOf(code);
    }
} 