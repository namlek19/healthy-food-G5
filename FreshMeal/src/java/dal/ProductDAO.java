package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.Product;

public class ProductDAO extends DBContext {

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    public List<Product> getAllProduct() {
        List<Product> list = new ArrayList<>();
        String query = "select * from Product";
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(
                        rs.getInt("productID"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getString("nutritionInfo"),
                        rs.getString("origin"),
                        rs.getString("imageURL"),
                        rs.getString("storageInstructions"),
                        rs.getDouble("price"),
                        rs.getInt("categoryID"),
                        rs.getInt("calories")
                ));

            }
        } catch (Exception e) {
        }
        return list;
    }

    public Product getProductById(int id) {
        String sql = "SELECT * FROM Product WHERE ProductID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Product(
                        rs.getInt("productID"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getString("nutritionInfo"),
                        rs.getString("origin"),
                        rs.getString("imageURL"),
                        rs.getString("storageInstructions"),
                        rs.getDouble("price"),
                        rs.getInt("categoryID"),
                        rs.getInt("calories")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void deleteProduct(int productId) {
        String sql = "DELETE FROM Product WHERE ProductID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Product> getNewestProducts(int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM Product ORDER BY ProductID DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(
                        rs.getInt("ProductID"),
                        rs.getString("Name"),
                        rs.getString("Description"),
                        rs.getString("NutritionInfo"),
                        rs.getString("Origin"),
                        rs.getString("ImageURL"),
                        rs.getString("StorageInstructions"),
                        rs.getDouble("Price"),
                        rs.getInt("CategoryID"),
                        rs.getInt("Calories")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertProduct(Product p) {
        String sql = "INSERT INTO Product (Name, Description, Calories, NutritionInfo, Origin, ImageURL, StorageInstructions, Price, CategoryID) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setString(2, p.getDescription());
            ps.setInt(3, p.getCalories());
            ps.setString(4, p.getNutritionInfo());
            ps.setString(5, p.getOrigin());
            ps.setString(6, p.getImageURL());
            ps.setString(7, p.getStorageInstructions());
            ps.setDouble(8, p.getPrice());
            ps.setInt(9, p.getCategoryID());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Object[]> getAllCategoryPairs() {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT CategoryID, CategoryName FROM ProductCategory";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Object[] row = new Object[2];
                row[0] = rs.getInt("CategoryID");
                row[1] = rs.getString("CategoryName");
                list.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getProductByCategory(String categoryId) {
        List<Product> list = new ArrayList<>();
        String query;

        if (categoryId == null || categoryId.isEmpty()) {
            query = "SELECT * FROM Product";
        } else {
            query = "SELECT * FROM Product WHERE CategoryID = ?";
        }

        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(query);

            if (categoryId != null && !categoryId.isEmpty()) {
                ps.setInt(1, Integer.parseInt(categoryId));
            }

            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(
                        rs.getInt("productID"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getString("nutritionInfo"),
                        rs.getString("origin"),
                        rs.getString("imageURL"),
                        rs.getString("storageInstructions"),
                        rs.getDouble("price"),
                        rs.getInt("categoryID"),
                        rs.getInt("calories")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean isProductInAnyMenu(int productID) {
        String sql = "SELECT 1 FROM MenuProduct WHERE ProductID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productID);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Product> searchProductsByName(String keyword) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product WHERE name LIKE ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Product(
                        rs.getInt("productID"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getString("nutritionInfo"),
                        rs.getString("origin"),
                        rs.getString("imageURL"),
                        rs.getString("storageInstructions"),
                        rs.getDouble("price"),
                        rs.getInt("categoryID"),
                        rs.getInt("calories")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();
        List<Product> list = dao.searchProductsByName("nước");
        for (Product o : list) {
            System.out.println(o);
        }
    }
}
