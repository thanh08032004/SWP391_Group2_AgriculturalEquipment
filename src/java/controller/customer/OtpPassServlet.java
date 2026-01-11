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
import java.util.Random;
import model.PasswordReset;
import utils.EmailUtils;

/**
 *
 * @author Acer
 */
public class OtpPassServlet extends HttpServlet {

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
            out.println("<title>Servlet OtpPassServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OtpPassServlet at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("views/input-otp.jsp").forward(request, response);
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
//        String inputOtp = request.getParameter("otp");
//        HttpSession session = request.getSession();
//
//        Integer userId = (Integer) session.getAttribute("resetUserId");
//        String email = (String) session.getAttribute("resetEmail");
//
//        if (userId == null && email == null) {
//            response.sendRedirect("forgot-password");
//            return;
//        }
//
//        PasswordResetDAO resetDAO = new PasswordResetDAO();
//        PasswordReset reset = resetDAO.findValidOtp(userId, inputOtp);
//
//        // OTP sai, hết hạn, đã dùng
//        if (reset == null) {
//            request.setAttribute("error", "Mã xác thực không hợp lệ hoặc đã hết hạn");
//            request.getRequestDispatcher("views/input-otp.jsp").forward(request, response);
//            return;
//        }
//
//        // OTP đúng
//        String newPassword = generateRandomPassword(8);
//        UserDAO userDAO = new UserDAO();
//        userDAO.updatePassword(userId, newPassword);
//
//        // Gửi email
//        String subject = "Mật khẩu mới của bạn";
//        String message = "Mật khẩu mới của bạn là: " + newPassword
//                + "\n\nVui lòng đăng nhập và đổi mật khẩu ngay sau khi đăng nhập.";
//        boolean sent = EmailUtils.sendEmail(email, subject, message);
//        if (sent) {
//            response.sendRedirect("views/send-success.jsp");
//        } else {
//            request.setAttribute("error", "Không thể gửi email. Vui lòng thử lại sau!");
//            request.getRequestDispatcher("views/input-otp.jsp").forward(request, response);
//        }

    }

    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        Random rand = new Random();

        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(rand.nextInt(chars.length())));
        }
        return sb.toString();
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
