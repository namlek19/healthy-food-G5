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
            response.sendRedirect("blog");
            return;
        }

        String desc = blog.getDescription();
        desc = desc.replaceAll("(?m)^\\s+", ""); // Xoá khoảng trắng đầu dòng

// Chia đoạn dựa trên một hoặc nhiều dấu xuống dòng liên tiếp
        String[] paragraphs = desc.split("\\n+");
        StringBuilder htmlDesc = new StringBuilder();
        for (String para : paragraphs) {
            if (!para.trim().isEmpty()) {
                htmlDesc.append("<p>").append(para.trim()).append("</p>");
            }
        }
        request.setAttribute("blog", blog);
        request.setAttribute("blogDescHtml", htmlDesc.toString());

        RequestDispatcher rd = request.getRequestDispatcher("blog_detail.jsp");
        rd.forward(request, response);
    }
}
