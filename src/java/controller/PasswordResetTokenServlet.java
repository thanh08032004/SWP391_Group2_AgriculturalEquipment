/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.PasswordResetTokenDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.PasswordResetToken;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author Acer
 */
public class PasswordResetTokenServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet PasswordResetTokenServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PasswordResetTokenServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String token = request.getParameter("token");
        PasswordResetTokenDAO tokenDAO = new PasswordResetTokenDAO();
        PasswordResetToken t = tokenDAO.findValid(token);
        if (t == null) {
            String url = request.getScheme() + "://"
                        + request.getServerName() + ":"
                        + request.getServerPort()
                        + request.getContextPath();
            response.sendRedirect(url + "/errors/404.jsp");
            return;
        }
        request.setAttribute("token", token);
        request.getRequestDispatcher("/views/reset-password.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if(!password.equals(confirmPassword)) {
            request.setAttribute("error", "The new password does not match the confirmation password.");
            request.getRequestDispatcher("/views/reset-password.jsp").forward(request, response);
            return;
        }

        PasswordResetTokenDAO tokenDAO = new PasswordResetTokenDAO();
        PasswordResetToken t = tokenDAO.findValid(token);
        if (t == null) {
            String url = request.getScheme() + "://"
                        + request.getServerName() + ":"
                        + request.getServerPort()
                        + request.getContextPath();
            response.sendRedirect(url + "/errors/404.jsp");
            return;
        }

        String hash = BCrypt.hashpw(password, BCrypt.gensalt(10));
        UserDAO userDAO = new UserDAO();
        userDAO.updatePassword(t.getUserId(), hash);
        tokenDAO.markUsed(token);

        request.setAttribute("popUpSuccessChangePassword", "true");
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
