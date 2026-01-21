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
import java.util.List;
import model.PasswordResetRequest;
import model.User;
import org.mindrot.jbcrypt.BCrypt;
import utils.EmailUtils;
import utils.PasswordUtil;

/**
 *
 * @author Acer
 */
public class AdminPasswordResetServlet extends HttpServlet {

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
        PasswordResetDAO dao = new PasswordResetDAO();
        List<PasswordResetRequest> listRequest = dao.getAllPasswordResetRequests();
        request.setAttribute("listRequest", listRequest);
        for (PasswordResetRequest p : listRequest) {
            System.out.println(p);
        }
        request.getRequestDispatcher("/AdminSystemView/password-reset.jsp").forward(request, response);
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

        String action = request.getParameter("action");
        int userId = Integer.parseInt(request.getParameter("userId"));

        PasswordResetDAO resetDAO = new PasswordResetDAO();
        String email = request.getParameter("email");

        try {
            if ("approve".equals(action)) {

                // 1. Random password
                String rawPassword = PasswordUtil.randomPassword(6);

                // 2. Hash
                String hashed = BCrypt.hashpw(rawPassword, BCrypt.gensalt(10));

                // 3. Update user password
                UserDAO userDAO = new UserDAO();
                userDAO.updatePassword(userId, hashed);

                User user = userDAO.findById(userId);

                // 4. Send email APPROVE
                String subject = "Reset mật khẩu thành công";
                String message = "Xin chào " + user.getUsername()
                        + ",\n\nMật khẩu mới của bạn là: " + rawPassword
                        + "\n\nĐăng nhập để xem thông tin của bạn."
                        + "Hotline: +84 123 456 789\n"
                        + "Email hỗ trợ: support@agricms.com\n\n"
                        + "Trân trọng.";

                boolean sentSuccess = EmailUtils.sendEmail(email, subject, message);

                if (sentSuccess) {
                    resetDAO.updateResetRequestStatus(userId, "APPROVED");
                }

            } else if ("reject".equals(action)) {

                // Send email reason
                String subject = "Yêu cầu reset mật khẩu bị từ chối";
                String message
                        = "Chào bạn,\n\n"
                        + "Yêu cầu reset mật khẩu của bạn đã bị từ chối.\n"
                        + "Vui lòng liên hệ quản trị viên nếu bạn cần hỗ trợ thêm.\n\n"
                        + "Hotline: +84 123 456 789\n"
                        + "Email hỗ trợ: support@agricms.com\n\n"
                        + "Trân trọng.";

                boolean sentError = EmailUtils.sendEmail(email, subject, message);

                if (sentError) {
                    resetDAO.updateResetRequestStatus(userId, "REJECTED");
                }

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // return to list
        response.sendRedirect(request.getContextPath() + "/admin/password-reset");
    }

}
