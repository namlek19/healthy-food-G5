package model;

public class User {
    private int userID;
    private String fullName;
    private String firstName;  // For form handling
    private String lastName;   // For form handling
    private String email;
    private String passwordHash;
    private String city;
    private String district;
    private String address;
    private float heightCm;
    private float weightKg;
    private float bmi;  // This is now read-only, calculated by the database
    private String bmiCategory;
    private int roleID;
    
    public User() {
    }
    
    public User(int userID, String fullName, String email, String passwordHash, String city, 
                String district, String address, float heightCm, float weightKg, 
                float bmi, String bmiCategory, int roleID) {
        this.userID = userID;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.city = city;
        this.district = district;
        this.address = address;
        this.heightCm = heightCm;
        this.weightKg = weightKg;
        this.bmi = bmi;  // Set from database value
        this.bmiCategory = bmiCategory;
        this.roleID = roleID;
        
        // Split fullName into firstName and lastName if fullName contains a space
        if (fullName != null && fullName.contains(" ")) {
            int lastSpaceIndex = fullName.lastIndexOf(" ");
            this.firstName = fullName.substring(0, lastSpaceIndex).trim();
            this.lastName = fullName.substring(lastSpaceIndex + 1).trim();
        } else {
            this.firstName = fullName;
            this.lastName = "";
        }
    }

    // Additional constructor for form handling
    public User(int userID, String firstName, String lastName, String email, String passwordHash, 
                String city, String district, String address, float heightCm, float weightKg, 
                float bmi, String bmiCategory, int roleID) {
        this.userID = userID;
        this.firstName = firstName;
        this.lastName = lastName;
        this.fullName = (firstName + " " + lastName).trim();
        this.email = email;
        this.passwordHash = passwordHash;
        this.city = city;
        this.district = district;
        this.address = address;
        this.heightCm = heightCm;
        this.weightKg = weightKg;
        this.bmi = bmi;
        this.bmiCategory = bmiCategory;
        this.roleID = roleID;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
        // Update firstName and lastName when fullName is set
        if (fullName != null && fullName.contains(" ")) {
            int lastSpaceIndex = fullName.lastIndexOf(" ");
            this.firstName = fullName.substring(0, lastSpaceIndex).trim();
            this.lastName = fullName.substring(lastSpaceIndex + 1).trim();
        } else {
            this.firstName = fullName;
            this.lastName = "";
        }
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
        updateFullName();
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
        updateFullName();
    }

    // Helper method to update fullName when firstName or lastName changes
    private void updateFullName() {
        this.fullName = (firstName + " " + lastName).trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public float getHeightCm() {
        return heightCm;
    }

    public void setHeightCm(float heightCm) {
        this.heightCm = heightCm;
    }

    public float getWeightKg() {
        return weightKg;
    }

    public void setWeightKg(float weightKg) {
        this.weightKg = weightKg;
    }

    public float getBmi() {
        return bmi;
    }

    // This setter should only be used when loading from database
    public void setBmi(float bmi) {
        this.bmi = bmi;
    }

    public String getBmiCategory() {
        return bmiCategory;
    }

    public void setBmiCategory(String bmiCategory) {
        this.bmiCategory = bmiCategory;
    }

    public int getRoleID() {
        return roleID;
    }

    public void setRoleID(int roleID) {
        this.roleID = roleID;
    }
} 
