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
import model.User;

/**
 *
 * @author admin
 */
public class CreateUserServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String city = request.getParameter("city");
        String district = request.getParameter("district");
        String address = request.getParameter("address");
        int roleID = Integer.parseInt(request.getParameter("role"));

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPasswordHash(password);
        user.setCity(city);
        user.setDistrict(district);
        user.setAddress(address);
        user.setRoleID(roleID);

        boolean success = userDAO.insertUser(user);
        if (success) {
            request.setAttribute("message", "Tạo tài khoản thành công!");
        } else {
            request.setAttribute("error", "Tạo tài khoản thất bại!");
        }
        request.setAttribute("users", userDAO.getAllUsers()); // Load lại danh sách user
        request.getRequestDispatcher("manageUsers.jsp").forward(request, response);

    }
}
