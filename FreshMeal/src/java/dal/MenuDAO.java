package dal;

import model.Menu;
import model.Product;
import java.sql.*;
import java.util.*;

public class MenuDAO extends DBContext {

    public List<Menu> getMenusByBMICategory(String bmiCategory) {
        List<Menu> list = new ArrayList<>();
        String query = "SELECT * FROM Menu WHERE BMICategory = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, bmiCategory);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Menu m = new Menu(
                        rs.getInt("MenuID"),
                        rs.getString("MenuName"),
                        rs.getString("Description"),
                        rs.getString("ImageURL"),
                        rs.getString("BMICategory"),
                        rs.getInt("NutritionistID")
                );
                m.setProducts(getProductsInMenu(m.getMenuID(), conn));
                
                List<Product> menuProducts = m.getProducts();
                double total = 0;
                if (menuProducts != null) {
                    for (Product p : menuProducts) {
                        total += p.getPrice();
                    }
                }
                m.setTotalPrice(total);
                
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Product> getProductsInMenu(int menuID, Connection conn) throws SQLException {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.* FROM Product p JOIN MenuProduct mp ON p.ProductID = mp.ProductID WHERE mp.MenuID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, menuID);
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
        }
        return list;
    }
    public Menu getMenuById(int id) {
        String sql = "SELECT * FROM Menu WHERE MenuID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Menu m = new Menu(
                        rs.getInt("MenuID"),
                        rs.getString("MenuName"),
                        rs.getString("Description"),
                        rs.getString("ImageURL"),
                        rs.getString("BMICategory"),
                        rs.getInt("NutritionistID")
                );
                m.setProducts(getProductsInMenu(m.getMenuID(), conn));
                double total = 0;
                for (Product p : m.getProducts()) {
                    total += p.getPrice();
                }
                m.setTotalPrice(total);
                return m;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Thêm menu mới, trả về MenuID vừa insert (SQL Server)
public int addMenu(Menu menu) {
    int menuID = -1;
    String sql = "INSERT INTO Menu (MenuName, Description, BMICategory, ImageURL, NutritionistID) VALUES (?, ?, ?, ?, ?)";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        ps.setString(1, menu.getMenuName());
        ps.setString(2, menu.getDescription());
        ps.setString(3, menu.getBmiCategory());
        ps.setString(4, menu.getImageURL());
        ps.setInt(5, menu.getNutritionistID());
        int affectedRows = ps.executeUpdate();
        if (affectedRows > 0) {
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                menuID = rs.getInt(1);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return menuID;
}

// Thêm 1 món ăn vào menu
public void addMenuProduct(int menuID, int productID) {
    String sql = "INSERT INTO MenuProduct (MenuID, ProductID) VALUES (?, ?)";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, menuID);
        ps.setInt(2, productID);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}

    
}
