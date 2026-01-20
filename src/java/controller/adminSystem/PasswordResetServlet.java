/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.adminSystem;

import dal.PasswordResetDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import org.mindrot.jbcrypt.BCrypt;
import utils.EmailUtils;
import utils.PasswordUtil;

/**
 *
 * @author Acer
 */
public class PasswordResetServlet extends HttpServlet {

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
            out.println("<title>Servlet PasswordResetServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PasswordResetServlet at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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

        int userId = Integer.parseInt(request.getParameter("userId"));
        String email = request.getParameter("email");

        try {
            // 1. Random password
            String newPass = PasswordUtil.randomPassword(6);

            // 2. Hash
            String hashed = BCrypt.hashpw(newPass, BCrypt.gensalt(10));

            // 3. Update DB
            UserDAO dao = new UserDAO();
            dao.updatePassword(userId, hashed);
            
            User user = dao.findById(userId);

            // 4. Send mail
            String subject = "Mật khẩu của bạn";
            String message = "Xin chào " + user.getUsername() + ",\n\nMật khẩu của bạn là: " + newPass
                    + "\n\nVui lòng nhập mật khẩu của bạn để đăng nhập!";
            boolean sent = EmailUtils.sendEmail(email, subject, message);

            // 5. Update request status
            if(sent) {
                PasswordResetDAO passwordResetDAO = new PasswordResetDAO();
                passwordResetDAO.updateResetRequestStatus(userId, "APPROVED");
                response.sendRedirect("home");
            } else {
                request.setAttribute("error", "Lỗi gửi email!");
            }

        } catch (Exception e) {
            System.err.println("Error password reset for admin !");
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
