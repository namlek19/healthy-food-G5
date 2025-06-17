package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Blog;

public class BlogDAO extends DBContext {

    /**
     * Lấy tất cả các bài blog từ cơ sở dữ liệu và sắp xếp theo ngày tạo mới nhất.
     * @return Danh sách các đối tượng Blog.
     */
    public List<Blog> getAllBlogs() {
        List<Blog> list = new ArrayList<>();
        String sql = "SELECT b.BlogID, b.Title, b.ImageURL, b.Description, b.NutritionistID, u.FullName, b.CreatedAt " +
                     "FROM Blog b JOIN Users u ON b.NutritionistID = u.UserID " +
                     "ORDER BY b.CreatedAt DESC";

        // Sử dụng try-with-resources để tự động quản lý Connection, PreparedStatement, và ResultSet
        // Connection sẽ được lấy từ phương thức getConnection() của lớp cha DBContext
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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
        } catch (Exception e) { // Bắt Exception vì getConnection() có thể ném ra
            e.printStackTrace(); // In lỗi ra console để debug
        }
        return list;
    }

    /**
     * Thêm một bài blog mới vào cơ sở dữ liệu.
     * @param title Tiêu đề bài blog.
     * @param imageURL URL hình ảnh của bài blog.
     * @param description Nội dung mô tả của bài blog.
     * @param nutritionistID ID của chuyên gia dinh dưỡng tạo bài blog.
     */
    public void addBlog(String title, String imageURL, String description, int nutritionistID) {
        String sql = "INSERT INTO Blog (Title, ImageURL, Description, NutritionistID) VALUES (?, ?, ?, ?)";

        // Sử dụng try-with-resources để tự động quản lý Connection và PreparedStatement
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, title);
            ps.setString(2, imageURL);
            ps.setString(3, description);
            ps.setInt(4, nutritionistID);
            ps.executeUpdate();
            
        } catch (Exception e) { // Bắt Exception vì getConnection() có thể ném ra
            e.printStackTrace(); // In lỗi ra console để debug
        }
    }
    
    // Bạn có thể thêm các phương thức khác ở đây (ví dụ: getBlogByID, updateBlog, deleteBlog)
    // theo cùng một cấu trúc try-with-resources.
    
    public void deleteBlog(int blogID) {
        String sql = "DELETE FROM Blog WHERE BlogID = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, blogID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Lấy thông tin chi tiết của một bài blog dựa trên ID.
     * @param blogID ID của bài blog cần lấy.
     * @return Đối tượng Blog hoặc null nếu không tìm thấy.
     */
    public Blog getBlogByID(int blogID) {
        String sql = "SELECT b.BlogID, b.Title, b.ImageURL, b.Description, b.NutritionistID, u.FullName, b.CreatedAt " +
                     "FROM Blog b JOIN Users u ON b.NutritionistID = u.UserID " +
                     "WHERE b.BlogID = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
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

    /**
     * Cập nhật thông tin của một bài blog.
     * @param blog Đối tượng Blog chứa thông tin đã cập nhật.
     */
    public void updateBlog(Blog blog) {
        String sql = "UPDATE Blog SET Title = ?, ImageURL = ?, Description = ? WHERE BlogID = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, blog.getTitle());
            ps.setString(2, blog.getImageURL());
            ps.setString(3, blog.getDescription());
            ps.setInt(4, blog.getBlogID());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    
    
    // Lấy các blog do một nutritionist đăng
public List<Blog> getBlogsByNutritionist(int nutritionistID) {
    List<Blog> list = new ArrayList<>();
    String sql = "SELECT b.BlogID, b.Title, b.ImageURL, b.Description, b.NutritionistID, u.FullName, b.CreatedAt " +
            "FROM Blog b JOIN Users u ON b.NutritionistID = u.UserID " +
            "WHERE b.NutritionistID = ? " +
            "ORDER BY b.CreatedAt DESC";
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
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

// Tìm kiếm blog của nutritionist theo từ khóa
public List<Blog> searchBlogsByNutritionist(int nutritionistID, String keyword) {
    List<Blog> list = new ArrayList<>();
    String sql = "SELECT b.BlogID, b.Title, b.ImageURL, b.Description, b.NutritionistID, u.FullName, b.CreatedAt " +
            "FROM Blog b JOIN Users u ON b.NutritionistID = u.UserID " +
            "WHERE b.NutritionistID = ? AND (b.Title LIKE ? OR b.Description LIKE ?) " +
            "ORDER BY b.CreatedAt DESC";
    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {
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

    
}