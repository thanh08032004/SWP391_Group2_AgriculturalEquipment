package controller.adminBusiness;

import dal.MaintenanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AdminMaintenanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";
        MaintenanceDAO dao = new MaintenanceDAO();

        switch (action) {
            case "list":
                request.setAttribute("reqList", dao.getRequestsForAdmin());
                request.getRequestDispatcher("/views/AdminBusinessView/maintenance-list.jsp").forward(request, response);
                break;
                
            case "approve-to-staff":
                int id1 = Integer.parseInt(request.getParameter("id"));
                dao.updateStatus(id1, "WAITING_FOR_STAFF");
                response.sendRedirect("maintenance?action=list");
                break;
                
            case "send-to-customer":
                int id2 = Integer.parseInt(request.getParameter("id"));
                dao.updateStatus(id2, "WAITING_FOR_CUSTOMER");
                response.sendRedirect("maintenance?action=list");
                break;
        }
    }
}