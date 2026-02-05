package controller.adminBusiness;

import dal.MaintenanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Maintenance;

public class AdminMaintenanceServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("customerName"); // Field (2)
        String status = request.getParameter("status"); // Field (3)

        List<Maintenance> list = new MaintenanceDAO().searchMaintenanceRequests(name, status);
        request.setAttribute("reqList", list);
        request.setAttribute("currentName", name);
        request.setAttribute("currentStatus", status);
        request.getRequestDispatcher("/views/AdminBusinessView/maintenance-list.jsp").forward(request, response);
    }
}