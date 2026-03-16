package controller.adminBusiness;

import dal.InvoiceDAO;
import dto.MaintenanceDTO;
import dto.SparePartDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import model.Maintenance;
import model.UserProfile;

public class AdminAddInvoiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        InvoiceDAO dao = new InvoiceDAO();
    String action = request.getParameter("action");

    // ===== CUSTOMER DETAIL =====
    if ("getCustomerDetail".equals(action)) {

        int id = Integer.parseInt(request.getParameter("id"));
        UserProfile c = dao.getCustomerDetail(id);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (c != null) {
            out.print("{");
            out.print("\"fullname\":\"" + c.getFullname() + "\",");
            out.print("\"email\":\"" + c.getEmail() + "\",");
            out.print("\"phone\":\"" + c.getPhone() + "\",");
            out.print("\"gender\":\"" + c.getGender() + "\",");
            out.print("\"birthDate\":\"" + c.getBirthDate() + "\",");
            out.print("\"address\":\"" + c.getAddress() + "\",");
            out.print("\"avatar\":\"" + c.getAvatar() + "\"");
            out.print("}");
        }
        return;
    }

    // ===== MAINTENANCE DETAIL =====
    if ("getMaintenanceDetail".equals(action)) {

        int id = Integer.parseInt(request.getParameter("id"));
        Maintenance m = dao.getMaintenanceDetail(id);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (m != null) {
            out.print("{");
            out.print("\"id\":" + m.getId() + ",");
            out.print("\"machineName\":\"" + m.getMachineName() + "\",");
            out.print("\"problem\":\"" + m.getDescription() + "\",");
            out.print("\"status\":\"" + m.getStatus() + "\",");
            out.print("\"startDate\":\"" + m.getStartDate() + "\",");
            out.print("\"finishDate\":\"" + m.getEndDate() + "\"");
            out.print("}");
        }
        return;
    }

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