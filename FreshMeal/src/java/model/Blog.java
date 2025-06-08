package model;

import java.util.Date;

public class Blog {

    private int blogID;
    private String title;
    private String imageURL;
    private String description;
    private int nutritionistID;
    private String nutritionistName; // join từ Users
    private Date createdAt;
    private int likeCount; // tổng số like

    public Blog() {
    }

    public Blog(int blogID, String title, String imageURL, String description, int nutritionistID, String nutritionistName, Date createdAt, int likeCount) {
        this.blogID = blogID;
        this.title = title;
        this.imageURL = imageURL;
        this.description = description;
        this.nutritionistID = nutritionistID;
        this.nutritionistName = nutritionistName;
        this.createdAt = createdAt;
        this.likeCount = likeCount;
    }

    // Getters and Setters
    public int getBlogID() {
        return blogID;
    }

    public void setBlogID(int blogID) {
        this.blogID = blogID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getNutritionistID() {
        return nutritionistID;
    }

    public void setNutritionistID(int nutritionistID) {
        this.nutritionistID = nutritionistID;
    }

    public String getNutritionistName() {
        return nutritionistName;
    }

    public void setNutritionistName(String nutritionistName) {
        this.nutritionistName = nutritionistName;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public int getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }
}
