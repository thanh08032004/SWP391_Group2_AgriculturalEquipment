/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dal.UserProfileDAO;
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
 * @author admin
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

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // 2. Validate cơ bản
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Confirm password does not match");
            request.setAttribute("error", "Current password is incorrect");
            request.getRequestDispatcher("/profile").forward(request, response);
            return;
        }

        UserProfileDAO userDAO = new UserProfileDAO();

        // 3. Kiểm tra mật khẩu hiện tại      
        if (!userDAO.checkPassword(user.getId(), currentPassword)) {
            request.setAttribute("error", "Current password is incorrect");
            request.getRequestDispatcher("/profile?edit=false").forward(request, response);
            return;
        }

        // 4. Update mật khẩu mới
        userDAO.updatePassword(user.getId(), newPassword);

        // 5. Thành công, quay về profile
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
