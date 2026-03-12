package controller.adminBusiness;

import dal.MaintenanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
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
            //labor cost per hour
            double laborRate = 100000.0;
            int id = Integer.parseInt(request.getParameter("id"));
            Maintenance task = dao.getMaintenanceById(id);
            List<Map<String, Object>> items = dao.getMaintenanceItemsWithPrice(id);
            request.setAttribute("task", task);
            request.setAttribute("items", items);
            request.setAttribute("laborRate", laborRate);
            request.getRequestDispatcher("/views/AdminBusinessView/maintenance-detail.jsp").forward(request, response);
        } else {
            //search or list
            String name = request.getParameter("customerName");
            String status = request.getParameter("status");

            int pageSize = 3;
            int pageIndex = 1;
            String rawPage = request.getParameter("page");
            if (rawPage != null && !rawPage.isEmpty()) {
                pageIndex = Integer.parseInt(rawPage);
            }

            int totalRecords = dao.countMaintenanceRequests(name, status);
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
            List<Maintenance> list = dao.searchMaintenanceRequestsPaging(name, status, pageIndex, pageSize);

            request.setAttribute("reqList", list);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", pageIndex);
            request.setAttribute("currentName", name);
            request.setAttribute("currentStatus", status);

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
        //        else if ("approve-diagnosis".equals(action)) {
        //            dao.updateStatus(id, "IN_PROGRESS");
        //            response.sendRedirect("maintenance?action=detail&id=" + id);
        //        } //reject-diagnosis
        else if ("reject-diagnosis".equals(action)) {
            boolean updateStatus = dao.updateStatus(id, "TECHNICIAN_ACCEPTED");
            boolean clearItems = dao.saveMaintenanceItems(id, new ArrayList<>(), new ArrayList<>());
            if (updateStatus && clearItems) {
                response.sendRedirect("maintenance?action=detail&id=" + id + "&msg=rejected_and_cleared");
            } else {
                response.sendRedirect("maintenance?action=detail&id=" + id + "&msg=error");
            }
        } //send task to pool
        else if ("assign".equals(action)) {
            boolean success = dao.updateStatus(id, "WAITING_FOR_TECHNICIAN");
            response.sendRedirect("maintenance?msg=" + (success ? "assign_success" : "assign error"));
        }
    }
}
