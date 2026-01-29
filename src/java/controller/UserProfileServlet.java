/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.UserProfileDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;
import model.User;
import model.UserProfile;
import utils.UserProfileUtils;

/**
 *
 * @author admin
 */
public class UserProfileServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AccountProfileServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AccountProfileServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // 1. Chưa login
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        // 2. Lấy user từ session
        User user = (User) session.getAttribute("user");

        // 3. Lấy profile từ DB
        UserProfileDAO dao = new UserProfileDAO();
        UserProfile profile = dao.getUserProfileById(user.getId());

        // 4. Tách fullName
        String fullName = profile.getFullname();
        String firstName = "";
        String lastName = "";

        if (fullName != null && !fullName.trim().isEmpty()) {
            String[] parts = fullName.trim().split("\\s+");
            lastName = parts[parts.length - 1];
            firstName = String.join(" ",
                    java.util.Arrays.copyOf(parts, parts.length - 1));
        }

        //4.2 tách date
        if (profile.getBirthDate() != null) {
            LocalDate dob = profile.getBirthDate();
            request.setAttribute("birthDay", String.format("%02d", dob.getDayOfMonth()));
            request.setAttribute("birthMonth", String.format("%02d", dob.getMonthValue()));
            request.setAttribute("birthYear", String.valueOf(dob.getYear()));
        }

        // 5. Kiểm tra edit mode
        boolean edit = "true".equals(request.getParameter("edit"));
        request.setAttribute("edit", edit);

        // 6. Phân trang (profile với security)
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "profile";
        }
        request.setAttribute("tab", tab);

        // 6.1 báo lỗi Wrong Pass
        String errorPass = request.getParameter("errorPass");
        if (errorPass != null) {
            switch (errorPass) {
                case "confirm":
                    request.setAttribute("errorPass", "Confirm password does not match");
                    break;
                case "wrongpass":
                    request.setAttribute("errorPass", "Current password is incorrect");
                    break;
            }
        }
        // 6.2 báo update thành công
        String success = request.getParameter("success");
        if (success != null) {
            switch (success) {
                case "profileUpdated":
                    request.setAttribute("success", "Profile updated successfully");
                    break;
                case "passUpdated":
                    request.setAttribute("success", "Password updated successfully");
                    break;
            }
        }

        // 7. Đẩy sang JSP
        request.setAttribute("profile", profile);
        request.setAttribute("user", user);
        request.setAttribute("firstName", firstName);
        request.setAttribute("lastName", lastName);
        request.setAttribute("tab", tab);
        request.getRequestDispatcher("/views/userProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");

        Map<String, String> errors = new HashMap<>();

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String day = request.getParameter("day");
        String month = request.getParameter("month");
        String year = request.getParameter("year");

        // validate name
        try {
            UserProfileUtils.validateName(firstName, lastName);
        } catch (IllegalArgumentException e) {
            errors.put("name", e.getMessage());
        }

        // validate email
        try {
            UserProfileUtils.validateEmail(email);
        } catch (IllegalArgumentException e) {
            errors.put("email", e.getMessage());
        }

        // validate phone
        try {
            UserProfileUtils.validatePhone(phone);
        } catch (IllegalArgumentException e) {
            errors.put("phone", e.getMessage());
        }

        // validate birth date
        LocalDate birthDate = null;
        try {
            birthDate = UserProfileUtils.validateBirthDate(day, month, year);
        } catch (IllegalArgumentException e) {
            errors.put("birthDate", e.getMessage());
        }

        //  Có lỗi -> quay lại JSP
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("edit", true);

            request.setAttribute("firstName", firstName);
            request.setAttribute("lastName", lastName);
            request.setAttribute("birthDay", day);
            request.setAttribute("birthMonth", month);
            request.setAttribute("birthYear", year);

            UserProfile profile = new UserProfile();
            profile.setEmail(email);
            profile.setPhone(phone);
            profile.setGender(gender);
            profile.setAddress(address);
            request.setAttribute("profile", profile);

            request.getRequestDispatcher("/views/userProfile.jsp")
                    .forward(request, response);
            return;
        }

        //  Không lỗi -> update DB
        String fullname = firstName.trim() + " " + lastName.trim();
        UserProfileDAO dao = new UserProfileDAO();
        dao.updateProfile(user.getId(), fullname, gender, email, phone, birthDate, address);
        response.sendRedirect(
            request.getContextPath() + "/profile?success=profileUpdated"
        );

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
