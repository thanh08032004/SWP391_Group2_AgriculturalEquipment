package controller.techLeader;

import dal.DeviceDAO;
import dal.FeedbackDAO;
import dal.MaintenanceDAO;
import dal.UserProfileDAO;
import dto.DeviceDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import model.Maintenance;
import model.MaintenanceFeedback;
import model.UserProfile;

public class LeaderMaintenanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        MaintenanceDAO dao = new MaintenanceDAO();
        DeviceDAO dDao = new DeviceDAO();

        switch (action) {
            case "getDeviceDetail":
                handleGetDeviceDetail(request, response, dDao);
                break;
            case "getCustomerDetail":
                handleGetCustomerDetail(request, response);
                break;
            case "detail":
                handleViewDetail(request, response, dao);
                break;
            case "feedback-detail":
                handleFeedbackDetailPage(request, response);
                break;
            case "list":
            default:
                handleListRequests(request, response, dao);
                break;
        }
    }

    private void handleViewDetail(HttpServletRequest request, HttpServletResponse response, MaintenanceDAO dao) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        Maintenance task = dao.getMaintenanceById(id);
        List<Map<String, Object>> items = dao.getMaintenanceItemsWithPrice(id);
        List<model.User> technicians = dao.getAllTechnicians();
        double laborRate = 100000;
        request.setAttribute("laborRate", laborRate);
        request.setAttribute("task", task);
        request.setAttribute("items", items);
        request.setAttribute("technicians", technicians);
        request.getRequestDispatcher("/views/TechLeaderView/maintenance-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        MaintenanceDAO dao = new MaintenanceDAO();
        int id = Integer.parseInt(request.getParameter("id"));
        String from = request.getParameter("from");

        if ("send-to-customer".equals(action)) {
            boolean success = dao.updateStatus(id, "DIAGNOSIS READY");
            response.sendRedirect("maintenance?msg=" + (success ? "sent_success" : "error"));
        } else if ("reject-diagnosis".equals(action)) {
            boolean updateStatus = dao.updateStatus(id, "TECHNICIAN_ACCEPTED");
            boolean clearItems = dao.saveMaintenanceItems(id, new ArrayList<>(), new ArrayList<>());

            if (updateStatus && clearItems) {
                response.sendRedirect("maintenance?action=detail&id=" + id + "&msg=rejected_and_cleared");
            } else {
                response.sendRedirect("maintenance?action=detail&id=" + id + "&msg=error");
            }
        } else if ("assign".equals(action)) {
            String techIdRaw = request.getParameter("technicianId");
            int techId = (techIdRaw == null || techIdRaw.isEmpty()) ? 0 : Integer.parseInt(techIdRaw);
            boolean success = dao.assignTechnician(id, techId);
            String redirectUrl = "";
            if ("list".equals(from)) {
                redirectUrl = "maintenance?action=list&msg=" + (success ? "assign_success" : "error");
            } else {
                redirectUrl = "maintenance?action=detail&id=" + id + "&msg=" + (success ? "assign_success" : "error");
            }

            response.sendRedirect(redirectUrl);
        }
    }

    private void handleGetDeviceDetail(HttpServletRequest request, HttpServletResponse response, DeviceDAO dDao) throws IOException {
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

    private void handleGetCustomerDetail(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = Integer.parseInt(request.getParameter("customerId"));
        UserProfileDAO uProfileDao = new UserProfileDAO();
        UserProfile profile = uProfileDao.getUserProfileById(userId);
        String avatar = profile.getAvatar();
        if (avatar == null || avatar.trim().isEmpty()) {
            avatar = "user.jpg";
        }
        if (profile != null) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String json = String.format(
                    "{\"fullname\":\"%s\", \"phone\":\"%s\", \"email\":\"%s\", \"address\":\"%s\", \"avatar\":\"%s\", \"role\":\"%s\"}",
                    profile.getFullname(),
                    profile.getPhone() != null ? profile.getPhone() : "N/A",
                    profile.getEmail(),
                    profile.getAddress() != null ? profile.getAddress() : "N/A",
                    avatar,
                    "CUSTOMER"
            );
            response.getWriter().write(json);
        }
    }

    private void handleListRequests(HttpServletRequest request, HttpServletResponse response, MaintenanceDAO dao) throws ServletException, IOException {
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
        request.setAttribute("currentStatus", status.isEmpty() ? "All Status" : status);

        request.getRequestDispatcher("/views/TechLeaderView/maintenance-list.jsp").forward(request, response);
    }

}
