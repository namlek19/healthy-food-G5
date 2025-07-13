package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class BMISerlvet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet BMISerlvet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BMISerlvet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        double height = Double.parseDouble(request.getParameter("height"));
        double weight = Double.parseDouble(request.getParameter("weight"));

        if (height < 80 || height > 250 || weight < 20 || weight > 300) {
            request.setAttribute("error", "Giá trị không hợp lệ. Vui lòng nhập chiều cao từ 80–250 cm và cân nặng từ 20–300 kg.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
            return;
        }
        height = height / 100;

        double bmi = weight / (height * height);
        String bmiType;

        if (bmi < 18.5) {
            bmiType = "Underweight";
        } else if (bmi < 24.9) {
            bmiType = "Normal";
        } else if (bmi < 29.9) {
            bmiType = "Overweight";
        } else {
            bmiType = "Obese";
        }

        HttpSession session = request.getSession();
        session.setAttribute("bmiValue", String.format("%.2f", bmi));
        session.setAttribute("bmiType", bmiType);

        response.sendRedirect("index");
    }

}
