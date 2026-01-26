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

        if (uri.contains("/assets/") || uri.endsWith(".css") || uri.endsWith(".js") 
            || uri.equals(contextPath + "/login") 
            || uri.equals(contextPath + "/home")
            || uri.equals(contextPath + "/logout")) {
            chain.doFilter(request, response);
            return;
        }

        if (uri.endsWith(".jsp")) {
            res.sendRedirect(contextPath + "/login");
            return;
        }

        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            if (uri.contains("/admin") || uri.contains("/staff") || uri.contains("/customer")) {
                res.sendRedirect(contextPath + "/login");
                return;
            }
        } else {
            int role = user.getRoleId();
            
            if ((uri.contains("/admin/") || uri.contains("/AdminSystemView/")) && role != 1) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN); 
                return;
            }

            if ((uri.contains("/staff/") || uri.contains("/StaffView/")) && role != 3) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            if ((uri.contains("/customer/") || uri.contains("/CustomerView/")) && role != 4) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
        }

        chain.doFilter(request, response);
    }
}