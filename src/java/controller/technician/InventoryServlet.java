package controller.technician;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class InventoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        if (request.getSession().getAttribute("userRole") == null || 
            !request.getSession().getAttribute("userRole").equals("STAFF")) {
            response.sendError(403);
            return;
        }

        // List<Part> list = partDAO.getAll();
        // request.setAttribute("partsList", list);

        request.getRequestDispatcher("/views/StaffView/inventory.jsp").forward(request, response);
    }
}