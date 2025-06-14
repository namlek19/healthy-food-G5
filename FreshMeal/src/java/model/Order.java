package model;

import java.util.Date;

public class Order {
    private int orderID;
    private int userID;
    private String receiverName;
    private String deliveryAddress;
    private String district;
    private double totalAmount;
    private Date orderDate;
    private String status;

    public Order() {
    }

    public Order(int orderID, int userID, String receiverName, String deliveryAddress, String district, double totalAmount, Date orderDate, String status) {
        this.orderID = orderID;
        this.userID = userID;
        this.receiverName = receiverName;
        this.deliveryAddress = deliveryAddress;
        this.district = district;
        this.totalAmount = totalAmount;
        this.orderDate = orderDate;
        this.status = status;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Date getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Date orderDate) {
        this.orderDate = orderDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    
}

