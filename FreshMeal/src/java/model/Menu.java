package model;

import java.util.List;

public class Menu {

    private int menuID;
    private String menuName;
    private String description;
    private String imageURL;
    private String bmiCategory;
    private int nutritionistID;
    private List<Product> products;
    private double totalPrice;

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Menu() {
    }

    public Menu(int menuID, String menuName, String description, String imageURL, String bmiCategory, int nutritionistID, List<Product> products) {
        this.menuID = menuID;
        this.menuName = menuName;
        this.description = description;
        this.imageURL = imageURL;
        this.bmiCategory = bmiCategory;
        this.nutritionistID = nutritionistID;
        this.products = products;
    }

    public Menu(int menuID, String menuName, String description, String imageURL, String bmiCategory, int nutritionistID) {
        this.menuID = menuID;
        this.menuName = menuName;
        this.description = description;
        this.imageURL = imageURL;
        this.bmiCategory = bmiCategory;
        this.nutritionistID = nutritionistID;
    }

    public int getMenuID() {
        return menuID;
    }

    public void setMenuID(int menuID) {
        this.menuID = menuID;
    }

    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public String getBmiCategory() {
        return bmiCategory;
    }

    public void setBmiCategory(String bmiCategory) {
        this.bmiCategory = bmiCategory;
    }

    public int getNutritionistID() {
        return nutritionistID;
    }

    public void setNutritionistID(int nutritionistID) {
        this.nutritionistID = nutritionistID;
    }

    public List<Product> getProducts() {
        return products;
    }

    public void setProducts(List<Product> products) {
        this.products = products;
    }

    @Override
    public String toString() {
        return "Menu{" + "menuID=" + menuID + ", menuName=" + menuName + ", description=" + description + ", imageURL=" + imageURL + ", bmiCategory=" + bmiCategory + ", nutritionistID=" + nutritionistID + ", products=" + products + '}';
    }

}
