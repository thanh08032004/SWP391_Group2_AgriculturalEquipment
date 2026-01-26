/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import dal.PasswordResetDAO;
import dal.RoleDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.UUID;
import model.Role;
import model.User;
import org.mindrot.jbcrypt.BCrypt;
import utils.EmailUtils;
import utils.PasswordUtil;

/**
 *
 * @author Acer
 */
public class ForgotPasswordServlet extends HttpServlet {

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
            out.println("<title>Servlet ForgotPasswordServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ForgotPasswordServlet at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("views/forgot-password.jsp").forward(request, response);
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

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Please enter your email address.");
            request.getRequestDispatcher("views/forgot-password.jsp")
                    .forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.findByEmail(email);

        if (user == null) {
            // email not exist
            request.setAttribute("error", "The email address does not exist in the system.");
            request.getRequestDispatcher("views/forgot-password.jsp")
                    .forward(request, response);
        } else {
            RoleDAO roleDAO = new RoleDAO();
            Role role = roleDAO.getRoleByUserEmail(email);
            if (!role.getName().equals("ADMIN_SYSTEM")) {
                PasswordResetDAO passwordResetDAO = new PasswordResetDAO();
                passwordResetDAO.savePasswordResetRequest(user.getId(), email);
            } else {
                // 1. Random password
                String newPass = PasswordUtil.randomPassword(8);

                // 2. Hash
                String hashed = BCrypt.hashpw(newPass, BCrypt.gensalt(10));

                // 3. Update DB
                UserDAO dao = new UserDAO();
                dao.updatePassword(user.getId(), hashed);

                // 4. Send mail
                String subject = "Your Password";
                String message = "Hello " + user.getUsername() + ",\n\n"
                        + "Your password is: " + newPass
                        + "\n\nPlease use this password to log in.";
                boolean sent = EmailUtils.sendEmail(email, subject, message);

                // 5. Update request status
                if (sent) {
                    PasswordResetDAO passwordResetDAO = new PasswordResetDAO();
                    passwordResetDAO.updateResetRequestStatus(user.getId(), "APPROVED");
                }
            }

            response.sendRedirect("send-success");
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
