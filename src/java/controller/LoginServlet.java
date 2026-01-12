/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
        request.getRequestDispatcher("views/login.jsp").forward(request, response);
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

    UserDAO userDAO = new UserDAO();
    User user = userDAO.login(username, password);

    // Login fail
    if (user == null) {
        request.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
        request.setAttribute("username", username);
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        return;
    }

    // Lưu session
    HttpSession session = request.getSession();
    session.setAttribute("user", user);

    String contextPath = request.getContextPath();

    switch (user.getRoleId()) {

        case 1: // ADMIN_SYSTEM
            response.sendRedirect(contextPath + "/adminadvanced.jsp");
            break;

        case 2: // ADMIN_BUSINESS
            response.sendRedirect(contextPath + "/adminuser.jsp");
            break;

        case 3: // TECHNICIAN
            response.sendRedirect(contextPath + "/staff.jsp");
            break;

        case 4: // CUSTOMER
             
            session.setAttribute("userRole", "CUSTOMER");
            response.sendRedirect(contextPath  + "/home");
            break;

        default:
            session.invalidate();
            response.sendRedirect(contextPath + "/views/login.jsp");
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
