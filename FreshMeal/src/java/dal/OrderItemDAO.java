package dal;

import model.OrderItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDAO extends DBContext {

    public List<OrderItem> getItemsByOrderId(int orderId) {
    List<OrderItem> list = new ArrayList<>();
    String sql = "SELECT oi.OrderItemID, oi.OrderID, oi.ProductID, p.Name AS ProductName, p.ImageURL, oi.Quantity, oi.Price " +
                 "FROM OrderItem oi " +
                 "JOIN Product p ON oi.ProductID = p.ProductID " +
                 "WHERE oi.OrderID = ?";
    try (Connection conn = getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, orderId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            OrderItem item = new OrderItem(
                rs.getInt("OrderItemID"),
                rs.getInt("OrderID"),
                rs.getInt("ProductID"),
                rs.getString("ProductName"),
                rs.getString("ImageURL"),
                rs.getInt("Quantity"),
                rs.getDouble("Price")
            );
            list.add(item);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

}
