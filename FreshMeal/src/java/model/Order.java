package model;

import java.util.Date;
import java.util.List;

public class Order {
    private int orderID;
    private int userID;
    private int shipperID;
    private String receiverName;
    private String phone; 
    private String deliveryAddress;
    private String district;
    private double totalAmount;
    private Date orderDate;
    private String status;
    private String Email;
    private List<OrderItem> items;

    public Order() {
    }

    public Order(int orderID, int userID, int shipperID, String receiverName, String phone, String deliveryAddress, String district, double totalAmount, Date orderDate, String status, String Email, List<OrderItem> items) {
        this.orderID = orderID;
        this.userID = userID;
        this.shipperID = shipperID;
        this.receiverName = receiverName;
        this.phone = phone;
        this.deliveryAddress = deliveryAddress;
        this.district = district;
        this.totalAmount = totalAmount;
        this.orderDate = orderDate;
        this.status = status;
        this.Email = Email;
        this.items = items;
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

    public int getShipperID() {
        return shipperID;
    }

    public void setShipperID(int shipperID) {
        this.shipperID = shipperID;
    }

    public String getReceiverName() {
        return receiverName;
    }

    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
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

    public String getEmail() {
        return Email;
    }

    public void setEmail(String Email) {
        this.Email = Email;
    }

    public List<OrderItem> getItems() {
        return items;
    }

    public void setItems(List<OrderItem> items) {
        this.items = items;
    }
}