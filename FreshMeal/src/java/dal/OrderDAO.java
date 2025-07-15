package dal;

import java.sql.*;
import java.util.*;
import model.Order;
import model.OrderItem;
import model.CartItem;

public class OrderDAO extends DBContext {

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM [Order] ORDER BY OrderDate DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setUserID(rs.getInt("UserID"));
                order.setReceiverName(rs.getString("ReceiverName"));
                order.setPhone(rs.getString("Phone")); // ✅
                order.setDeliveryAddress(rs.getString("DeliveryAddress"));
                order.setDistrict(rs.getString("District"));
                order.setTotalAmount(rs.getDouble("TotalAmount"));
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setStatus(rs.getString("Status"));
                order.setEmail(rs.getString("Email"));
                order.setItems(getOrderItems(order.getOrderID()));
                list.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM [Order] WHERE UserID = ? ORDER BY OrderDate DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setUserID(rs.getInt("UserID"));
                order.setReceiverName(rs.getString("ReceiverName"));
                order.setPhone(rs.getString("Phone")); // ✅
                order.setDeliveryAddress(rs.getString("DeliveryAddress"));
                order.setDistrict(rs.getString("District"));
                order.setTotalAmount(rs.getDouble("TotalAmount"));
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setStatus(rs.getString("Status"));
                order.setEmail(rs.getString("Email"));
                order.setItems(getOrderItems(order.getOrderID()));
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public void confirmOrder(int orderId, int shipperId) {
        String sql = "UPDATE [Order] SET Status = 'Confirmed', ShipperID = ? WHERE OrderID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shipperId);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteOrder(int orderId) {
        String deleteItemsSql = "DELETE FROM OrderItem WHERE OrderID = ?";
        String deleteOrderSql = "DELETE FROM [Order] WHERE OrderID = ?";

        try (Connection conn = getConnection()) {

            try (PreparedStatement ps1 = conn.prepareStatement(deleteItemsSql)) {
                ps1.setInt(1, orderId);
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = conn.prepareStatement(deleteOrderSql)) {
                ps2.setInt(1, orderId);
                ps2.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Order getOrderById(int orderId) {
        String sql = "SELECT * FROM [Order] WHERE OrderID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setUserID(rs.getInt("UserID"));
                order.setReceiverName(rs.getString("ReceiverName"));
                order.setPhone(rs.getString("Phone")); // ✅
                order.setDeliveryAddress(rs.getString("DeliveryAddress"));
                order.setDistrict(rs.getString("District"));
                order.setTotalAmount(rs.getDouble("TotalAmount"));
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setStatus(rs.getString("Status"));
                order.setEmail(rs.getString("Email"));
                order.setItems(getOrderItems(orderId));
                return order;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.OrderItemID, oi.OrderID, oi.ProductID, p.Name, p.ImageURL, oi.Quantity, oi.Price "
                + "FROM OrderItem oi JOIN Product p ON oi.ProductID = p.ProductID WHERE oi.OrderID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemID(rs.getInt("OrderItemID"));
                item.setOrderID(rs.getInt("OrderID"));
                item.setProductID(rs.getInt("ProductID"));
                item.setProductName(rs.getString("Name"));
                item.setImageUrl(rs.getString("ImageURL"));
                item.setQuantity(rs.getInt("Quantity"));
                item.setPrice(rs.getDouble("Price"));
                items.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    public int createOrder(Order order, List<CartItem> cart) {
        String sqlOrder = "INSERT INTO [Order](UserID, ReceiverName, Phone, DeliveryAddress, District, TotalAmount, OrderDate, Status, Email) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String sqlItem = "INSERT INTO OrderItem (OrderID, ProductID, Quantity, Price) VALUES (?, ?, ?, ?)";
        int orderId = 0;

        try (Connection conn = getConnection(); PreparedStatement psOrder = conn.prepareStatement(sqlOrder, Statement.RETURN_GENERATED_KEYS)) {

            if (order.getUserID() == 0) {
                psOrder.setNull(1, Types.INTEGER);
            } else {
                psOrder.setInt(1, order.getUserID());
            }

            psOrder.setString(2, order.getReceiverName());
            psOrder.setString(3, order.getPhone()); // ✅
            psOrder.setString(4, order.getDeliveryAddress());
            psOrder.setString(5, order.getDistrict());
            psOrder.setDouble(6, order.getTotalAmount());
            psOrder.setTimestamp(7, new java.sql.Timestamp(order.getOrderDate().getTime()));
            psOrder.setString(8, order.getStatus());
            psOrder.setString(9, order.getEmail());

            psOrder.executeUpdate();

            try (ResultSet rs = psOrder.getGeneratedKeys()) {
                if (rs.next()) {
                    orderId = rs.getInt(1);
                }
            }

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
        return 0;
    }

    public boolean assignShipperAndConfirm(int orderId, int shipperId) {
        String sql = "UPDATE [Order] SET Status = 'Confirmed', ShipperID = ? WHERE OrderID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shipperId);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Order> getOrdersByStatus(String status) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM [Order] WHERE Status = ? ORDER BY OrderDate DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setUserID(rs.getInt("UserID"));
                order.setReceiverName(rs.getString("ReceiverName"));
                order.setPhone(rs.getString("Phone"));
                order.setDeliveryAddress(rs.getString("DeliveryAddress"));
                order.setDistrict(rs.getString("District"));
                order.setTotalAmount(rs.getDouble("TotalAmount"));
                order.setOrderDate(rs.getTimestamp("OrderDate"));
                order.setStatus(rs.getString("Status"));
                order.setEmail(rs.getString("Email"));
                order.setItems(getOrderItems(order.getOrderID()));
                orders.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    public void updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE [Order] SET Status = ? WHERE OrderID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
