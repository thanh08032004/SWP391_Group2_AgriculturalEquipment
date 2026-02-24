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

        if ("customer-decision".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String decision = request.getParameter("decision");

            if ("approve".equals(decision)) {
                maintenanceDAO.updateStatus(id, "IN_PROGRESS");
            } else {
                maintenanceDAO.updateStatus(id, "READY");
            }
            response.sendRedirect(request.getContextPath() + "/customer/devices?msg=updated");
        } 
        else {
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

                if (maintenanceDAO.createMaintenanceRequest(deviceId, desc, imagePath)) {
                    response.sendRedirect(request.getContextPath() + "/customer/devices?msg=success");
                }
            }
        }
    }
}