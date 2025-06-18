package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import dal.UserDAO;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/profile"})
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Handle profile update
        String fullName = request.getParameter("fullName");
        String city = request.getParameter("city");
        String district = request.getParameter("district");
        String address = request.getParameter("address");
        
        user.setFullName(fullName);
        user.setCity(city);
        user.setDistrict(district);
        user.setAddress(address);
        
        UserDAO userDAO = new UserDAO();
        boolean profileUpdated = userDAO.updateUser(user);
        
        // Handle password update if provided
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        String message = null;
        boolean success = false;
        
        // Only process password change if all password fields are provided
        if (oldPassword != null && !oldPassword.isEmpty() && 
            newPassword != null && !newPassword.isEmpty() && 
            confirmPassword != null && !confirmPassword.isEmpty()) {
            
            // Validate old password
            User checkUser = userDAO.checkLogin(user.getEmail(), oldPassword);
            
            if (checkUser == null) {
                message = "Current password is incorrect.";
            } else if (!newPassword.equals(confirmPassword)) {
                message = "New passwords do not match.";
            } else if (!isValidPassword(newPassword)) {
                message = "Password must be at least 8 characters long and contain at least one number.";
            } else {
                // Update password
                boolean passwordUpdated = userDAO.updatePassword(user.getEmail(), newPassword);
                if (passwordUpdated) {
                    message = "Profile updated successfully.";
                    // Update session user object
                    user.setPasswordHash(newPassword);
                    session.setAttribute("user", user);
                    success = true;
                } else {
                    message = "Profile updated but failed to update password.";
                }
            }
        } else if (profileUpdated) {
            message = "Profile updated successfully.";
            success = true;
        } else {
            message = "Failed to update profile.";
        }

        session.setAttribute("passwordMessage", message);
        session.setAttribute("passwordSuccess", success);
        response.sendRedirect("profile.jsp");
    }

    private boolean isValidPassword(String password) {
        // Check if password is at least 8 characters and contains at least one number
        return password != null && password.length() >= 8 && password.matches(".*\\d.*");
    }
} 