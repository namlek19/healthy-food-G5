/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.MenuDAO;
import model.Menu;
import java.util.*;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class MenuCusServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet MenuCusServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MenuCusServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bmi = request.getParameter("bmi");
        String categoryName;
        if (bmi == null || bmi.isEmpty()) {
            categoryName = "Tất cả thực đơn";
        } else {
            switch (bmi) {
                case "Underweight":
                    categoryName = "Gầy (Underweight)";
                    break;
                case "Normal":
                    categoryName = "Bình thường (Normal)";
                    break;
                case "Overweight":
                    categoryName = "Thừa cân (Overweight)";
                    break;
                case "Obese":
                    categoryName = "Béo phì (Obese)";
                    break;
                default:
                    categoryName = "Tất cả thực đơn";
            }
        }

        MenuDAO dao = new MenuDAO();
        List<Menu> menuList;
        if (bmi == null || bmi.isEmpty()) {
            menuList = new ArrayList<>();
            menuList.addAll(dao.getMenusByBMICategory("Underweight"));
            menuList.addAll(dao.getMenusByBMICategory("Normal"));
            menuList.addAll(dao.getMenusByBMICategory("Overweight"));
            menuList.addAll(dao.getMenusByBMICategory("Obese"));
        } else {
            menuList = dao.getMenusByBMICategory(bmi);
        }
        request.setAttribute("menuList", menuList);
        request.setAttribute("categoryName", categoryName);
        request.getRequestDispatcher("MenuCus.jsp").forward(request, response);
    }
}
