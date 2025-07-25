package controller;

import dal.UserDAO;
import dal.CartDAO;
import model.User;
import model.CartItem;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.URI;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final String GOOGLE_CLIENT_ID = "423890706733-eo05uhbjo9aup4pkpq714evrohqjqcq1.apps.googleusercontent.com";
    private static final String GOOGLE_TOKEN_VERIFICATION_URL = "https://oauth2.googleapis.com/tokeninfo?id_token=";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        System.out.println("DEBUG: Received action: " + action);

        try {
            if (action == null) {
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

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Email and password are required");
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.checkLogin(email, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userID", user.getUserID());
                session.setAttribute("roleID", user.getRoleID());

                CartDAO cartDAO = new CartDAO();

                if (!cartDAO.hasCart(user.getUserID())) {
                    cartDAO.createCartForUser(user.getUserID());
                }
              

                List<CartItem> dbCart = cartDAO.getCartItemsByUser(user.getUserID());
                session.setAttribute("cart", dbCart);

                if (user.getRoleID() == 5) {
                    // Nutritionist: chuyển thẳng vào trang blog list
                    response.sendRedirect(request.getContextPath() + "/blogmanage");
                } else if (user.getRoleID() == 3) {
                    // Manager: chuyển vào trang quản lý menu chờ duyệt
                    response.sendRedirect(request.getContextPath() + "/pending-menu.jsp");
                    
                }else if (user.getRoleID() == 6) {
                   
                    response.sendRedirect(request.getContextPath() + "/ShipperOrderServlet");
                }else if (user.getRoleID() == 4) {
                   
                    response.sendRedirect(request.getContextPath() + "/manageProductSeller");
                    
                }else if (user.getRoleID() == 1) {
                   
                    response.sendRedirect(request.getContextPath() + "/manageUsers");
                    
                }
                else {
                    // Các role khác vào homepage như thường
                    response.sendRedirect("index");
                }

            } else {
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
            String idToken = request.getParameter("credential");
            if (idToken == null || idToken.trim().isEmpty()) {
                throw new Exception("Missing Google ID token");
            }
            // Verify the ID token with Google and parse user info
            JsonObject tokenInfo = verifyGoogleToken(idToken);
            if (tokenInfo == null) {
                throw new Exception("Invalid Google Sign-In token");
            }
            String email = tokenInfo.get("email").getAsString();
            String fullName = tokenInfo.has("name") ? tokenInfo.get("name").getAsString() : "";

            UserDAO userDAO = new UserDAO();
            User user = userDAO.findUserByEmail(email);
            if (user == null) {
                // Create new user for first-time Google login
                user = new User();
                user.setEmail(email);
                user.setFullName(fullName);
                user.setCity("Not Provided");
                user.setDistrict("Not Provided");
                user.setAddress("Not Provided");
                String securePassword = generateSecurePassword();
                user.setPasswordHash(securePassword);
                if (!userDAO.registerUser(user)) {
                    throw new Exception("Failed to create user account");
                }
                // Sau khi tạo user mới từ Google, cần lấy lại user vừa tạo (có ID)
                user = userDAO.findUserByEmail(email);
            }
            // ==== ĐOẠN ĐỒNG BỘ GIỎ HÀNG CHO USER GOOGLE ====
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("isGoogleUser", true);

            CartDAO cartDAO = new CartDAO();
            if (!cartDAO.hasCart(user.getUserID())) {
                cartDAO.createCartForUser(user.getUserID());
            }
            
            
            List<CartItem> dbCart = cartDAO.getCartItemsByUser(user.getUserID());
            session.setAttribute("cart", dbCart);
            // ==== KẾT THÚC ĐOẠN ĐỒNG BỘ GIỎ HÀNG ====

            out.write("{\"success\": true}");
        } catch (Exception e) {
            System.out.println("DEBUG: Error in Google login: " + e.getMessage());
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"success\": false, \"message\": \"" + escapeJsonString(e.getMessage()) + "\"}");
        }
    }

    // Helper to verify token and return parsed JSON with user info
    private JsonObject verifyGoogleToken(String idToken) {
        try {
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(GOOGLE_TOKEN_VERIFICATION_URL + idToken))
                    .GET()
                    .build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() == 200) {
                JsonObject jsonResponse = JsonParser.parseString(response.body()).getAsJsonObject();
                String aud = jsonResponse.get("aud").getAsString();
                if (!GOOGLE_CLIENT_ID.equals(aud)) {
                    System.out.println("DEBUG: Token audience mismatch. Expected: " + GOOGLE_CLIENT_ID + ", Got: " + aud);
                    return null;
                }
                long exp = jsonResponse.get("exp").getAsLong();
                if (exp < System.currentTimeMillis() / 1000) {
                    System.out.println("DEBUG: Token has expired");
                    return null;
                }
                return jsonResponse;
            }
            System.out.println("DEBUG: Token verification failed with status: " + response.statusCode());
            return null;
        } catch (Exception e) {
            System.out.println("DEBUG: Error verifying Google token: " + e.getMessage());
            e.printStackTrace();
            return null;
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
        if (password == null || password.length() < 8) {
            return false;
        }
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
            System.out.println("DEBUG: Raw request parameters:");
            Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                System.out.println(paramName + ": " + request.getParameter(paramName));
            }
            Map<String, String> params = new HashMap<>();
            params.put("firstName", request.getParameter("firstName"));
            params.put("lastName", request.getParameter("lastName"));
            params.put("email", request.getParameter("email"));
            params.put("password", request.getParameter("password"));
            params.put("city", request.getParameter("city"));
            params.put("district", request.getParameter("district"));
            params.put("address", request.getParameter("address"));

            System.out.println("DEBUG: Received parameters:");
            for (Map.Entry<String, String> entry : params.entrySet()) {
                System.out.println(entry.getKey() + ": " + entry.getValue());
            }

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

            if (!isValidPassword(params.get("password"))) {
                request.getSession().setAttribute("errorMessage",
                        "Password must be at least 8 characters long and contain at least one number");
                response.sendRedirect("login.jsp?action=signup");
                return;
            }

            User user = new User();
            user.setEmail(params.get("email"));
            user.setPasswordHash(params.get("password")); // In production, this should be hashed
            user.setFullName(params.get("firstName") + " " + params.get("lastName"));
            user.setCity(params.get("city"));
            user.setDistrict(params.get("district"));
            user.setAddress(params.get("address"));

            UserDAO userDAO = new UserDAO();

            if (userDAO.checkEmailExists(params.get("email"))) {
                System.out.println("DEBUG: Email already exists - " + params.get("email"));
                request.getSession().setAttribute("errorMessage", "Email already exists");
                response.sendRedirect("login.jsp?action=signup");
                return;
            }

            System.out.println("DEBUG: Attempting to register user");
            if (userDAO.registerUser(user)) {
                System.out.println("DEBUG: Registration successful for email: " + params.get("email"));
                request.getSession().setAttribute("successMessage", "Registration successful! Please login.");
                response.sendRedirect("login.jsp");
                // Clear signup data from session
                request.getSession().removeAttribute("signupData");
            } else {
                System.out.println("DEBUG: Registration failed for email: " + params.get("email"));
                request.setAttribute("error", "Failed to create account. Please check your details.");
                request.getSession().setAttribute("signupData", params);
                request.getRequestDispatcher("login.jsp").forward(request, response);
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
