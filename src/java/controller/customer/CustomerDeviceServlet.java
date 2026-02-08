package controller.customer;

import dal.DeviceDAO;
import dto.DeviceDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.User;

public class CustomerDeviceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // FIX: Lấy tên thật của khách hàng đang đăng nhập từ session
        String currentCustomerName = (String) session.getAttribute("userFullname");
        if (currentCustomerName == null) currentCustomerName = ""; 

        DeviceDAO dao = new DeviceDAO();
        // Lọc thiết bị dựa trên tên khách hàng hiện tại
        List<DeviceDTO> myDevices = dao.searchAndFilterPaging("", currentCustomerName, "", "", "", 1, 100);
        
        request.setAttribute("deviceList", myDevices);
        // FIX 404: Đường dẫn tuyệt đối từ gốc Web Pages
        request.getRequestDispatcher("/views/CustomerView/my-devices.jsp").forward(request, response);
    }
}