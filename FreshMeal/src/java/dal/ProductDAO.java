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
    
    
    
    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();
        List<Product> list = dao.getAllProduct();
        for (Product o : list) {
            System.out.println(o);
        }
    }
}

