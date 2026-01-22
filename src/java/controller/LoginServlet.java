package controller;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("remember_username".equals(c.getName())) {
                    request.setAttribute("username", c.getValue());
                }
            }
        }
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("rememberMe");

        UserDAO dao = new UserDAO();
        User user = dao.findByUsername(username);

        // ❌ Sai username hoặc sai password
        if (user == null || !BCrypt.checkpw(password, user.getPassword())) {
            request.setAttribute("error", "Sai tài khoản hoặc mật khẩu");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        // ✅ Login thành công
        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        // Save role
        switch (user.getRoleId()) {
            case 1 -> session.setAttribute("userRole", "ADMIN_SYSTEM");
            case 2 -> session.setAttribute("userRole", "ADMIN_BUSINESS");
            case 3 -> session.setAttribute("userRole", "STAFF");
            case 4 -> session.setAttribute("userRole", "CUSTOMER");
        }

        // Remember me
        if (remember != null) {
            Cookie c = new Cookie("remember_username", username);
            c.setMaxAge(7 * 24 * 60 * 60);
            c.setPath(request.getContextPath());
            response.addCookie(c);
        } else {
            Cookie c = new Cookie("remember_username", "");
            c.setMaxAge(0);
            c.setPath(request.getContextPath());
            response.addCookie(c);
        }

        String ctx = request.getContextPath();
        switch (user.getRoleId()) {
            case 1 -> response.sendRedirect(ctx + "/admin/users?action=list");
            case 2 -> response.sendRedirect(ctx + "/adminbusinessdashboard");
            case 3 -> response.sendRedirect(ctx + "/staff/tasks");
            case 4 -> response.sendRedirect(ctx + "/home");
            default -> {
                session.invalidate();
                response.sendRedirect(ctx + "/login");
            }
        }
    }
}
