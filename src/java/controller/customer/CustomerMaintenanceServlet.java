package controller.customer;

import dal.DeviceDAO;
import dal.MaintenanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class CustomerMaintenanceServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int deviceId = Integer.parseInt(request.getParameter("deviceId"));
        request.setAttribute("device", new DeviceDAO().getDeviceById(deviceId));
        request.getRequestDispatcher("/views/CustomerView/maintenance-request.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int deviceId = Integer.parseInt(request.getParameter("deviceId"));
        String description = request.getParameter("description");
        
        Part filePart = request.getPart("image");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String imagePath = "";

        if (fileName != null && !fileName.isEmpty()) {
            String uploadPath = getServletContext().getRealPath("/") + "assets" + File.separator + "images" + File.separator + "maintenance";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            imagePath = deviceId + "_" + System.currentTimeMillis() + "_" + fileName;
            filePart.write(uploadPath + File.separator + imagePath);
        }

        MaintenanceDAO maintenanceDAO = new MaintenanceDAO();
        if (maintenanceDAO.createMaintenanceRequest(deviceId, description, imagePath)) {
            response.sendRedirect(request.getContextPath() + "/customer/devices?msg=success");
        }
    }
}