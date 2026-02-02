package controller.customer;

import dal.MaintenanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.User;

@WebServlet(name = "CustomerMaintenanceServlet", urlPatterns = {"/customer/maintenance"})
public class CustomerMaintenanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }

        MaintenanceDAO dao = new MaintenanceDAO();
        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            if ("view-diagnosis".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("maintenance", dao.findMaintenanceById(id));
                request.setAttribute("items", dao.getMaintenanceItems(id));
                request.getRequestDispatcher("/views/CustomerView/maintenance-diagnosis.jsp").forward(request, response);
            } else {
                request.setAttribute("myRequests", dao.getMaintenanceByCustomerId(user.getId()));
                request.getRequestDispatcher("/views/CustomerView/maintenance-list.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/errors/500.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        int id = Integer.parseInt(request.getParameter("id"));
        MaintenanceDAO dao = new MaintenanceDAO();

        if ("accept".equals(action)) {
            dao.updateStatus(id, "CUSTOMER_ACCEPTED");
        } else if ("decline".equals(action)) {
            dao.updateStatus(id, "CANCELED");
        }
        response.sendRedirect(request.getContextPath() + "/customer/maintenance?action=list");
    }
}