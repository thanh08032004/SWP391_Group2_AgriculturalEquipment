/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.UserProfileDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.UserProfile;

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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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

        // 4. Kiểm tra edit mode
        boolean edit = "true".equals(request.getParameter("edit"));
        request.setAttribute("edit", edit);

        // 5.1. Phân trang (profile với security)
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "profile";
        }

        request.setAttribute("tab", tab);

        // 6. Đẩy sang JSP
        request.setAttribute("profile", profile);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/views/userProfile.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");

        // 1. Lấy data từ form
        String fullname = request.getParameter("fullname");
        String gender = request.getParameter("gender");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String birthDate = request.getParameter("birthDate");
        String address = request.getParameter("address");

        // 2. Update DB
        UserProfileDAO dao = new UserProfileDAO();
        dao.updateProfile(
                user.getId(),
                fullname,
                gender,
                email,
                phone,
                birthDate,
                address
        );

        // 3. Redirect để tránh submit lại form
        response.sendRedirect(request.getContextPath() + "/profile");
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
