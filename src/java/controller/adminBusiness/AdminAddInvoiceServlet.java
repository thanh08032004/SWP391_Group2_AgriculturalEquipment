package controller.adminBusiness;

import dal.InvoiceDAO;
import dto.MaintenanceDTO;
import dto.SparePartDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
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

        int maintenanceId =
                Integer.parseInt(request.getParameter("maintenanceId"));

        String description = request.getParameter("description");

        Integer voucherId = null;

        String voucherRaw = request.getParameter("voucherId");

        if (voucherRaw != null && !voucherRaw.isEmpty()) {
            voucherId = Integer.parseInt(voucherRaw);
        }
        double laborCost = dao.getLaborCostByMaintenance(maintenanceId);

        double spareTotal =
                dao.getTotalSpareCostByMaintenance(maintenanceId);

        double totalAmount = laborCost + spareTotal;

        dao.insertInvoice(
                maintenanceId,
                voucherId,
                laborCost,
                0,
                totalAmount,
                description
        );

        response.sendRedirect(
                request.getContextPath()
                + "/admin-business/invoice/list"
        );
    }
}