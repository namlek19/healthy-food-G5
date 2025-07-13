package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.User;
import dal.UserDAO;

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null || user.getRoleID() != 1) {
            response.sendRedirect("login.jsp");
            return;
        }
        String search = request.getParameter("search");
        UserDAO userDAO = new UserDAO();
        List<User> userList = userDAO.getAllUsers();
        if (search != null && !search.trim().isEmpty()) {
            String searchLower = search.toLowerCase();
            userList = userList.stream()
                .filter(u -> u.getFullName() != null && u.getFullName().toLowerCase().contains(searchLower))
                .collect(java.util.stream.Collectors.toList());
        }
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("admindasboard.jsp").forward(request, response);
    }
} 