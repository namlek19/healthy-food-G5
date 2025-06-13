package dal;

import java.sql.*;
import java.util.*;
import model.CartItem;
import model.Order;

public class OrderDAO extends DBContext {

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM [Order] ORDER BY OrderDate DESC";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setUserID(rs.getInt("UserID"));
                order.setReceiverName(rs.getString("ReceiverName"));
                order.setDeliveryAddress(rs.getString("DeliveryAddress"));
                order.setDistrict(rs.getString("District"));
                order.setTotalAmount(rs.getDouble("TotalAmount"));
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setStatus(rs.getString("Status"));

                list.add(order);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE [Order] SET Status = ? WHERE OrderID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Tuỳ chọn: Get order by ID
    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM [Order] WHERE OrderID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setUserID(rs.getInt("UserID"));
                order.setReceiverName(rs.getString("ReceiverName"));
                order.setDeliveryAddress(rs.getString("DeliveryAddress"));
                order.setDistrict(rs.getString("District"));
                order.setTotalAmount(rs.getDouble("TotalAmount"));
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setStatus(rs.getString("Status"));
                return order;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Tuỳ chọn: thêm đơn hàng mới
    public void insertOrder(Order order) {
        String sql = "INSERT INTO [Order](UserID, ReceiverName, DeliveryAddress, District, TotalAmount, OrderDate, Status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, order.getUserID());
            ps.setString(2, order.getReceiverName());
            ps.setString(3, order.getDeliveryAddress());
            ps.setString(4, order.getDistrict());
            ps.setDouble(5, order.getTotalAmount());
            ps.setTimestamp(6, new Timestamp(order.getOrderDate().getTime()));
            ps.setString(7, order.getStatus());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
   public int createOrder(Order order, List<CartItem> cart) {
    String sqlOrder = "INSERT INTO [Order](UserID, ReceiverName, DeliveryAddress, District, TotalAmount, OrderDate, Status) " +
                      "VALUES (?, ?, ?, ?, ?, ?, ?)";
    String sqlItem = "INSERT INTO OrderItem (OrderID, ProductID, Quantity, Price) VALUES (?, ?, ?, ?)";
    int orderId = 0;

    try (Connection conn = getConnection();
         PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {

        // 1. Thêm Order
        psOrder.setInt(1, order.getUserID());
        psOrder.setString(2, order.getReceiverName());
        psOrder.setString(3, order.getDeliveryAddress());
        psOrder.setString(4, order.getDistrict());
        psOrder.setDouble(5, order.getTotalAmount());
        psOrder.setTimestamp(6, new java.sql.Timestamp(order.getOrderDate().getTime()));
        psOrder.setString(7, order.getStatus());
        psOrder.executeUpdate();

        // 2. Lấy orderId mới tạo
        try (ResultSet rs = psOrder.getGeneratedKeys()) {
            if (rs.next()) {
                orderId = rs.getInt(1);
            }
        }

        // 3. Thêm từng sản phẩm vào OrderItem
        try (PreparedStatement psItem = conn.prepareStatement(sqlItem)) {
            for (CartItem item : cart) {
                psItem.setInt(1, orderId);
                psItem.setInt(2, item.getProduct().getProductID());
                psItem.setInt(3, item.getQuantity());
                psItem.setDouble(4, item.getProduct().getPrice());
                psItem.addBatch();
            }
            psItem.executeBatch();
        }

        return orderId;

    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0; // hoặc -1 nếu lỗi
}

}
