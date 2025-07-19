/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
public class UpdateUserRoleServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        int role = Integer.parseInt(request.getParameter("role"));

      

        UserDAO userDao = new UserDAO();
        boolean success = userDao.updateUserRole(userId, role);

        if (success) {
            request.setAttribute("message", "Cập nhật role thành công!");
        } else {
            request.setAttribute("error", "Cập nhật thất bại!");
        }

        // Reload user list
        request.setAttribute("users", userDao.getAllUsers());
        request.getRequestDispatcher("manageUsers.jsp").forward(request, response);
    }
}