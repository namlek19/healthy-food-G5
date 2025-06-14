package model;

public class OrderItem {
    private int orderItemID;
    private int orderID;
    private int productID;
    private String productName;
    private String imageUrl;
    private int quantity;
    private double price;

    // ===== Constructors =====
    public OrderItem() {}

    public OrderItem(int orderItemID, int orderID, int productID, String productName, String imageUrl, int quantity, double price) {
        this.orderItemID = orderItemID;
        this.orderID = orderID;
        this.productID = productID;
        this.productName = productName;
        this.imageUrl = imageUrl;
        this.quantity = quantity;
        this.price = price;
    }

    // ===== Getters & Setters =====
    public int getOrderItemID() {
        return orderItemID;
    }

    public void setOrderItemID(int orderItemID) {
        this.orderItemID = orderItemID;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}
