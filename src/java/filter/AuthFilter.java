package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(urlPatterns = {"/views/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        //  Cho phép các trang KHÔNG cần login
        if (uri.equals(contextPath + "/login")
                || uri.equals(contextPath + "/logout")
                || uri.endsWith("/login.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        chain.doFilter(request, response);
    }
}
