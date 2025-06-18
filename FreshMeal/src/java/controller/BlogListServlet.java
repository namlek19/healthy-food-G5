package controller;

import dal.BlogDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Blog;


@WebServlet(name = "BlogListServlet", urlPatterns = {"/blog"})
public class BlogListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        BlogDAO blogDAO = new BlogDAO();

        
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        model.User currentUser = (session != null) ? (model.User) session.getAttribute("user") : null;

        if (action != null && action.equals("edit")) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                Blog blog = blogDAO.getBlogByID(id);
                request.setAttribute("blog", blog);
                RequestDispatcher rd = request.getRequestDispatcher("editBlog.jsp");
                rd.forward(request, response);
            } catch (NumberFormatException e) {
                
                response.sendRedirect(request.getContextPath() + "/blog");
            }
        } else {
            
            List<Blog> blogs = blogDAO.getAllBlogs();
            request.setAttribute("blogs", blogs);
            
            if (currentUser != null) {
                request.setAttribute("myUserID", currentUser.getUserID());
            }
            RequestDispatcher rd = request.getRequestDispatcher("blog.jsp");
            rd.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        BlogDAO blogDAO = new BlogDAO();

        if (action != null) {
            try {
                if (action.equals("delete")) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    blogDAO.deleteBlog(id);
                } else if (action.equals("update")) {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String title = request.getParameter("title");
                    String imageURL = request.getParameter("imageURL");
                    String description = request.getParameter("description");

                    Blog blog = new Blog();
                    blog.setBlogID(id);
                    blog.setTitle(title);
                    blog.setImageURL(imageURL);
                    blog.setDescription(description);

                    blogDAO.updateBlog(blog);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        
        response.sendRedirect(request.getContextPath() + "/blog");
    }

    @Override
    public String getServletInfo() {
        return "Servlet to manage and display blogs. Handles listing, editing, and deleting blogs.";
    }
}
