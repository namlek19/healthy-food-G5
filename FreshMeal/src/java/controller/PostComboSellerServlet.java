package controller;

import dal.MenuDAO;
import dal.UserDAO;
import model.Menu;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

public class PostComboSellerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        MenuDAO menuDAO = new MenuDAO();
        UserDAO userDAO = new UserDAO();

        
        List<Menu> comboList = menuDAO.getMenusByStatus(2);

        
        Map<Integer, String> uploaderMap = new HashMap<>();
        for (Menu m : comboList) {
            int nutriId = m.getNutritionistID();
            User u = userDAO.getUserByID(nutriId);
            if (u != null) {
                uploaderMap.put(m.getMenuID(), u.getFullName());
            } else {
                uploaderMap.put(m.getMenuID(), "Không rõ");
            }
        }

        request.setAttribute("comboList", comboList);
        request.setAttribute("uploaderMap", uploaderMap);
        request.getRequestDispatcher("postComboSeller.jsp").forward(request, response);
    }
}