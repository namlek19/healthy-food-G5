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

    public int countAllOrders() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM [Order]";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<Order> getOrdersPaging(int offset, int limit) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM [Order] ORDER BY OrderDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;";
        // Câu trên dùng cú pháp phân trang bên SQL Server 2012+ (nếu bạn dùng DB khác cần sửa phù hợp)
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset);
            ps.setInt(2, limit);

            ResultSet rs = ps.executeQuery();
            OrderItemDAO itemDAO = new OrderItemDAO();

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

                // Lấy các OrderItems của đơn hàng này
                List<OrderItem> items = itemDAO.getItemsByOrderId(order.getOrderID());
                order.setItems(items);

                list.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getAllOrdersWithItems() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM [Order] ORDER BY OrderDate DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            OrderItemDAO itemDAO = new OrderItemDAO();
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

                List<OrderItem> items = itemDAO.getItemsByOrderId(order.getOrderID());
                order.setItems(items);

                list.add(order);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getAllCODOrdersByShipperID(int shipperId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM [Order] WHERE ShipperID = ? AND (Status = 'Confirmed' OR Status = 'Delivering') ORDER BY OrderDate DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shipperId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setUserID(rs.getInt("UserID"));
                order.setShipperID(rs.getInt("ShipperID"));
                order.setReceiverName(rs.getString("ReceiverName"));
                order.setPhone(rs.getString("Phone"));
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

    public List<Order> getAllQROrdersByShipperID(int shipperId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM [Order] WHERE ShipperID = ? AND (Status = 'QRConfirmed' OR Status = 'QRDelivering') ORDER BY OrderDate DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, shipperId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderID(rs.getInt("OrderID"));
                order.setUserID(rs.getInt("UserID"));
                order.setShipperID(rs.getInt("ShipperID"));
                order.setReceiverName(rs.getString("ReceiverName"));
                order.setPhone(rs.getString("Phone"));
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

    public void confirmOrderWithStatus(int orderId, int shipperId, String newStatus) {
        String sql = "UPDATE [Order] SET Status = ?, ShipperID = ? WHERE OrderID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, shipperId);
            ps.setInt(3, orderId);
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
                order.setPhone(rs.getString("Phone"));
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
            psOrder.setString(3, order.getPhone());
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

    public int getUserIdByOrderId(int orderId) {
        String sql = "SELECT UserID FROM [Order] WHERE OrderID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("UserID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean isGuestOrder(int orderId) {
        String sql = "SELECT UserID FROM [Order] WHERE OrderID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("UserID") == 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countOrdersByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM [Order] WHERE Status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Order> getOrdersByStatusPaging(String status, int offset, int pageSize) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM [Order] WHERE Status = ? ORDER BY OrderDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);

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
}
