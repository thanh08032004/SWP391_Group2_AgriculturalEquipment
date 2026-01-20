/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import model.User;

/**
 *
 * @author LOQ
 */
public class LoginServlet extends HttpServlet {

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
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
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

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("remember_username".equals(c.getName())) {
                    request.setAttribute("username", c.getValue());
                }
            }
        }

        request.getRequestDispatcher("/views/login.jsp").forward(request, response);

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

    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String remember = request.getParameter("rememberMe");

    UserDAO userDAO = new UserDAO();
    User user = userDAO.login(username, password);

    // 1. Kiểm tra đăng nhập thất bại
    if (user == null) {
        request.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
        request.setAttribute("username", username);
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        return;
    }

    // 2. Đăng nhập thành công -> Lưu Session
    HttpSession session = request.getSession();
    session.setAttribute("user", user);

    // === Gán userRole vào session để Header.jsp có thể nhận diện ===
    if (user.getRoleId() == 1) session.setAttribute("userRole", "ADMIN_SYSTEM");
    else if (user.getRoleId() == 2) session.setAttribute("userRole", "ADMIN_BUSINESS");
    else if (user.getRoleId() == 3) session.setAttribute("userRole", "STAFF");
    else if (user.getRoleId() == 4) session.setAttribute("userRole", "CUSTOMER");

    // 3. Xử lý Remember Me (Cookie)
    if (remember != null) {
        Cookie c = new Cookie("remember_username", username);
        c.setMaxAge(7 * 24 * 60 * 60);
        c.setPath(request.getContextPath());
        response.addCookie(c);
    } else {
        Cookie c = new Cookie("remember_username", "");
        c.setMaxAge(0);
        c.setPath(request.getContextPath());
        response.addCookie(c);
    }

    // 4. Phân quyền chuyển hướng (Switch Case)
    String contextPath = request.getContextPath();
    switch (user.getRoleId()) {
        case 1: // ADMIN_SYSTEM
            response.sendRedirect(contextPath + "/adminsystemdashboard");
            break;
        case 2: // ADMIN_BUSINESS
            response.sendRedirect(contextPath + "/adminbusinessdashboard");
            break;
        case 3: // TECHNICIAN (STAFF)
            response.sendRedirect(contextPath + "/staff/tasks");
            break;
        case 4: // CUSTOMER
            response.sendRedirect(contextPath + "/home");
            break;
        default:
            session.invalidate();
            response.sendRedirect(contextPath + "/login");
    }
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
