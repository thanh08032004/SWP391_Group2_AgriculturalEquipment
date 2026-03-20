package filter;

import dal.RoleDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;

import model.User;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String context = req.getContextPath();

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // STATIC
        if (uri.contains("/assets/")
                || uri.contains("/common/")
                || uri.endsWith(".css")
                || uri.endsWith(".js")
                || uri.endsWith(".png")
                || uri.endsWith(".jpg")
                || uri.endsWith(".svg")) {

            chain.doFilter(request, response);
            return;
        }

        if (uri.endsWith("/login")
                || uri.endsWith("/logout")
                || uri.contains("/error") 
                || uri.contains("/forgot-password")
                || uri.endsWith("/home")) {

            chain.doFilter(request, response);
            return;
        }

        if (uri.endsWith(".jsp")) {
            res.sendRedirect(context + "/home");
            return;
        }

        // CHECK LOGIN
        if (user == null) {
            res.sendRedirect(context + "/home");
            return;
        }

        // ===============================
        // LOAD PERMISSION
        // ===============================

        RoleDAO dao = new RoleDAO();
        List<String> permissions = dao.getPermissionCodesByRole(user.getRoleId());

        boolean allowed = false;

        for (String p : permissions) {

            if (uri.startsWith(context + p)) {
                allowed = true;
                break;
            }
        }

        if (!allowed) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        chain.doFilter(request, response);
    }
}