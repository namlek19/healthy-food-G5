package model;

import java.util.Date;

public class Product {

    private int productID;
    private String name;
    private String description;
    private String nutritionInfo;
    private String origin;
    private String imageURL;
    private String storageInstructions;
    private double price;
    private int categoryID;
    private int calories;

    // Constructors
    public Product() {
    }

    public Product(int productID, String name, String description, String nutritionInfo, String origin, String imageURL, String storageInstructions, double price, int categoryID, int calories) {
        this.productID = productID;
        this.name = name;
        this.description = description;
        this.nutritionInfo = nutritionInfo;
        this.origin = origin;
        this.imageURL = imageURL;
        this.storageInstructions = storageInstructions;
        this.price = price;
        this.categoryID = categoryID;
        this.calories = calories;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getNutritionInfo() {
        return nutritionInfo;
    }

    public void setNutritionInfo(String nutritionInfo) {
        this.nutritionInfo = nutritionInfo;
    }

    public String getOrigin() {
        return origin;
    }

    public void setOrigin(String origin) {
        this.origin = origin;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public String getStorageInstructions() {
        return storageInstructions;
    }

    public void setStorageInstructions(String storageInstructions) {
        this.storageInstructions = storageInstructions;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public int getCalories() {
        return calories;
    }

    public void setCalories(int calories) {
        this.calories = calories;
    }

}
