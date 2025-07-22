package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.User;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;
    private DBContext db;

    public UserDAO() {
        db = new DBContext();
    }

    public User checkLogin(String email, String password) {
        try {
            String query = "SELECT * FROM Users WHERE Email = ? AND PasswordHash = ?";
            conn = db.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                return new User(
                        rs.getInt("UserID"),
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("PasswordHash"),
                        rs.getString("City"),
                        rs.getString("District"),
                        rs.getString("Address"),
                        rs.getInt("RoleID")
                );
            }
        } catch (Exception e) {
            System.out.println("Error in checkLogin: " + e.getMessage());
        } finally {
            try {
                if (db != null) {
                    db.closeConnection(conn, ps, rs);
                }
            } catch (SQLException e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }
        return null;
    }

    public boolean registerUser(User user) {
        try {
            System.out.println("DEBUG: Starting user registration for email: " + user.getEmail());
            String query = "INSERT INTO Users (FullName, Email, PasswordHash, City, District, Address, RoleID) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";
            conn = db.getConnection();
            ps = conn.prepareStatement(query);

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getCity());
            ps.setString(5, user.getDistrict());
            ps.setString(6, user.getAddress());
            ps.setInt(7, 2); // Default role as Customer (RoleID = 2)

            boolean result = ps.executeUpdate() > 0;
            System.out.println("DEBUG: Registration result: " + result);
            return result;
        } catch (Exception e) {
            System.out.println("DEBUG: Error in registerUser: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (db != null) {
                    db.closeConnection(conn, ps, rs);
                }
            } catch (SQLException e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }
    }

    public boolean checkEmailExists(String email) {
        try {
            String query = "SELECT COUNT(*) FROM Users WHERE Email = ?";
            conn = db.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            System.out.println("Error in checkEmailExists: " + e.getMessage());
        } finally {
            try {
                if (db != null) {
                    db.closeConnection(conn, ps, rs);
                }
            } catch (SQLException e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }
        return false;
    }

    public User getUserByID(int userID) {
        try {
            String query = "SELECT * FROM Users WHERE UserID = ?";
            conn = db.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userID);
            rs = ps.executeQuery();

            if (rs.next()) {
                return new User(
                        rs.getInt("UserID"),
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("PasswordHash"),
                        rs.getString("City"),
                        rs.getString("District"),
                        rs.getString("Address"),
                        rs.getInt("RoleID")
                );
            }
        } catch (Exception e) {
            System.out.println("Error in getUserByID: " + e.getMessage());
        } finally {
            try {
                if (db != null) {
                    db.closeConnection(conn, ps, rs);
                }
            } catch (SQLException e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }
        return null;
    }

    public User getUserByEmail(String email) {
        try {
            String query = "SELECT * FROM Users WHERE Email = ?";
            conn = db.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                return new User(
                        rs.getInt("UserID"),
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("PasswordHash"),
                        rs.getString("City"),
                        rs.getString("District"),
                        rs.getString("Address"),
                        rs.getInt("RoleID")
                );
            }
        } catch (Exception e) {
            System.out.println("Error in getUserByEmail: " + e.getMessage());
        } finally {
            try {
                if (db != null) {
                    db.closeConnection(conn, ps, rs);
                }
            } catch (SQLException e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }
        return null;
    }

    public boolean updatePassword(String email, String newPassword) {
        try {
            String query = "UPDATE Users SET PasswordHash = ? WHERE Email = ?";
            conn = db.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, newPassword);
            ps.setString(2, email);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error in updatePassword: " + e.getMessage());
            return false;
        } finally {
            try {
                if (db != null) {
                    db.closeConnection(conn, ps, rs);
                }
            } catch (SQLException e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }
    }

    public User findUserByEmail(String email) {
        try {
            String query = "SELECT * FROM Users WHERE Email = ?";
            conn = db.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User(
                        rs.getInt("UserID"),
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("PasswordHash"),
                        rs.getString("City"),
                        rs.getString("District"),
                        rs.getString("Address"),
                        rs.getInt("RoleID")
                );
                return user;
            }
        } catch (Exception e) {
            System.out.println("Error in findUserByEmail: " + e.getMessage());
        } finally {
            try {
                if (db != null) {
                    db.closeConnection(conn, ps, rs);
                }
            } catch (SQLException e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }
        return null;
    }

    public List<User> getAllShippers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE RoleID = 6"; 
        try {
            conn = db.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new User(
                        rs.getInt("UserID"),
                        rs.getString("FullName"),
                        rs.getString("Email"),
                        rs.getString("PasswordHash"),
                        rs.getString("City"),
                        rs.getString("District"),
                        rs.getString("Address"),
                        rs.getInt("RoleID")
                ));
            }
        } catch (Exception e) {
            System.out.println("Error in getAllShippers: " + e.getMessage());
        } finally {
            try {
                if (db != null) {
                    db.closeConnection(conn, ps, rs);
                }
            } catch (SQLException e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }
        return list;
    }

    public boolean updateUser(User user) {
        try {
            String query = "UPDATE Users SET FullName = ?, City = ?, District = ?, Address = ? WHERE UserID = ?";
            conn = db.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getCity());
            ps.setString(3, user.getDistrict());
            ps.setString(4, user.getAddress());
            ps.setInt(5, user.getUserID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error in updateUser: " + e.getMessage());
            return false;
        } finally {
            try {
                if (db != null) {
                    db.closeConnection(conn, ps, rs);
                }
            } catch (SQLException e) {
                System.out.println("Error closing resources: " + e.getMessage());
            }
        }
    }
public boolean updateUserRole(int userId, int newRoleId) {
    try {
        String query = "UPDATE Users SET RoleID = ? WHERE UserID = ?";
        conn = db.getConnection();
        ps = conn.prepareStatement(query);
        ps.setInt(1, newRoleId);
        ps.setInt(2, userId);
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        System.out.println("Error in updateUserRole: " + e.getMessage());
        return false;
    } finally {
        try {
            if (db != null) {
                db.closeConnection(conn, ps, rs);
            }
        } catch (SQLException e) {
            System.out.println("Error closing resources: " + e.getMessage());
        }
    }
}

public List<User> getAllUsers() {
    List<User> list = new ArrayList<>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // JOIN bảng Role để lấy tên vai trò
        String query = "SELECT u.UserID, u.FullName, u.Email, u.PasswordHash, u.City, u.District, u.Address, u.RoleID, r.RoleName " +
                       "FROM Users u " +
                       "JOIN Role r ON u.RoleID = r.RoleID";
        conn = db.getConnection();
        ps = conn.prepareStatement(query);
        rs = ps.executeQuery();
        while (rs.next()) {
            User user = new User();
            user.setUserID(rs.getInt("UserID"));
            user.setFullName(rs.getString("FullName"));
            user.setEmail(rs.getString("Email"));
            user.setPasswordHash(rs.getString("PasswordHash"));
            user.setCity(rs.getString("City"));
            user.setDistrict(rs.getString("District"));
            user.setAddress(rs.getString("Address"));
            user.setRoleID(rs.getInt("RoleID"));
            user.setRoleName(rs.getString("RoleName"));  // <<-- thêm dòng này

            list.add(user);
        }
    } catch (Exception e) {
        System.out.println("Error in getAllUsers: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.out.println("Error closing resources: " + e.getMessage());
        }
    }
    return list;
}
public boolean insertUser(User user) {
    Connection conn = null;
    PreparedStatement ps = null;
    try {
        String query = "INSERT INTO Users (FullName, Email, PasswordHash, City, District, Address, RoleID) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?)";
        conn = db.getConnection();
        ps = conn.prepareStatement(query);

        ps.setString(1, user.getFullName());
        ps.setString(2, user.getEmail());
        ps.setString(3, user.getPasswordHash());
        ps.setString(4, user.getCity());
        ps.setString(5, user.getDistrict());
        ps.setString(6, user.getAddress());
        ps.setInt(7, user.getRoleID());

        int rows = ps.executeUpdate();
        return rows > 0;

    } catch (Exception e) {
        System.out.println("Insert User Error: " + e.getMessage());
        return false;
    } finally {
        try {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.out.println("Close conn error: " + e.getMessage());
        }
    }
}
public boolean isEmailExists(String email) {
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        String query = "SELECT 1 FROM Users WHERE Email = ?";
        conn = db.getConnection();  // giống như insertUser()
        ps = conn.prepareStatement(query);
        ps.setString(1, email);
        rs = ps.executeQuery();
        return rs.next(); 

    } catch (Exception e) {
        System.out.println("Check Email Exists Error: " + e.getMessage());
        return false;
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.out.println("Close conn error: " + e.getMessage());
        }
    }
}




}
