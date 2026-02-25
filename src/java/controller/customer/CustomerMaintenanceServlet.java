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

    // TÌNH HUỐNG 1: Khách hàng phản hồi báo giá (Accept hoặc Reject)
    if ("customer-decision".equals(action)) {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String decision = request.getParameter("decision");

            // Lấy thông tin ca bảo trì để xác định deviceId liên quan
            model.Maintenance m = maintenanceDAO.getMaintenanceById(id);

            if ("approve".equals(decision)) {
                // 1. Chuyển trạng thái bảo trì sang đang tiến hành sửa chữa
                maintenanceDAO.updateStatus(id, "IN_PROGRESS");
                // 2. Cập nhật trạng thái thiết bị thành MAINTENANCE để ẩn nút Request Service trên giao diện
                deviceDAO.updateDeviceStatus(m.getDeviceId(), "MAINTENANCE");
            } else {
                // 1. Chuyển trạng thái bảo trì về READY (hoặc CANCELED tùy bạn thiết kế)
                maintenanceDAO.updateStatus(id, "READY");
                // 2. Trả trạng thái thiết bị về READY để khách có thể gửi yêu cầu khác nếu muốn
                deviceDAO.updateDeviceStatus(m.getDeviceId(), "READY");
            }
            response.sendRedirect(request.getContextPath() + "/customer/devices?msg=updated");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/customer/devices?error=system_error");
        }
    } 
    // TÌNH HUỐNG 2: Khách hàng tạo yêu cầu bảo trì mới (Request Service)
    else {
        try {
            String deviceIdStr = request.getParameter("deviceId");
            if (deviceIdStr != null) {
                int deviceId = Integer.parseInt(deviceIdStr);
                String desc = request.getParameter("description");
                
                // Xử lý upload ảnh minh họa lỗi từ khách hàng
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

                // Thực hiện tạo bản ghi bảo trì mới
                if (maintenanceDAO.createMaintenanceRequest(deviceId, desc, imagePath)) {
                    // NGAY LÚC NÀY: Chuyển trạng thái thiết bị sang MAINTENANCE để hiện "Processing..."
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