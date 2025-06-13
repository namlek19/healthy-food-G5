package controller;

import dal.CartDAO;
import dal.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import model.CartItem;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        System.out.println("DEBUG: Received action: " + action);

        try {
            if (action == null) {
                // Display login page
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            switch (action) {
                case "checkEmail":
                    handleCheckEmail(request, response);
                    break;

                case "register":
                    handleRegistration(request, response);
                    break;

                case "login":
                    handleLogin(request, response);
                    break;

                case "logout":
                    handleLogout(request, response);
                    break;

                case "googleLogin":
                    handleGoogleLogin(request, response);
                    break;

                default:
                    // Invalid action, redirect to login page
                    response.sendRedirect("login.jsp");
                    break;
            }
        } catch (Exception e) {
            System.out.println("DEBUG: Unexpected error in servlet:");
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "An unexpected error occurred. Please try again.");
            response.sendRedirect("login.jsp");
        }
    }

    private void handleCheckEmail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        UserDAO userDAO = new UserDAO();
        boolean exists = userDAO.checkEmailExists(email);
        response.getWriter().write("{\"exists\": " + exists + "}");
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate input
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Email and password are required");
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.checkLogin(email, password);

            if (user != null) {
                // Login successful
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                CartDAO cartDAO = new CartDAO();
                List<CartItem> dbCart = cartDAO.getCartItemsByUser(user.getUserID());
                session.setAttribute("cart", dbCart);

                response.sendRedirect("index.jsp");
            } else {
                // Login failed
                request.getSession().setAttribute("errorMessage", "Invalid email or password");
                response.sendRedirect("login.jsp");
            }
        } catch (Exception e) {
            System.out.println("DEBUG: Error in login: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "An error occurred during login. Please try again.");
            response.sendRedirect("login.jsp");
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect("index.jsp");
    }

    private void handleGoogleLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            String email = request.getParameter("email");
            String fullName = request.getParameter("fullName");
            String googleId = request.getParameter("googleId");
            String imageUrl = request.getParameter("imageUrl");
            String idToken = request.getParameter("idToken");

            // Validate required parameters
            if (email == null || email.trim().isEmpty()
                    || fullName == null || fullName.trim().isEmpty()
                    || googleId == null || googleId.trim().isEmpty()) {
                throw new Exception("Missing required Google Sign-In data");
            }

            UserDAO userDAO = new UserDAO();
            User user = userDAO.findUserByEmail(email);

            if (user == null) {
                // Create new user for first-time Google login
                user = new User();
                user.setEmail(email);
                user.setFullName(fullName);

                // Set default values for required fields
                user.setCity("");
                user.setDistrict("");
                user.setAddress("");
                user.setHeightCm(0);
                user.setWeightKg(0);
                user.setBmi(0);
                user.setBmiCategory("Not Set");
                // For Google users, we set a secure random password
                String securePassword = generateSecurePassword();
                user.setPasswordHash(securePassword);

                if (!userDAO.registerUser(user)) {
                    throw new Exception("Failed to create user account");
                }
            } else {
                // Update existing user's Google-related info

            }

            // Set session attributes
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("isGoogleUser", true);

            // Return success response
            out.write("{\"success\": true}");

        } catch (Exception e) {
            System.out.println("DEBUG: Error in Google login: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"success\": false, \"message\": \"" + escapeJsonString(e.getMessage()) + "\"}");
        }
    }

    private String generateSecurePassword() {
        // Generate a secure random password for Google users
        return UUID.randomUUID().toString();
    }

    private String escapeJsonString(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private boolean isValidPassword(String password) {
        // Check if password is null or less than 8 characters
        if (password == null || password.length() < 8) {
            return false;
        }

        // Check if password contains at least one number
        boolean hasNumber = false;
        for (char c : password.toCharArray()) {
            if (Character.isDigit(c)) {
                hasNumber = true;
                break;
            }
        }

        return hasNumber;
    }

    private void handleRegistration(HttpServletRequest request, HttpServletResponse response) throws IOException {
        System.out.println("\nDEBUG: Starting registration process");

        try {
            // Log raw request parameters for debugging
            System.out.println("DEBUG: Raw request parameters:");
            Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                System.out.println(paramName + ": " + request.getParameter(paramName));
            }

            // Get and validate all parameters first
            Map<String, String> params = new HashMap<>();
            params.put("firstName", request.getParameter("firstName"));
            params.put("lastName", request.getParameter("lastName"));
            params.put("email", request.getParameter("email"));
            params.put("password", request.getParameter("password"));
            params.put("city", request.getParameter("city"));
            params.put("district", request.getParameter("district"));
            params.put("address", request.getParameter("address"));
            params.put("heightCm", request.getParameter("heightCm"));
            params.put("weightKg", request.getParameter("weightKg"));

            // Log all received parameters
            System.out.println("DEBUG: Received parameters:");
            for (Map.Entry<String, String> entry : params.entrySet()) {
                System.out.println(entry.getKey() + ": " + entry.getValue());
            }

            // Check for missing parameters
            List<String> missingParams = new ArrayList<>();
            for (Map.Entry<String, String> entry : params.entrySet()) {
                if (entry.getValue() == null || entry.getValue().trim().isEmpty()) {
                    missingParams.add(entry.getKey());
                }
            }

            if (!missingParams.isEmpty()) {
                String errorMsg = "Missing required fields: " + String.join(", ", missingParams);
                System.out.println("DEBUG: " + errorMsg);
                request.getSession().setAttribute("errorMessage", errorMsg);
                response.sendRedirect("login.jsp?action=signup");
                return;
            }

            // Validate password
            if (!isValidPassword(params.get("password"))) {
                request.getSession().setAttribute("errorMessage",
                        "Password must be at least 8 characters long and contain at least one number");
                response.sendRedirect("login.jsp?action=signup");
                return;
            }

            // Parse numeric values
            float heightCm;
            float weightKg;
            try {
                heightCm = Float.parseFloat(params.get("heightCm"));
                weightKg = Float.parseFloat(params.get("weightKg"));

                // Validate reasonable ranges
                if (heightCm < 1 || heightCm > 300) {
                    throw new NumberFormatException("Height must be between 1 and 300 cm");
                }
                if (weightKg < 1 || weightKg > 500) {
                    throw new NumberFormatException("Weight must be between 1 and 500 kg");
                }
            } catch (NumberFormatException e) {
                String errorMsg = "Invalid measurements: " + e.getMessage();
                System.out.println("DEBUG: " + errorMsg);
                request.getSession().setAttribute("errorMessage", errorMsg);
                response.sendRedirect("login.jsp?action=signup");
                return;
            }

            // Calculate BMI category based on the formula
            float bmi = weightKg / ((heightCm / 100) * (heightCm / 100));
            String bmiCategory = calculateBMICategory(bmi);
            System.out.println("DEBUG: Calculated BMI: " + bmi + ", Category: " + bmiCategory);

            // Create user object
            User newUser = new User();
            newUser.setFullName(params.get("firstName") + " " + params.get("lastName"));
            newUser.setEmail(params.get("email"));
            newUser.setPasswordHash(params.get("password"));
            newUser.setCity(params.get("city"));
            newUser.setDistrict(params.get("district"));
            newUser.setAddress(params.get("address"));
            newUser.setHeightCm(heightCm);
            newUser.setWeightKg(weightKg);
            newUser.setBmiCategory(bmiCategory);

            UserDAO userDAO = new UserDAO();

            // Check if email exists
            if (userDAO.checkEmailExists(params.get("email"))) {
                System.out.println("DEBUG: Email already exists - " + params.get("email"));
                request.getSession().setAttribute("errorMessage", "Email already exists");
                response.sendRedirect("login.jsp?action=signup");
                return;
            }

            // Attempt registration
            System.out.println("DEBUG: Attempting to register user");
            if (userDAO.registerUser(newUser)) {
                System.out.println("DEBUG: Registration successful for email: " + params.get("email"));
                request.getSession().setAttribute("successMessage", "Registration successful! Please login.");
                response.sendRedirect("login.jsp");
            } else {
                System.out.println("DEBUG: Registration failed for email: " + params.get("email"));
                request.getSession().setAttribute("errorMessage", "Failed to create user account. Please try again.");
                response.sendRedirect("login.jsp?action=signup");
            }
        } catch (Exception e) {
            System.out.println("DEBUG: Unexpected error in registration:");
            e.printStackTrace();
            String errorMsg = e.getMessage();
            if (errorMsg == null || errorMsg.trim().isEmpty()) {
                errorMsg = e.toString();
            }
            request.getSession().setAttribute("errorMessage", "Server error: " + errorMsg);
            response.sendRedirect("login.jsp?action=signup");
        }
    }

    private String calculateBMICategory(float bmi) {
        if (bmi < 18.5) {
            return "Underweight";
        }
        if (bmi < 25) {
            return "Normal";
        }
        if (bmi < 30) {
            return "Overweight";
        }
        return "Obese";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Login Servlet handles user authentication and registration";
    }
}
