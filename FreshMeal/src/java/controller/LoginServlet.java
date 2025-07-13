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
import com.google.gson.*;
import jakarta.servlet.http.Cookie;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;


public class LoginServlet extends HttpServlet {
    private static final String GOOGLE_CLIENT_ID = "423890706733-eo05uhbjo9aup4pkpq714evrohqjqcq1.apps.googleusercontent.com";
    private static final String GOOGLE_TOKEN_VERIFICATION_URL = "https://oauth2.googleapis.com/tokeninfo?id_token=";
    private static final String REMEMBER_ME_COOKIE = "rememberMe";
    private static final String REMEMBER_ME_SECRET = "SomeSecretKey123!";
    private static final int REMEMBER_ME_DAYS = 7;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        System.out.println("DEBUG: Received action: " + action);

        // Auto-login with remember me cookie if not already logged in
        HttpSession session = request.getSession();
        if ((session.getAttribute("user") == null || session.getAttribute("userID") == null)
                && (action == null || action.equals("login"))) {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (REMEMBER_ME_COOKIE.equals(cookie.getName())) {
                        String value = cookie.getValue();
                        String[] parts = value.split(":", 2);
                        if (parts.length == 2) {
                            String email = parts[0];
                            String hash = parts[1];
                            if (hash.equals(hashEmail(email))) {
                                UserDAO userDAO = new UserDAO();
                                User user = userDAO.findUserByEmail(email);
                                if (user != null) {
                                    session.setAttribute("user", user);
                                    session.setAttribute("userID", user.getUserID());
                                    session.setAttribute("roleID", user.getRoleID());
                                    // Optionally redirect to homepage if not already there
                                    if (action == null) {
                                        response.sendRedirect("index.jsp");
                                        return;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        try {
            if (action == null) {

                // vao trang dang nhap

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

                case "addUser":
                    handleAddUser(request, response);
                    break;
                case "editUser":
                    handleEditUser(request, response);
                    break;
                case "deleteUser":
                    handleDeleteUser(request, response);
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
        String remember = request.getParameter("remember");


       


        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Email and password are required");
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            UserDAO userDAO = new UserDAO();
            User user = userDAO.checkLogin(email, password);

            if (user != null) {
                if (user.getActive() == 0) {
                    response.sendRedirect("inactive.jsp");
                    return;
                }
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userID", user.getUserID());
                session.setAttribute("roleID", user.getRoleID());

                // ==== ĐOẠN ĐỒNG BỘ GIỎ HÀNG CHO USER ĐĂNG NHẬP ====
                CartDAO cartDAO = new CartDAO();
                // 1. Đảm bảo user có cart trong DB
                if (!cartDAO.hasCart(user.getUserID())) {
                    cartDAO.createCartForUser(user.getUserID());
                }
                // 2. Nếu có guest_cart trong session, chuyển sang DB
                List<CartItem> guestCart = (List<CartItem>) session.getAttribute("guest_cart");
                if (guestCart != null && !guestCart.isEmpty()) {
                    for (CartItem item : guestCart) {
                        cartDAO.addOrUpdateCartItem(user.getUserID(), item.getProduct().getProductID(), item.getQuantity());
                    }
                    session.removeAttribute("guest_cart");
                }
                // 3. Luôn lấy lại cart từ DB cập nhật session (cho cart.jsp luôn chính xác)
                List<CartItem> dbCart = cartDAO.getCartItemsByUser(user.getUserID());
                session.setAttribute("cart", dbCart);
                // ==== KẾT THÚC ĐOẠN ĐỒNG BỘ GIỎ HÀNG ====

                if (user.getRoleID() == 1) {
                    // Admin: redirect to dashboard servlet
                    response.sendRedirect(request.getContextPath() + "/admin-dashboard");
                    return;
                } else if (user.getRoleID() == 5) {
                    // Nutritionist: chuyển thẳng vào trang blog list
                    response.sendRedirect(request.getContextPath() + "/blogmanage");
                } else {
                    // Các role khác vào homepage như thường
                    response.sendRedirect("index.jsp");
                }

                // Handle Remember Me
                if ("on".equals(remember)) {
                    String token = user.getEmail() + ":" + hashEmail(user.getEmail());
                    Cookie cookie = new Cookie(REMEMBER_ME_COOKIE, token);
                    cookie.setMaxAge(REMEMBER_ME_DAYS * 24 * 60 * 60); // 7 days
                    cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                    response.addCookie(cookie);
                } else {
                    // Remove cookie if exists
                    Cookie cookie = new Cookie(REMEMBER_ME_COOKIE, "");
                    cookie.setMaxAge(0);
                    cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
                    response.addCookie(cookie);
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
            // 1. Đảm bảo user có cart trong DB
            if (!cartDAO.hasCart(user.getUserID())) {
                cartDAO.createCartForUser(user.getUserID());
            }
            // 2. Nếu có guest_cart trong session, chuyển sang DB
            List<CartItem> guestCart = (List<CartItem>) session.getAttribute("guest_cart");
            if (guestCart != null && !guestCart.isEmpty()) {
                for (CartItem item : guestCart) {
                    cartDAO.addOrUpdateCartItem(user.getUserID(), item.getProduct().getProductID(), item.getQuantity());
                }
                session.removeAttribute("guest_cart");
            }
            // 3. Luôn lấy lại cart từ DB cập nhật session (cho cart.jsp luôn chính xác)
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

        // check mat khau
        if (password == null || password.length() < 8) {
            return false;
        }
        
        // check dieu kien mk

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

            
            // check tham so input

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


            // tao nguoi dung

            User user = new User();
            user.setEmail(params.get("email"));
            user.setPasswordHash(params.get("password"));
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

    private void handleAddUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        if (admin == null || admin.getRoleID() != 1) {
            response.sendRedirect("login.jsp");
            return;
        }
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String city = request.getParameter("city");
        String district = request.getParameter("district");
        String address = request.getParameter("address");
        int roleID = Integer.parseInt(request.getParameter("roleID"));
        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPasswordHash(password);
        newUser.setCity(city);
        newUser.setDistrict(district);
        newUser.setAddress(address);
        newUser.setRoleID(roleID);
        UserDAO userDAO = new UserDAO();
        userDAO.addUser(newUser);
        List<User> userList = userDAO.getAllUsers();
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("admindasboard.jsp").forward(request, response);
    }

    private void handleEditUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        if (admin == null || admin.getRoleID() != 1) {
            response.sendRedirect("login.jsp");
            return;
        }
        int userID = Integer.parseInt(request.getParameter("userID"));
        int roleID = Integer.parseInt(request.getParameter("roleID"));
        int isActive = 1;
        if (request.getParameter("isActive") != null) {
            try {
                isActive = Integer.parseInt(request.getParameter("isActive"));
            } catch (Exception e) { isActive = 1; }
        }
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getAllUsers().stream().filter(u -> u.getUserID() == userID).findFirst().orElse(null);
        if (user != null) {
            user.setRoleID(roleID);
            user.setActive(isActive);
            userDAO.updateUserByAdmin(user);
        }
        List<User> userList = userDAO.getAllUsers();
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("admindasboard.jsp").forward(request, response);
    }

    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User admin = (User) session.getAttribute("user");
        if (admin == null || admin.getRoleID() != 1) {
            response.sendRedirect("login.jsp");
            return;
        }
        int userID = Integer.parseInt(request.getParameter("userID"));
        UserDAO userDAO = new UserDAO();
        userDAO.deleteUser(userID);
        List<User> userList = userDAO.getAllUsers();
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("admindasboard.jsp").forward(request, response);
    }

    // Hash email with secret for simple token
    private String hashEmail(String email) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            String input = email + REMEMBER_ME_SECRET;
            byte[] hash = md.digest(input.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
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
