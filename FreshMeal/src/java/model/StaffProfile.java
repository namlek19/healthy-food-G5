package model;

public class StaffProfile {
    private int staffID; // StaffID từ bảng StaffProfile
    private int userID;  // UserID liên kết với bảng Users
    private String avatarURL;
    private String description;

    public StaffProfile() {
    }

    public StaffProfile(int staffID, int userID, String avatarURL, String description) {
        this.staffID = staffID;
        this.userID = userID;
        this.avatarURL = avatarURL;
        this.description = description;
    }

    // Getters and Setters
    public int getStaffID() {
        return staffID;
    }

    public void setStaffID(int staffID) {
        this.staffID = staffID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getAvatarURL() {
        return avatarURL;
    }

    public void setAvatarURL(String avatarURL) {
        this.avatarURL = avatarURL;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}