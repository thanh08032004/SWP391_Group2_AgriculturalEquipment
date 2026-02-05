package controller;

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
            user = new User();
            user.setId(4); 
        }

        DeviceDAO dao = new DeviceDAO();
        List<DeviceDTO> myDevices = dao.searchAndFilterPaging("", "Cương Đức", "", "", "", 1, 100);
        
        request.setAttribute("deviceList", myDevices);
        request.getRequestDispatcher("/views/CustomerView/my-devices.jsp").forward(request, response);
    }
}