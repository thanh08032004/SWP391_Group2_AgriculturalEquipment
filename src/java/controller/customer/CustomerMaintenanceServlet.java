package controller.customer;

import dal.DeviceDAO;
import dal.MaintenanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import model.Maintenance;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, 
    maxFileSize = 1024 * 1024 * 10, 
    maxRequestSize = 1024 * 1024 * 15
)
public class CustomerMaintenanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        MaintenanceDAO maintenanceDAO = new MaintenanceDAO();

        if ("view-detail".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                Maintenance task = maintenanceDAO.getMaintenanceById(id);
                List<Map<String, Object>> items = maintenanceDAO.getMaintenanceItemsWithPrice(id);

                request.setAttribute("task", task);
                request.setAttribute("items", items);
                request.getRequestDispatcher("/views/CustomerView/maintenance-status-detail.jsp").forward(request, response);
            }
        } 
        else {
            String deviceIdStr = request.getParameter("deviceId");
            if (deviceIdStr != null) {
                int deviceId = Integer.parseInt(deviceIdStr);
                request.setAttribute("device", new DeviceDAO().getDeviceById(deviceId));
                request.getRequestDispatcher("/views/CustomerView/maintenance-request.jsp").forward(request, response);
            }
        }
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    String action = request.getParameter("action");
    MaintenanceDAO maintenanceDAO = new MaintenanceDAO();
    DeviceDAO deviceDAO = new DeviceDAO();

    // doi khach quyet dinh accept hay reject
    if ("customer-decision".equals(action)) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String decision = request.getParameter("decision");

            // lay thong tin ca bao tri de xac dinh device id lien quan
            model.Maintenance m = maintenanceDAO.getMaintenanceById(id);

            if ("approve".equals(decision)) {
                ///chuyen sang trang thai sua chua
                maintenanceDAO.updateStatus(id, "IN_PROGRESS");
                deviceDAO.updateDeviceStatus(m.getDeviceId(), "MAINTENANCE");
            } else {
                maintenanceDAO.updateStatus(id, "READY");
                deviceDAO.updateDeviceStatus(m.getDeviceId(), "ACTIVE");
            }
            response.sendRedirect(request.getContextPath() + "/customer/devices?msg=updated");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/devices?error=system_error");
        }
    } 
    //new req
    else {
        try {
            String deviceIdStr = request.getParameter("deviceId");
            if (deviceIdStr != null) {
                int deviceId = Integer.parseInt(deviceIdStr);
                String desc = request.getParameter("description");
                
                Part part = request.getPart("image");
                String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String imagePath = "default.jpg";

                if (fileName != null && !fileName.isEmpty()) {
                    String uploadPath = getServletContext().getRealPath("/") + "assets/images/maintenance";
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();
                    
                    imagePath = deviceId + "_" + System.currentTimeMillis() + "_" + fileName;
                    part.write(uploadPath + File.separator + imagePath);
                }

                // tao ban ghi bao tri moi
                if (maintenanceDAO.createMaintenanceRequest(deviceId, desc, imagePath)) {
                    deviceDAO.updateDeviceStatus(deviceId, "MAINTENANCE");
                    response.sendRedirect(request.getContextPath() + "/customer/devices?msg=success");
                } else {
                    response.sendRedirect(request.getContextPath() + "/customer/devices?msg=error");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/devices?msg=error");
        }
    }
}
}