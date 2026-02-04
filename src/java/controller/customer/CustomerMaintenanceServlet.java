package controller.customer;

import dal.DeviceDAO;
import dal.MaintenanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class CustomerMaintenanceServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int deviceId = Integer.parseInt(request.getParameter("deviceId"));
        request.setAttribute("device", new DeviceDAO().getDeviceById(deviceId));
        request.getRequestDispatcher("/views/CustomerView/maintenance-request.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int deviceId = Integer.parseInt(request.getParameter("deviceId"));
        String description = request.getParameter("description");
        if (new MaintenanceDAO().createMaintenanceRequest(deviceId, description)) {
            response.sendRedirect(request.getContextPath() + "/customer/devices?msg=success");
        }
    }
}