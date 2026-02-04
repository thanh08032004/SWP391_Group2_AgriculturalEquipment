package controller.adminBusiness;

import dal.MaintenanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AdminMaintenanceServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("reqList", new MaintenanceDAO().getAllMaintenanceRequests());
        request.getRequestDispatcher("/views/AdminBusinessView/maintenance-list.jsp").forward(request, response);
    }
}