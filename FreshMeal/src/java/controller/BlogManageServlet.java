package controller;

import dal.BlogDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Blog;

import java.io.IOException;
import java.util.List;

public class BlogManageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("currentPage", "blogmanage");

        HttpSession session = request.getSession();
        Integer nutritionistID = (Integer) session.getAttribute("userID");
        if (nutritionistID == null) {
            nutritionistID = 1; // test cứng nếu chưa có login
        }
        String search = request.getParameter("search");
        BlogDAO blogDAO = new BlogDAO();

        List<Blog> blogs;
        if (search != null && !search.trim().isEmpty()) {
            blogs = blogDAO.searchBlogsByNutritionist(nutritionistID, search.trim());
        } else {
            blogs = blogDAO.getBlogsByNutritionist(nutritionistID);
        }

        request.setAttribute("blogs", blogs);
        request.setAttribute("search", search);
        RequestDispatcher rd = request.getRequestDispatcher("blog_manage.jsp");
        rd.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        BlogDAO blogDAO = new BlogDAO();
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            blogDAO.deleteBlog(id);
        }
        response.sendRedirect(request.getContextPath() + "/blogmanage");
    }
}
