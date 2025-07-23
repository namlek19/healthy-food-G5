package dal;

import model.Menu;
import model.Product;
import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;

public class MenuDAO extends DBContext {

    public List<Menu> getMenusByStatusAndBMICategory(int status, String bmiCategory) {
        List<Menu> list = new ArrayList<>();
        String query = "SELECT * FROM Menu WHERE Status = ? AND BMICategory = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, status);
            ps.setString(2, bmiCategory);
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
                double total = 0;
                for (Product p : m.getProducts()) {
                    total += p.getPrice();
                }
                m.setTotalPrice(total);
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Menu> getMenusByStatusesAndBMICategory(List<Integer> statuses, String bmiCategory) {
        List<Menu> list = new ArrayList<>();
        if (statuses == null || statuses.isEmpty()) {
            return list;
        }

        String placeholders = statuses.stream().map(s -> "?").collect(Collectors.joining(","));
        String query = "SELECT * FROM Menu WHERE Status IN (" + placeholders + ") AND BMICategory = ? ORDER BY MenuID DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            int index = 1;
            for (int status : statuses) {
                ps.setInt(index++, status);
            }
            ps.setString(index, bmiCategory);

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
                double total = 0;
                for (Product p : m.getProducts()) {
                    total += p.getPrice();
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

    public List<Menu> getNewestApprovedMenus(int limit) {
        List<Menu> list = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM Menu WHERE Status IN (3,4) ORDER BY MenuID DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
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
                double total = 0;
                for (Product p : m.getProducts()) {
                    total += p.getPrice();
                }
                m.setTotalPrice(total);
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
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

    public boolean updateMenuStatus(int menuID, int newStatus) {
        String sql = "UPDATE Menu SET Status = ? WHERE MenuID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newStatus);
            ps.setInt(2, menuID);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thêm menu mới, trả về MenuID vừa insert (SQL Server), status=1 (đang chờ duyệt)
    public int addMenu(Menu menu) {
        int menuID = -1;
        String sql = "INSERT INTO Menu (MenuName, Description, BMICategory, ImageURL, NutritionistID, Status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, menu.getMenuName());
            ps.setString(2, menu.getDescription());
            ps.setString(3, menu.getBmiCategory());
            ps.setString(4, menu.getImageURL());
            ps.setInt(5, menu.getNutritionistID());
            ps.setInt(6, 1); // luôn luôn là 1 khi nutritionist tạo
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

// Thêm 1 món ăn vào menu (chuẩn style)
    public void addMenuProduct(int menuID, int productID) {
        String sql = "INSERT INTO MenuProduct (MenuID, ProductID) VALUES (?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, menuID);
            ps.setInt(2, productID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Menu> getMenusByStatus(int status) {
        List<Menu> list = new ArrayList<>();
        String query = "SELECT * FROM Menu WHERE Status = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, status);
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
                double total = 0;
                for (Product p : m.getProducts()) {
                    total += p.getPrice();
                }
                m.setTotalPrice(total);
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Menu> getMenusByStatuses34() {
        List<Menu> list = new ArrayList<>();
        String query = "SELECT * FROM Menu WHERE Status IN (3, 4) ORDER BY MenuID DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
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
                double total = 0;
                for (Product p : m.getProducts()) {
                    total += p.getPrice();
                }
                m.setTotalPrice(total);
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Menu> getMenusByNutritionist(int nutritionistID) {
        List<Menu> list = new ArrayList<>();
        String query = "SELECT * FROM Menu WHERE NutritionistID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, nutritionistID);
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
                double total = 0;
                for (Product p : m.getProducts()) {
                    total += p.getPrice();
                }
                m.setTotalPrice(total);
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<Integer, Integer> getStatusMapByNutritionist(int nutritionistID) {
        Map<Integer, Integer> map = new HashMap<>();
        String sql = "SELECT MenuID, Status FROM Menu WHERE NutritionistID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, nutritionistID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                map.put(rs.getInt("MenuID"), rs.getInt("Status"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

// Lấy status để xác minh trước khi xóa
    public int getMenuStatusByID(int menuID, int nutritionistID) {
        String sql = "SELECT Status FROM Menu WHERE MenuID = ? AND NutritionistID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, menuID);
            ps.setInt(2, nutritionistID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("Status");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // Không tồn tại hoặc không thuộc về user
    }

    public void deleteMenu(int menuID) {
        String deleteMenuProduct = "DELETE FROM MenuProduct WHERE MenuID = ?";
        String deleteMenu = "DELETE FROM Menu WHERE MenuID = ?";
        try (Connection conn = getConnection()) {
            // Xóa món trong MenuProduct trước
            try (PreparedStatement ps1 = conn.prepareStatement(deleteMenuProduct)) {
                ps1.setInt(1, menuID);
                ps1.executeUpdate();
            }
            try (PreparedStatement ps2 = conn.prepareStatement(deleteMenu)) {
                ps2.setInt(1, menuID);
                ps2.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

// Trong MenuDAO:
    public List<String> getProductNamesByMenu(int menuID) {
        List<String> productNames = new ArrayList<>();
        String sql = "SELECT p.name FROM MenuProduct mp JOIN Product p ON mp.productID = p.productID WHERE mp.menuID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, menuID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                productNames.add(rs.getString("name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return productNames;
    }

    public List<String> getAllManagerEmails() {
        List<String> emails = new ArrayList<>();
        try {
            String sql = "SELECT email FROM Users WHERE roleid = 3";
            PreparedStatement ps = getConnection().prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                emails.add(rs.getString("email"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return emails;
    }

    public boolean deleteMenuWithResult(int menuID) {
        String deleteMenuProduct = "DELETE FROM MenuProduct WHERE MenuID = ?";
        String deleteMenu = "DELETE FROM Menu WHERE MenuID = ?";
        try (Connection conn = getConnection()) {
            int affected = 0;

            try (PreparedStatement ps1 = conn.prepareStatement(deleteMenuProduct)) {
                ps1.setInt(1, menuID);
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = conn.prepareStatement(deleteMenu)) {
                ps2.setInt(1, menuID);
                affected = ps2.executeUpdate();
            }

            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean applySuaMenuWithResult(int menuID) {
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false); // Bắt đầu giao dịch

            // Lấy thông tin từ SuaMenu
            String getSuaMenu = "SELECT MenuName, Description, ImageURL, BMICategory FROM SuaMenu WHERE MenuID = ?";
            try (PreparedStatement ps1 = conn.prepareStatement(getSuaMenu)) {
                ps1.setInt(1, menuID);
                ResultSet rs = ps1.executeQuery();
                if (!rs.next()) {
                    return false;
                }

                String name = rs.getString("MenuName");
                String desc = rs.getString("Description");
                String img = rs.getString("ImageURL");
                String bmi = rs.getString("BMICategory");

                // Cập nhật bảng Menu
                String updateMenu = "UPDATE Menu SET MenuName = ?, Description = ?, ImageURL = ?, BMICategory = ? WHERE MenuID = ?";
                try (PreparedStatement ps2 = conn.prepareStatement(updateMenu)) {
                    ps2.setString(1, name);
                    ps2.setString(2, desc);
                    ps2.setString(3, img);
                    ps2.setString(4, bmi);
                    ps2.setInt(5, menuID);
                    ps2.executeUpdate();
                }

                // Xóa MenuProduct cũ
                String deleteOldProducts = "DELETE FROM MenuProduct WHERE MenuID = ?";
                try (PreparedStatement ps3 = conn.prepareStatement(deleteOldProducts)) {
                    ps3.setInt(1, menuID);
                    ps3.executeUpdate();
                }

                // Thêm lại sản phẩm từ bảng SuaMenuProduct
                String insertProducts = "INSERT INTO MenuProduct(MenuID, ProductID) SELECT MenuID, ProductID FROM SuaMenuProduct WHERE MenuID = ?";
                try (PreparedStatement ps4 = conn.prepareStatement(insertProducts)) {
                    ps4.setInt(1, menuID);
                    ps4.executeUpdate();
                }

                // Xóa bảng sửa
                try (PreparedStatement ps5 = conn.prepareStatement("DELETE FROM SuaMenuProduct WHERE MenuID = ?")) {
                    ps5.setInt(1, menuID);
                    ps5.executeUpdate();
                }

                try (PreparedStatement ps6 = conn.prepareStatement("DELETE FROM SuaMenu WHERE MenuID = ?")) {
                    ps6.setInt(1, menuID);
                    ps6.executeUpdate();
                }

                conn.commit(); // Xác nhận thay đổi
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean rejectSuaMenuWithResult(int menuID) {
        try (Connection conn = getConnection()) {
            int affected = 0;

            try (PreparedStatement ps1 = conn.prepareStatement("DELETE FROM SuaMenuProduct WHERE MenuID = ?")) {
                ps1.setInt(1, menuID);
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = conn.prepareStatement("DELETE FROM SuaMenu WHERE MenuID = ?")) {
                ps2.setInt(1, menuID);
                affected = ps2.executeUpdate(); // affected sẽ là 1 nếu xóa thành công
            }

            return affected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Menu> getMenusFromSuaMenu() {
        List<Menu> list = new ArrayList<>();
        String sql = "SELECT sm.MenuID, sm.MenuName, sm.Description, sm.ImageURL, sm.BMICategory, sm.NutritionistID "
                + "FROM SuaMenu sm";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int menuId = rs.getInt("MenuID");
                String menuName = rs.getString("MenuName");
                String description = rs.getString("Description");
                String imageURL = rs.getString("ImageURL");
                String bmiCategory = rs.getString("BMICategory");
                int nutritionistID = rs.getInt("NutritionistID");

                // Lấy danh sách sản phẩm từ bảng SuaMenuProduct
                List<Product> products = getProductsFromSuaMenu(menuId);

                Menu menu = new Menu(menuId, menuName, description, imageURL, bmiCategory, nutritionistID, products);

                // Tính tổng giá
                double total = 0;
                for (Product p : products) {
                    total += p.getPrice();
                }
                menu.setTotalPrice(total);

                list.add(menu);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<Product> getProductsFromSuaMenu(int menuId) {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.ProductID, p.Name, p.Description, p.ImageURL, p.Price "
                + "FROM Product p "
                + "JOIN SuaMenuProduct smp ON p.ProductID = smp.ProductID "
                + "WHERE smp.MenuID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, menuId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setProductID(rs.getInt("ProductID"));
                p.setName(rs.getString("Name"));
                p.setDescription(rs.getString("Description"));
                p.setImageURL(rs.getString("ImageURL"));
                p.setPrice(rs.getDouble("Price"));
                products.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return products;
    }

    public boolean copyMenuToSuaMenu(int menuID) {
        try (Connection conn = getConnection()) {
            // Kiểm tra nếu đã có SuaMenu thì không cần copy lại
            String checkSql = "SELECT COUNT(*) FROM SuaMenu WHERE MenuID = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, menuID);
                ResultSet rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    return true; // đã tồn tại
                }
            }

            // Copy sang SuaMenu
            String insertSuaMenu = "INSERT INTO SuaMenu (MenuID, MenuName, Description, ImageURL, BMICategory, NutritionistID) "
                    + "SELECT MenuID, MenuName, Description, ImageURL, BMICategory, NutritionistID FROM Menu WHERE MenuID = ?";
            try (PreparedStatement ps = conn.prepareStatement(insertSuaMenu)) {
                ps.setInt(1, menuID);
                ps.executeUpdate();
            }

            // Copy sang SuaMenuProduct
            String insertSuaMenuProduct = "INSERT INTO SuaMenuProduct(MenuID, ProductID) "
                    + "SELECT MenuID, ProductID FROM MenuProduct WHERE MenuID = ?";
            try (PreparedStatement ps = conn.prepareStatement(insertSuaMenuProduct)) {
                ps.setInt(1, menuID);
                ps.executeUpdate();
            }

            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateSuaMenu(int menuID, String name, String desc, String img, String bmi) {
        String sql = "UPDATE SuaMenu SET MenuName = ?, Description = ?, ImageURL = ?, BMICategory = ? WHERE MenuID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, desc);
            ps.setString(3, img);
            ps.setString(4, bmi);
            ps.setInt(5, menuID);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Product";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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

    public List<Integer> getProductIDsByMenu(int menuID) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT ProductID FROM MenuProduct WHERE MenuID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, menuID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("ProductID"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }

    public String getUserNameByID(int userID) {
        String sql = "SELECT fullName FROM Users WHERE userID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("fullName");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Unknown";
    }

    public List<Menu> searchMenusByName(String keyword) {
        List<Menu> list = new ArrayList<>();
        String sql = "SELECT * FROM Menu WHERE (Status = 3 OR Status = 4) AND MenuName LIKE ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
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

                double total = 0;
                for (Product p : m.getProducts()) {
                    total += p.getPrice();
                }
                m.setTotalPrice(total);
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // làm pagination @.@
    public int countMenusByBMICategory(String bmi) {
        String sql = "SELECT COUNT(*) FROM Menu WHERE Status IN (3,4)"
                + (bmi == null || bmi.isEmpty() ? "" : " AND BMICategory = ?");
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (bmi != null && !bmi.isEmpty()) {
                ps.setString(1, bmi);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Menu> getMenusByBMICategoryPaging(String bmi, int offset, int pageSize) {
        List<Menu> list = new ArrayList<>();
        String sql = "SELECT * FROM Menu WHERE Status IN (3,4)"
                + (bmi == null || bmi.isEmpty() ? "" : " AND BMICategory = ?")
                + " ORDER BY MenuID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            if (bmi != null && !bmi.isEmpty()) {
                ps.setString(idx++, bmi);
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Menu m = new Menu(
                        rs.getInt("MenuID"), rs.getString("MenuName"), rs.getString("Description"),
                        rs.getString("ImageURL"), rs.getString("BMICategory"), rs.getInt("NutritionistID")
                );
                m.setProducts(getProductsInMenu(m.getMenuID(), conn));
                double total = 0;
                for (Product p : m.getProducts()) {
                    total += p.getPrice();
                }
                m.setTotalPrice(total);
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countAllMenusByStatuses34() {
        String sql = "SELECT COUNT(*) FROM Menu WHERE Status IN (3,4)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Menu> getMenusByStatuses34Paging(int offset, int pageSize) {
        List<Menu> list = new ArrayList<>();
        String sql = "SELECT * FROM Menu WHERE Status IN (3,4) ORDER BY MenuID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Menu m = new Menu(
                        rs.getInt("MenuID"), rs.getString("MenuName"), rs.getString("Description"),
                        rs.getString("ImageURL"), rs.getString("BMICategory"), rs.getInt("NutritionistID")
                );
                m.setProducts(getProductsInMenu(m.getMenuID(), conn));
                double total = 0;
                for (Product p : m.getProducts()) {
                    total += p.getPrice();
                }
                m.setTotalPrice(total);
                list.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteRequestEditMenu(int menuID) {
        String deleteSuaMenuProduct = "DELETE FROM SuaMenuProduct WHERE MenuID = ?";
        String deleteSuaMenu = "DELETE FROM SuaMenu WHERE MenuID = ?";
        try (Connection conn = getConnection()) {

            try (PreparedStatement ps1 = conn.prepareStatement(deleteSuaMenuProduct)) {
                ps1.setInt(1, menuID);
                ps1.executeUpdate();
            }
            try (PreparedStatement ps2 = conn.prepareStatement(deleteSuaMenu)) {
                ps2.setInt(1, menuID);
                ps2.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getEmailByUserId(int userId) {
        String sql = "SELECT email FROM Users WHERE userID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("email");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<String> getEmailsByRoleId(int roleId) {
        List<String> emails = new ArrayList<>();
        String sql = "SELECT email FROM Users WHERE roleID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    emails.add(rs.getString("email"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return emails;
    }

    public static void main(String[] args) {
        MenuDAO dao = new MenuDAO();
        List<Menu> list = dao.searchMenusByName("rồng");
        for (Menu o : list) {
            System.out.println(o);
        }
    }
}
