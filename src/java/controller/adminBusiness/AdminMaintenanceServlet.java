package controller.adminBusiness;

import dal.MaintenanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import model.Maintenance;

public class AdminMaintenanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        MaintenanceDAO dao = new MaintenanceDAO();
        //hien thi 1 chi tiet bao tri
        if ("detail".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Maintenance task = dao.getMaintenanceById(id);
            List<Map<String, Object>> items = dao.getMaintenanceItems(id);
            request.setAttribute("task", task);
            request.setAttribute("items", items);
            request.getRequestDispatcher("/views/AdminBusinessView/maintenance-detail.jsp").forward(request, response);
        } else {
            //list or search
            String name = request.getParameter("customerName");
            String status = request.getParameter("status");
            List<Maintenance> list = dao.searchMaintenanceRequests(name, status);
            request.setAttribute("reqList", list);
            request.getRequestDispatcher("/views/AdminBusinessView/maintenance-list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        MaintenanceDAO dao = new MaintenanceDAO();
        int id = Integer.parseInt(request.getParameter("id"));
        //send-to-customer
        if ("send-to-customer".equals(action)) {
            boolean success = dao.updateStatus(id, "DIAGNOSIS READY");
            response.sendRedirect("maintenance?msg=" + (success ? "sent_success" : "error"));
        } //approve-diagnosis
        else if ("approve-diagnosis".equals(action)) {
            dao.updateStatus(id, "IN_PROGRESS");
            response.sendRedirect("maintenance?action=detail&id=" + id);
        } //send task to pool
        else if ("assign".equals(action)) {
            boolean success = dao.updateStatus(id, "WAITING_FOR_TECHNICIAN");
            response.sendRedirect("maintenance?msg=" + (success ? "assign_success" : "assign error"));
        }
    }
}
