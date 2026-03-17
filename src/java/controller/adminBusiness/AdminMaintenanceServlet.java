package controller.adminBusiness;

import dal.DeviceDAO;
import dal.FeedbackDAO;
import dal.MaintenanceDAO;
import dal.UserProfileDAO;
import dto.DeviceDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.Maintenance;
import model.MaintenanceFeedback;
import model.UserProfile;

public class AdminMaintenanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
if ("feedback-detail".equals(action)) {
    handleFeedbackDetailPage(request, response);
    return;
}
        MaintenanceDAO dao = new MaintenanceDAO();
        DeviceDAO dDao = new DeviceDAO();
        if ("getDeviceDetail".equals(action)) {
            int devId = Integer.parseInt(request.getParameter("deviceId"));
            DeviceDTO device = dDao.getDeviceById(devId);
            if (device != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String json = String.format(
                        "{\"id\":%d, \"name\":\"%s\", \"model\":\"%s\", \"serial\":\"%s\", \"status\":\"%s\", \"image\":\"%s\", \"customer\":\"%s\", \"customerId\":%d}",
                        device.getId(), device.getMachineName(), device.getModel(),
                        device.getSerialNumber(), device.getStatus(),
                        (device.getImage() != null ? device.getImage() : "default.jpg"),
                        device.getCustomerName(), device.getCustomerId()
                );
                response.getWriter().write(json);
            }
            return;
        }

        if ("getCustomerDetail".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("customerId"));
            UserProfileDAO uProfileDao = new UserProfileDAO();
            UserProfile profile = uProfileDao.getUserProfileById(userId);
            if (profile != null) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                String json = String.format(
                        "{\"fullname\":\"%s\", \"phone\":\"%s\", \"email\":\"%s\", \"address\":\"%s\", \"avatar\":\"%s\", \"role\":\"%s\"}",
                        profile.getFullname(),
                        profile.getPhone() != null ? profile.getPhone() : "N/A",
                        profile.getEmail(),
                        profile.getAddress() != null ? profile.getAddress() : "N/A",
                        profile.getAvatar() != null ? profile.getAvatar() : "user.jpg",
                        "CUSTOMER"
                );
                response.getWriter().write(json);
            }
            return;
        }

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
            if (name == null) {
                name = "";
            }
            if (status == null || status.equals("All Status")) {
                status = "";
            }
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
private void handleFeedbackDetailPage(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

   int id = Integer.parseInt(request.getParameter("id"));

    FeedbackDAO fDao = new FeedbackDAO();
    MaintenanceFeedback f = fDao.getFeedbackByMaintenanceId(id);

    request.setAttribute("feedback", f);

    request.getRequestDispatcher("/views/TechLeaderView/feedback-detail.jsp")
           .forward(request, response);
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
