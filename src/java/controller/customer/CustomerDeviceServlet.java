package controller.customer;

import dal.DeviceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;
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

        DeviceDAO dao = new DeviceDAO();
        List<Map<String, Object>> myDevices = dao.getDevicesByCustomerCustom(user.getId());
        
        request.setAttribute("deviceList", myDevices);
        
        request.getRequestDispatcher("/views/CustomerView/my-devices.jsp").forward(request, response);
    }
}