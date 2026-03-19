package controller.customer;
import dal.DeviceDAO;
import dal.MaintenanceDAO;
import dal.UserProfileDAO;
import dto.DeviceDTO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;
import model.Maintenance;
import model.UserProfile;

public class CustomerMaintenanceDetailServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CustomerMaintenanceDetailServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CustomerMaintenanceDetailServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
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
        
        MaintenanceDAO dao = new MaintenanceDAO();
                    double laborRate = 100000.0;
            int id = Integer.parseInt(request.getParameter("id"));
            Maintenance task = dao.getMaintenanceById(id);
            List<Map<String, Object>> items = dao.getMaintenanceItemsWithPrice(id);
            request.setAttribute("task", task);
            request.setAttribute("items", items);
            request.setAttribute("laborRate", laborRate);
            request.getRequestDispatcher("/views/CustomerView/customer-maintenancedetail.jsp").forward(request, response);
    } 


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
