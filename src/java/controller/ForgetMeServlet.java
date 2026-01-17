package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ForgetMeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Xóa cookie remember
        Cookie cookie = new Cookie("remember_username", "");
        cookie.setMaxAge(0);      // xóa ngay
        cookie.setPath(request.getContextPath());
        response.addCookie(cookie);

        // Trả kết quả JSON (cho fetch)
        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"removed\"}");
    }
}
