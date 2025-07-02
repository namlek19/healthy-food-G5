package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Blog;

public class BlogDAO extends DBContext {

    public List<Blog> getAllBlogs() {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.BlogID, b.Title, b.ImageURL, b.Description, b.NutritionistID, u.FullName, b.CreatedAt "
                + "FROM Blog b JOIN Users u ON b.NutritionistID = u.UserID "
                + "ORDER BY b.CreatedAt DESC";

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Blog blog = new Blog();
                blog.setBlogID(rs.getInt("BlogID"));
                blog.setTitle(rs.getString("Title"));
                blog.setImageURL(rs.getString("ImageURL"));
                blog.setDescription(rs.getString("Description"));
                blog.setNutritionistID(rs.getInt("NutritionistID"));
                blog.setNutritionistName(rs.getString("FullName"));
                blog.setCreatedAt(rs.getTimestamp("CreatedAt"));
                list.add(blog);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addBlog(String title, String imageURL, String description, int nutritionistID) {
        String sql = "INSERT INTO Blog (Title, ImageURL, Description, NutritionistID) VALUES (?, ?, ?, ?)";

        // Sử dụng try-with-resources để tự động quản lý Connection và PreparedStatement
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, title);
            ps.setString(2, imageURL);
            ps.setString(3, description);
            ps.setInt(4, nutritionistID);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteBlog(int blogID) {
        String sql = "DELETE FROM Blog WHERE BlogID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, blogID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Blog getBlogByID(int blogID) {
        String sql = "SELECT b.BlogID, b.Title, b.ImageURL, b.Description, b.NutritionistID, u.FullName, b.CreatedAt "
                + "FROM Blog b JOIN Users u ON b.NutritionistID = u.UserID "
                + "WHERE b.BlogID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, blogID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Blog blog = new Blog();
                    blog.setBlogID(rs.getInt("BlogID"));
                    blog.setTitle(rs.getString("Title"));
                    blog.setImageURL(rs.getString("ImageURL"));
                    blog.setDescription(rs.getString("Description"));
                    blog.setNutritionistID(rs.getInt("NutritionistID"));
                    blog.setNutritionistName(rs.getString("FullName"));
                    blog.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    return blog;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateBlog(Blog blog) {
        String sql = "UPDATE Blog SET Title = ?, ImageURL = ?, Description = ? WHERE BlogID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, blog.getTitle());
            ps.setString(2, blog.getImageURL());
            ps.setString(3, blog.getDescription());
            ps.setInt(4, blog.getBlogID());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Blog> getBlogsByNutritionist(int nutritionistID) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.BlogID, b.Title, b.ImageURL, b.Description, b.NutritionistID, u.FullName, b.CreatedAt "
                + "FROM Blog b JOIN Users u ON b.NutritionistID = u.UserID "
                + "WHERE b.NutritionistID = ? "
                + "ORDER BY b.CreatedAt DESC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, nutritionistID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Blog blog = new Blog();
                    blog.setBlogID(rs.getInt("BlogID"));
                    blog.setTitle(rs.getString("Title"));
                    blog.setImageURL(rs.getString("ImageURL"));
                    blog.setDescription(rs.getString("Description"));
                    blog.setNutritionistID(rs.getInt("NutritionistID"));
                    blog.setNutritionistName(rs.getString("FullName"));
                    blog.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    list.add(blog);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Blog> searchBlogsByNutritionist(int nutritionistID, String keyword) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.BlogID, b.Title, b.ImageURL, b.Description, b.NutritionistID, u.FullName, b.CreatedAt "
                + "FROM Blog b JOIN Users u ON b.NutritionistID = u.UserID "
                + "WHERE b.NutritionistID = ? AND (b.Title LIKE ? OR b.Description LIKE ?) "
                + "ORDER BY b.CreatedAt DESC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, nutritionistID);
            ps.setString(2, "%" + keyword + "%");
            ps.setString(3, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Blog blog = new Blog();
                    blog.setBlogID(rs.getInt("BlogID"));
                    blog.setTitle(rs.getString("Title"));
                    blog.setImageURL(rs.getString("ImageURL"));
                    blog.setDescription(rs.getString("Description"));
                    blog.setNutritionistID(rs.getInt("NutritionistID"));
                    blog.setNutritionistName(rs.getString("FullName"));
                    blog.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    list.add(blog);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // DESC: moi, ASC: cu
    public List<Blog> getLatestBlogsExcept(int exceptBlogID, int limit) {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.BlogID, b.Title, b.ImageURL, b.Description, b.NutritionistID, u.FullName, b.CreatedAt "
                + "FROM Blog b JOIN Users u ON b.NutritionistID = u.UserID "
                + "WHERE b.BlogID <> ? "
                + // <> là 'khác' trong SQL Server
                "ORDER BY b.CreatedAt DESC "
                + "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";    

        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, exceptBlogID);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Blog blog = new Blog();
                    blog.setBlogID(rs.getInt("BlogID"));
                    blog.setTitle(rs.getString("Title"));
                    blog.setImageURL(rs.getString("ImageURL"));
                    blog.setDescription(rs.getString("Description"));
                    blog.setNutritionistID(rs.getInt("NutritionistID"));
                    blog.setNutritionistName(rs.getString("FullName"));
                    blog.setCreatedAt(rs.getTimestamp("CreatedAt"));
                    list.add(blog);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Blog> getAllBlogsSorted(String sort) {
    List<Blog> list = new ArrayList<>();
    String orderBy = "DESC"; // Mặc định mới nhất
    if ("oldest".equalsIgnoreCase(sort)) {
        orderBy = "ASC";
    }
    String sql = "SELECT b.BlogID, b.Title, b.ImageURL, b.Description, b.NutritionistID, u.FullName, b.CreatedAt "
            + "FROM Blog b JOIN Users u ON b.NutritionistID = u.UserID "
            + "ORDER BY b.CreatedAt " + orderBy;

    try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Blog blog = new Blog();
            blog.setBlogID(rs.getInt("BlogID"));
            blog.setTitle(rs.getString("Title"));
            blog.setImageURL(rs.getString("ImageURL"));
            blog.setDescription(rs.getString("Description"));
            blog.setNutritionistID(rs.getInt("NutritionistID"));
            blog.setNutritionistName(rs.getString("FullName"));
            blog.setCreatedAt(rs.getTimestamp("CreatedAt"));
            list.add(blog);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}


}
