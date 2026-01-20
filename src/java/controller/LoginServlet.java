/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
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
//                if ("remember_password".equals(c.getName())){
//                    request.setAttribute("password", c.getValue());
//                }
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
        String remember = request.getParameter("rememberMe"); // on | null

        UserDAO userDAO = new UserDAO();
        User user = userDAO.login(username, password);

        // Login fail
        if (user == null) {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
            request.setAttribute("username", username);            
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        //Remember me (7 days)
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Set remember me
            if (remember != null) {
                Cookie c1 = new Cookie("remember_username", username);
                c1.setMaxAge(7 * 24 * 60 * 60); // 7 ngày                
                c1.setPath(request.getContextPath());
                response.addCookie(c1);
                //Cookie c2 = new Cookie("remember_password", password);
                //c2.setMaxAge(7 * 24 * 60 * 60); // 7 ngày
                //c2.setPath(request.getContextPath());                
                //response.addCookie(c2);
            } else {
                // user không chọn remember → xóa cookie (nếu có)
                Cookie c1 = new Cookie("remember_username", "");
                c1.setMaxAge(0);
                c1.setPath(request.getContextPath());
                response.addCookie(c1);
                //Cookie c2 = new Cookie("remember_password", "");
                //c2.setMaxAge(0);              
                //c2.setPath(request.getContextPath());                
                //response.addCookie(c2);
            }
        }

        // Lưu session
        HttpSession session = request.getSession();        
        session.setAttribute("user", user);

        String contextPath = request.getContextPath();

        switch (user.getRoleId()) {

            case 1: // ADMIN_SYSTEM
                response.sendRedirect(contextPath + "/adminsystemdashboard");
                break;

            case 2: // ADMIN_BUSINESS
                response.sendRedirect(contextPath + "/adminbusinessdashboard");

                break;

            case 3: // TECHNICIAN
                response.sendRedirect(contextPath + "/technicanhome");
                break;

            case 4: // CUSTOMER
//            session.setAttribute("userRole", "CUSTOMER");
                response.sendRedirect(contextPath + "/home");
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
