package dal;

import model.CartItem;
import model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO extends DBContext {

    public int getCartIdByUser(int userId) {
        String select = "SELECT CartID FROM Cart WHERE UserID = ?";
        String insert = "INSERT INTO Cart (UserID, CreatedAt) VALUES (?, GETDATE())";

        try (Connection conn = getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(select)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return rs.getInt("CartID");
                }
            }

            // Nếu chưa có → tạo mới
            try (PreparedStatement ps = conn.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void addOrUpdateCartItem(int userId, int productId, int quantity) {
        String check = "SELECT Quantity FROM CartItem WHERE CartID = ? AND ProductID = ?";
        String update = "UPDATE CartItem SET Quantity = ? WHERE CartID = ? AND ProductID = ?";
        String insert = "INSERT INTO CartItem (CartID, ProductID, Quantity) VALUES (?, ?, ?)";

        try (Connection conn = getConnection()) {
            int cartId = getCartIdByUser(userId);
            try (PreparedStatement ps = conn.prepareStatement(check)) {
                ps.setInt(1, cartId);
                ps.setInt(2, productId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    int currentQty = rs.getInt("Quantity");
                    try (PreparedStatement psUpdate = conn.prepareStatement(update)) {
                        psUpdate.setInt(1, currentQty + quantity);
                        psUpdate.setInt(2, cartId);
                        psUpdate.setInt(3, productId);
                        psUpdate.executeUpdate();
                    }
                } else {
                    try (PreparedStatement psInsert = conn.prepareStatement(insert)) {
                        psInsert.setInt(1, cartId);
                        psInsert.setInt(2, productId);
                        psInsert.setInt(3, quantity);
                        psInsert.executeUpdate();
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<CartItem> getCartItemsByUser(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT ci.ProductID, ci.Quantity, p.Name, p.Price, p.ImageURL " +
                     "FROM CartItem ci JOIN Product p ON ci.ProductID = p.ProductID " +
                     "WHERE ci.CartID = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int cartId = getCartIdByUser(userId);
            ps.setInt(1, cartId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();
                p.setProductID(rs.getInt("ProductID"));
                p.setName(rs.getString("Name"));
                p.setPrice(rs.getDouble("Price"));
                p.setImageURL(rs.getString("ImageURL"));
                CartItem item = new CartItem(p, rs.getInt("Quantity"));
                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void clearCart(int userId) {
        String sql = "DELETE FROM CartItem WHERE CartID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int cartId = getCartIdByUser(userId);
            ps.setInt(1, cartId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void removeItem(int userId, int productId) {
        String sql = "DELETE FROM CartItem WHERE CartID = ? AND ProductID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int cartId = getCartIdByUser(userId);
            ps.setInt(1, cartId);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}