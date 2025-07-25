package dal;

import model.StaffProfile;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class StaffProfileDAO extends DBContext { // Kế thừa từ DBContext
    
    // Lấy StaffProfile bằng UserID
    public StaffProfile getStaffProfileByUserId(int userId) throws Exception {
        StaffProfile staffProfile = null;
        String sql = "SELECT StaffID, UserID, AvatarURL, Description FROM StaffProfile WHERE UserID = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    staffProfile = new StaffProfile();
                    staffProfile.setStaffID(rs.getInt("StaffID"));
                    staffProfile.setUserID(rs.getInt("UserID"));
                    staffProfile.setAvatarURL(rs.getString("AvatarURL"));
                    staffProfile.setDescription(rs.getString("Description"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Xử lý exception
        }
        return staffProfile;
    }

    // Cập nhật StaffProfile
    public boolean updateStaffProfile(StaffProfile staffProfile) throws Exception {
        String sql = "UPDATE StaffProfile SET AvatarURL = ?, Description = ? WHERE UserID = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, staffProfile.getAvatarURL());
            ps.setString(2, staffProfile.getDescription());
            ps.setInt(3, staffProfile.getUserID());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thêm StaffProfile mới (nếu chưa có)
    public boolean insertStaffProfile(StaffProfile staffProfile) throws Exception {
        String sql = "INSERT INTO StaffProfile (UserID, AvatarURL, Description) VALUES (?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, staffProfile.getUserID());
            ps.setString(2, staffProfile.getAvatarURL());
            ps.setString(3, staffProfile.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}