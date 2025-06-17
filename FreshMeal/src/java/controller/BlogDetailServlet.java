package controller;

import dal.BlogDAO;
import model.Blog;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;


public class BlogDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null) {
            response.sendRedirect("blog");
            return;
        }
        int blogID = Integer.parseInt(idStr);
        BlogDAO blogDAO = new BlogDAO();
        Blog blog = blogDAO.getBlogByID(blogID);

        if (blog == null) {
            response.sendRedirect("blog"); // Không tìm thấy blog
            return;
        }

        request.setAttribute("blog", blog);
        RequestDispatcher rd = request.getRequestDispatcher("blog_detail.jsp");
        rd.forward(request, response);
    }
}
