package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.User;
import dal.DBContext;

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
            e.printStackTrace(); // This will print the full error stack trace
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
} 