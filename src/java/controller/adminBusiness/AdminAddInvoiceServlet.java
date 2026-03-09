package controller.adminBusiness;

import dal.InvoiceDAO;
import dto.MaintenanceDTO;
import dto.SparePartDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class AdminAddInvoiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        InvoiceDAO dao = new InvoiceDAO();
        String midRaw = request.getParameter("maintenanceId");
        if (midRaw != null && !midRaw.isEmpty()) {
            int maintenanceId = Integer.parseInt(midRaw);
            MaintenanceDTO maintenance = dao.getMaintenanceById(maintenanceId);

            List<SparePartDTO> itemList =
                    dao.getSparePartsByMaintenance(maintenanceId);
            double spareTotal = itemList.stream()
                    .mapToDouble(i -> i.getTotal().doubleValue())
                    .sum();

            request.setAttribute("maintenance", maintenance);
            request.setAttribute("itemList", itemList);
            request.setAttribute("spareTotal", spareTotal);

        }

        request.getRequestDispatcher(
                "/views/AdminBusinessView/invoice-add.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        InvoiceDAO dao = new InvoiceDAO();

        int maintenanceId = Integer.parseInt(request.getParameter("maintenanceId"));

        double laborCost = Double.parseDouble(request.getParameter("laborCost"));
        String description = request.getParameter("description");
        double spareTotal = dao.getTotalSpareCostByMaintenance(maintenanceId);
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
                request.getContextPath()
                + "/admin-business/invoicelist"
        );
    }
}