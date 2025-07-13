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
                request.setAttribute("message", "A new verification code has been sent to your email.");
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
                    
                    request.setAttribute("message", "Your verification code is: " + verificationCode);
                    request.setAttribute("showVerificationForm", true);
                } else {
                    request.setAttribute("error", "Email address not found.");
                }
            } catch (Exception e) {
                request.setAttribute("error", "An error occurred. Please try again.");
            }
        } else if ("verify".equals(action)) {
            String code = request.getParameter("code");
            String storedCode = (String) session.getAttribute("verificationCode");
            String storedEmail = (String) session.getAttribute("resetEmail");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            if (storedCode == null || storedEmail == null) {
                request.setAttribute("error", "Session expired. Please try again.");
            } else if (!storedCode.equals(code)) {
                request.setAttribute("error", "Invalid verification code.");
                request.setAttribute("showVerificationForm", true);
            } else if (newPassword == null || !newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match.");
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
                        request.setAttribute("error", "Failed to update password. Please try again.");
                        request.setAttribute("showVerificationForm", true);
                    }
                } catch (Exception e) {
                    request.setAttribute("error", "Failed to reset password. Please try again.");
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