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
                // -- TÍNH TỔNG GIÁ --
                List<Product> menuProducts = m.getProducts();
                double total = 0;
                if (menuProducts != null) {
                    for (Product p : menuProducts) {
                        total += p.getPrice();
                    }
                }
                m.setTotalPrice(total);
                // -- KẾT THÚC TÍNH TỔNG GIÁ --
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
}
