package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

@WebFilter(urlPatterns = {"/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        // Allow static resources
        if (uri.contains("/assets/") || uri.contains("/common/")
                || uri.endsWith(".css") || uri.endsWith(".js")) {
            chain.doFilter(request, response);
            return;
        }

        // Allow public pages
        if (uri.endsWith("/home") || uri.endsWith("/login")) {
            chain.doFilter(request, response);
            return;
        }

        // Block direct JSP acces
        if (uri.endsWith(".jsp")) {
            res.sendRedirect(contextPath + "/home");
            return;
        }

        // Check user login
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            if (uri.contains("/admin") || uri.contains("/technician")
                    || uri.contains("/customer") || uri.contains("/admin-business")) {
                res.sendRedirect(contextPath + "/login");
                return;
            }
        } else {
            int role = user.getRoleId();

            if (uri.contains("/admin/") && !uri.contains("/admin-business/") && role != 1) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN); return;
            }
            if (uri.contains("/admin-business/") && role != 2) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN); return;
            }
            if (uri.contains("/technician/") && role != 3) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN); return;
            }
            if (uri.contains("/customer/") && role != 4) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN); return;
            }
        }

        chain.doFilter(request, response);
    }
}
