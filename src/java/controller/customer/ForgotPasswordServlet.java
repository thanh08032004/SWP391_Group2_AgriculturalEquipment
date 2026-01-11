/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.customer;

import dal.PasswordResetDAO;
import dal.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
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
            request.setAttribute("error", "Vui lòng nhập email");
            request.getRequestDispatcher("views/forgot-password.jsp")
                    .forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();
        User user = userDAO.findByEmail(email);

        if (user == null) {
            // Email không tồn tại
            request.setAttribute("error", "Email không tồn tại trong hệ thống");
            request.getRequestDispatcher("views/forgot-password.jsp")
                    .forward(request, response);
        } else {
            // Sinh OTP 6 số
            String otp = String.valueOf((int)(Math.random() * 900000) + 100000);
            Timestamp expiredAt = new Timestamp(System.currentTimeMillis() + 5 * 60 * 1000); // 5 phút
            
            // Lưu vào session
            HttpSession session = request.getSession();
            session.setAttribute("otp", otp);
            session.setAttribute("resetEmail", email);
            session.setAttribute("resetUserId", user.getId());
            
            PasswordResetDAO resetDAO = new PasswordResetDAO();
            resetDAO.saveOrUpdateOTP(user.getId(), otp, expiredAt);
            
            String subject = "Mã xác thực của bạn";
            String message = "Xin chào " + user.getUsername() + ",\n\nMã xác thực của bạn là: " + otp
                    + "\n\nVui lòng nhập mã xác thực để lấy lại mật khẩu của bạn !";
            boolean sent = EmailUtils.sendEmail(email, subject, message);

            if (sent) {
                response.sendRedirect("otp-pass");
            } else {
                request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại sau!");
                request.getRequestDispatcher("views/forgot-password.jsp").forward(request, response);
            }
            
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
