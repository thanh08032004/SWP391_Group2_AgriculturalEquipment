package controller.technician;

import dal.InvoiceDAO;
import dto.MaintenanceDTO;
import dto.SparePartDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.User;
public class TechnicianAddInvoiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User technician = (User) session.getAttribute("user");
        if (!"TECHNICIAN".equalsIgnoreCase(technician.getRoleName())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        InvoiceDAO dao = new InvoiceDAO();
        List<MaintenanceDTO> maintenanceList =
                dao.getAvailableMaintenancesByTechnician(technician.getId());
        request.setAttribute("maintenanceList", maintenanceList);

        String midRaw = request.getParameter("maintenanceId");

        if (midRaw != null && !midRaw.isEmpty()) {

            int maintenanceId = Integer.parseInt(midRaw);
            boolean valid = dao.checkMaintenanceBelongsToTechnician(
                    maintenanceId,
                    technician.getId()
            );
            if (!valid) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            List<SparePartDTO> itemList =
                    dao.getSparePartsByMaintenance(maintenanceId);

            double spareTotal = itemList.stream()
                    .mapToDouble(i -> i.getTotal().doubleValue())
                    .sum();

            request.setAttribute("itemList", itemList);
            request.setAttribute("spareTotal", spareTotal);
            request.setAttribute("selectedMaintenanceId", maintenanceId);
        }

        request.getRequestDispatcher(
                "/views/technicianView/technician-addinvoice.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User technician = (User) session.getAttribute("user");
        if (!"TECHNICIAN".equalsIgnoreCase(technician.getRoleName())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        InvoiceDAO dao = new InvoiceDAO();

        int maintenanceId = Integer.parseInt(
                request.getParameter("maintenanceId"));
        boolean valid = dao.checkMaintenanceBelongsToTechnician(
                maintenanceId,
                technician.getId()
        );

        if (!valid) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        double laborCost = Double.parseDouble(
                request.getParameter("laborCost"));

        String description = request.getParameter("description");

        double spareTotal =
                dao.getTotalSpareCostByMaintenance(maintenanceId);

        double totalAmount = spareTotal + laborCost;
        dao.insertInvoice(
                maintenanceId,
                null,
                laborCost,
                0, 
                totalAmount,
                description
        );

        response.sendRedirect(
                request.getContextPath() + "/technician/invoicelist"
        );
    }
}