package controller.technican;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ServiceLogServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null || !"STAFF".equals(session.getAttribute("userRole"))) {
            response.sendError(403);
            return;
        }

        // List<ServiceLog> logs = logDAO.getLogsByStaff(staffId);
        // request.setAttribute("logs", logs);

        request.getRequestDispatcher("/staff/service-logs.jsp").forward(request, response);
    }
}