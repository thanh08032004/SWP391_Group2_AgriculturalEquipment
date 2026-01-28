/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dal.UserProfileDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author Thong
 */
public class ChangePasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Không cho truy cập GET - block         
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1. Chưa login
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        UserProfileDAO userDAO = new UserProfileDAO();

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate độ dài password
        if (newPassword == null || newPassword.length() < 3 || newPassword.length() > 30) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/profile?tab=security&errorPass=length"
            );
            return;
        }

        // 2. Validate tất cả trước
        boolean confirmWrong = !newPassword.equals(confirmPassword);
        boolean currentWrong = !userDAO.checkPassword(user.getId(), currentPassword);

        // 3. Xử lý lỗi (redirect 1 lần)
        if (confirmWrong || currentWrong) {
            String errorPass;

            // Ưu tiên current password (bảo mật)
            if (currentWrong) {
                errorPass = "wrongpass";
            } else {
                errorPass = "confirm";
            }

            response.sendRedirect(
                    request.getContextPath() + "/profile?tab=security&errorPass=" + errorPass
            );
            return;
        }

        // 4. Update mật khẩu mới
        userDAO.updatePassword(user.getId(), newPassword);

        // 5. Thành công, quay về profile
        response.sendRedirect(
                request.getContextPath() + "/profile?tab=security&success=passUpdated"
        );
    }
}
