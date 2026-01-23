/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import dal.PasswordResetDAO;
import dal.PasswordResetTokenDAO;
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
import utils.EmailUtils;

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
            if(!role.getName().equals("ADMIN_SYSTEM")) {
                PasswordResetDAO passwordResetDAO = new PasswordResetDAO();
                passwordResetDAO.savePasswordResetRequest(user.getId(), email);
            } else {

                // 1. Tạo token reset
                String token = UUID.randomUUID().toString();
                Timestamp expiredAt = new Timestamp(
                        System.currentTimeMillis() + 10 * 60 * 1000 // 10 phút
                );

                // 2. Save token
                PasswordResetTokenDAO resetDAO = new PasswordResetTokenDAO();
                resetDAO.save(user.getId(), token, expiredAt);

                // 3. Link reset
                String link = request.getScheme() + "://"
                        + request.getServerName() + ":"
                        + request.getServerPort()
                        + request.getContextPath()
                        + "/reset-password?token=" + token;

                // 4. Send email
                String subject = "Xác nhận đặt lại mật khẩu";
                String message
                        = "Xin chào " + user.getUsername() + ",\n\n"
                        + "Yêu cầu reset mật khẩu của bạn đã được phê duyệt.\n"
                        + "Vui lòng nhấn vào link dưới đây để đặt lại mật khẩu:\n\n"
                        + link + "\n\n"
                        + "Link có hiệu lực trong 10 phút.\n\n"
                        + "Hotline: +84 123 456 789\n"
                        + "Email hỗ trợ: support@agricms.com\n\n"
                        + "Trân trọng.";

                boolean sentSuccess = EmailUtils.sendEmail(email, subject, message);
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
